; blk_cart.s - nośnik blokowy wariantu cartridge (Magic Desk): REU (zapisywalny) albo dysk w ROM (tylko odczyt)
        .include "bios.inc"
        .include "hw.inc"
        .export ReadBlk, WriteBlk, RomRdStart, RomRdEnd
        .import ReuRead, ReuWrite
        .segment "BIOS"

ReadBlk:                        ; X/Y = blok, ptr = bufor; C=1 błąd (A = kod)
        lda blk_mode
        bne @rom
        jmp ReuRead
@rom:   jmp RAMCODE             ; czytnik banków skopiowany do RAM przez CartInit
WriteBlk:
        lda blk_mode
        bne @ro
        jmp ReuWrite
@ro:    lda #3                  ; ROM tylko do odczytu (BLK_ERR 3)
        sec
        rts

; ---- czytnik banków: kopiowany pod RAMCODE. Kod niezależny od położenia (tylko skoki względne).
; Musi działać z RAM poniżej $8000, bo przy $01=$37 widać cartridge ($8000) i KERNAL ($E000).
; Wejście: X/Y = numer bloku, ptr = bufor. Wyjście: C=1 błąd. X/Y zachowane, $01 przywrócone, I przywrócone.
RomRdStart:
        cpy #ROM_BLK_HI+1
        bcs @bad
        cpy #ROM_BLK_HI
        bne @ok
        cpx #ROM_BLK_LO
        bcs @bad
@ok:    php
        sei
        txa
        pha
        tya
        pha
        txa
        and #$1F                ; blok w banku (0..31)
        ora #$80
        sta RAMCODE + (@src - RomRdStart) + 2   ; starszy bajt adresu $80xx (modyfikacja kopii w RAM, nie obrazu BIOS)
        txa
        lsr
        lsr
        lsr
        lsr
        lsr                     ; X >> 5
        sta RAMCODE + (@add - RomRdStart) + 1
        tya
        asl
        asl
        asl                     ; Y * 8
        sec                     ; +1: bank 0 to boot
@add:   adc #0
        tax                     ; X = numer banku
        lda $01
        pha
        lda #$37                ; widać ROML i I/O
        sta $01
        stx MD_REG
        ldy #0
@src:   lda $8000,y
        sta (ptr),y
        iny
        bne @src
        pla
        sta $01
        pla
        tay
        pla
        tax
        plp
        clc
        rts
@bad:   lda #1
        sec
        rts
RomRdEnd:
        .assert RomRdEnd - RomRdStart <= RAMCODE_LEN, error, "reader too long for RAMCODE_LEN"
