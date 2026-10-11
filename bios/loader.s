; Loader systemu z dysku blokowego (ca65)
; Zakłada: RAM przetestowany, shadow aktywny, procedury PrintStr/PutChar/PutCRLF w BIOS.
;
; Format dysku (napęd 0, bloki 256 B):
;   blok 0 (nagłówek): +0,+1 adres ładowania (lo,hi), +2 liczba bloków danych (1..255),
;                      +3,+4 adres startowy (lo,hi)
;   bloki 1..n: dane, kolejno pod adres ładowania.
; Warunki: adres ładowania >= $0200, obraz kończy się nie wyżej niż $D800 (przed I/O).
; Przy sukcesie nie wraca (skok do adresu startowego, I=1, D=0).
; Przy błędzie wypisuje "BOOT ERROR n" i zatrzymuje się.
; Limit czasu operacji dysku: 65536 obiegów (ok. 16 cykli każdy, ok. 1 s przy 1 MHz).

        .include "bios.inc"
        .import PrintStr, PutChar, PutCRLF
        .export LoadSystem, ReadBlk, WriteBlk

HDR         = $0200             ; bufor nagłówka (przetestowany RAM)
LOAD_MIN_HI = $02
IO_START_HI = $D8

        .segment "BIOS"

LoadSystem:
        sei
        cld
        lda #<MsgLoad
        sta ptr2
        lda #>MsgLoad
        sta ptr2+1
        jsr PrintStr

        lda #0
        sta BLK_UNIT            ; napęd 0

        lda #<HDR               ; blok 0 -> HDR
        sta ptr
        lda #>HDR
        sta ptr+1
        ldx #0
        ldy #0
        jsr ReadBlk
        bcs Fail                ; A = kod błędu

        ; ---- walidacja nagłówka ----
        lda HDR+1               ; adres ładowania, starszy bajt
        cmp #LOAD_MIN_HI
        bcc BadHdr              ; poniżej $0200
        lda HDR+2               ; liczba bloków
        beq BadHdr
        clc
        adc HDR+1               ; koniec = ładowanie + bloki*256
        bcs BadHdr              ; przekroczenie $FFFF
        cmp #IO_START_HI
        bcc @fits               ; koniec poniżej $D800
        bne BadHdr              ; koniec powyżej $D800
        lda HDR+0               ; koniec w $D8xx: dozwolone tylko dokładnie $D800
        bne BadHdr
@fits:
        lda HDR+0
        sta ptr
        lda HDR+1
        sta ptr+1
        lda HDR+2
        sta ldr_cnt
        lda HDR+3
        sta ldr_entry
        lda HDR+4
        sta ldr_entry+1

        ldx #1                  ; numer bloku danych
@next:  ldy #0
        jsr ReadBlk             ; X, Y = numer bloku, ptr = adres bufora (X zachowany)
        bcs Fail
        inc ptr+1               ; następne 256 B
        dec ldr_cnt
        beq @go
        inx
        jmp @next
@go:
        sei
        cld
        jmp (ldr_entry)

BadHdr:
        lda #ERR_HEADER
Fail:                           ; A = kod błędu
        pha
        lda #<MsgErr
        sta ptr2
        lda #>MsgErr
        sta ptr2+1
        jsr PrintStr
        pla
        clc
        adc #'0'
        jsr PutChar
        jsr PutCRLF
@halt:  jmp @halt

; ---- czytanie bloku ----
; Wejście: X = numer bloku (lo), Y = numer bloku (hi), ptr = adres bufora.
; Wyjście: C=0 OK. C=1 błąd, A = kod (1-5 z urządzenia, ERR_TIMEOUT przy limicie czasu).
; X zachowany.
ReadBlk:
        lda #BLK_CMD_READ
        bne BlkDo
WriteBlk:                       ; jak ReadBlk, ale zapis (bufor ptr -> blok)
        lda #BLK_CMD_WRITE
BlkDo:  sta tmp2
        stx BLK_LO
        sty BLK_HI
        lda ptr
        sta BLK_ADDR_LO
        lda ptr+1
        sta BLK_ADDR_HI
        lda tmp2
        sta BLK_CMD
        lda #0
        sta ldr_tmo
        sta ldr_tmo+1
@wait:  lda BLK_STATUS          ; BUSY ustawione od razu po zapisie CMD
        and #BLK_ST_BUSY
        beq @done
        inc ldr_tmo
        bne @wait
        inc ldr_tmo+1
        bne @wait
        lda #ERR_TIMEOUT
        sec
        rts
@done:  lda BLK_STATUS
        and #BLK_ST_ERR
        beq @ok
        lda BLK_ERR
        sec
        rts
@ok:    clc
        rts

MsgLoad: .byte "LOADING SYSTEM", 13, 10, 0
MsgErr:  .byte "BOOT ERROR ", 0
