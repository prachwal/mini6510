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
        .include "hw.inc"        ; IO_START_HI, LOAD_MIN_HI (platforma)
        .import PrintStr, PutChar, PutCRLF
        .import LdrRead          ; platforma: czytaj blok z napędu 0 (X/Y = blok, ptr = bufor), C=1 błąd
        .export LoadSystem

HDR         = $0200             ; bufor nagłówka (przetestowany RAM)

        .segment "BIOS"

LoadSystem:
        sei
        cld
        lda #<MsgLoad
        sta ptr2
        lda #>MsgLoad
        sta ptr2+1
        jsr PrintStr

        lda #<HDR               ; blok 0 -> HDR
        sta ptr
        lda #>HDR
        sta ptr+1
        ldx #0
        ldy #0
        jsr LdrRead
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
        jsr LdrRead             ; X, Y = numer bloku, ptr = adres bufora (X zachowany)
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

MsgLoad: .byte "LOADING SYSTEM", 13, 10, 0
MsgErr:  .byte "BOOT ERROR ", 0
