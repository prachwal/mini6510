; blk_reu.s - urządzenie blokowe C64: REU (blok 256 B = adres REU blok*256, bank = starszy bajt numeru)
        .include "bios.inc"
        .include "hw.inc"
        .export ReadBlk, WriteBlk, LdrRead
        .segment "BIOS"

LdrRead:                        ; X/Y = blok, ptr = bufor; C=1 błąd
ReadBlk:
        lda #REU_FETCH
        bne BlkDo
WriteBlk:
        lda #REU_STASH
BlkDo:  sta tmp2
        lda reu_banks           ; 0 = 256 banków (bez sprawdzania)
        beq @ok
        cpy reu_banks
        bcc @ok
        lda #1                  ; poza zakresem
        sec
        rts
@ok:    stx REU_MID
        sty REU_BANK
        lda #0
        sta REU_LO
        sta REU_LENLO
        sta REU_ACTL            ; oba adresy rosną
        lda #1
        sta REU_LENHI           ; 256 bajtów
        lda ptr
        sta REU_C64LO
        lda ptr+1
        sta REU_C64HI
        lda tmp2
        sta REU_CMD             ; DMA wykonuje się od razu (CPU wstrzymany)
        clc
        rts
