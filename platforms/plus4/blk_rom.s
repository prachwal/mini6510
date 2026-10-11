; blk_rom.s - nośnik blokowy Plus/4: dysk w ROM cartridge (CART-1) + zapisywalna nakładka w RAM
;   bloki 0..43   -> c1lo ($8000-$BFFF), od $9400 (pierwsze 5 KB zajmuje BIOS)
;   bloki 44..103 -> c1hi ($C000-$FBFF)
; Strona źródłowa = numer bloku + $94 (dla obu okien). ROM widać tylko przy $FF3E, więc czytnik kopiowany jest do RAM
; (RAMCODE) i działa z maskowanymi przerwaniami (IRQ przy ROM szedłby przez KERNAL).
        .include "bios.inc"
        .include "platform.inc"
        .include "hw.inc"
        .export ReadBlk, WriteBlk, RomRdStart, RomRdEnd
        .segment "BIOS"

; Zapisy trafiają do nakładki w RAM: OVL_SLOTS stron od $D000 (obszar wolny, jądro go nie używa) + tablica numerów
; bloków (ovl_map). Odczyt najpierw sprawdza nakładkę, potem ROM. Nakładka znika przy resecie (jak RAM-dysk).
; Zachowują X i Y (loader), C=1 błąd: A=1 numer bloku poza dyskiem, A=5 nakładka pełna.
ReadBlk:                        ; X/Y = blok, ptr = bufor
        jsr OvlFind             ; C=0: A = numer slotu
        bcs @rom
        clc
        adc #OVL_PAGE0
        sta ptr2+1
        lda #0
        sta ptr2
        ldy #0
@c:     lda (ptr2),y
        sta (ptr),y
        iny
        bne @c
        clc
        rts
@rom:   ldy #0
        jmp RAMCODE

WriteBlk:
        cpy #0
        bne @bad
        cpx #DISK_BLOCKS
        bcs @bad
        jsr OvlFind
        bcc @have
        ldy ovl_cnt
        cpy #OVL_SLOTS
        bcs @full
        txa
        sta ovl_map,y           ; nowy slot dla tego bloku
        inc ovl_cnt
        tya
@have:  clc
        adc #OVL_PAGE0
        sta ptr2+1
        lda #0
        sta ptr2
        ldy #0
@w:     lda (ptr),y
        sta (ptr2),y
        iny
        bne @w
        clc
        rts
@full:  ldy #0
        lda #5                  ; brak miejsca w nakładce
        sec
        rts
@bad:   ldy #0
        lda #1
        sec
        rts

OvlFind:                        ; X = blok -> C=0, A = slot; C=1 brak. Y = 0 po powrocie
        ldy ovl_cnt
@l:     dey
        bmi @no
        txa
        cmp ovl_map,y
        bne @l
        tya
        ldy #0
        clc
        rts
@no:    ldy #0
        sec
        rts

; ---- czytnik: kopiowany pod RAMCODE, kod niezależny od położenia (poza samomodyfikacją kopii).
; Wejście: X/Y = numer bloku, ptr = bufor. Wyjście: C=1 błąd. X/Y zachowane, I przywrócone, RAM widoczny.
RomRdStart:
        cpy #0
        bne @bad
        cpx #DISK_BLOCKS
        bcs @bad
        php
        sei
        txa
        pha
        tya
        pha
        txa
        clc
        adc #$94                ; strona źródła
        sta RAMCODE + (@src - RomRdStart) + 2     ; modyfikacja kopii w RAM
        ldy #2                  ; n = 2: CART-1 niski ($8000)
        cpx #ROM_SPLIT
        bcc @sel
        ldy #8                  ; n = 8: CART-1 wysoki ($C000)
@sel:   sta ROM_BANK,y          ; wybór banku ROM (liczy się adres)
        sta TED_ROMON           ; ROM widoczny
        ldy #0
@src:   lda $8000,y
        sta (ptr),y
        iny
        bne @src
        sta ROM_BANK            ; z powrotem wewnętrzne ROM-y: znaki TED ($D400) są brane z ROM-u wysokiego
        sta TED_RAMON           ; RAM widoczny
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
