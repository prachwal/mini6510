; blk.s - urządzenie blokowe platformy 'generic' ($DF10-$DF18)
        .include "bios.inc"
        .include "hw.inc"
        .export ReadBlk, WriteBlk, LdrRead
        .segment "BIOS"

LdrRead:                        ; napęd 0, X/Y = blok, ptr = bufor; C=1 błąd (A = kod)
        lda #0
        sta BLK_UNIT
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

