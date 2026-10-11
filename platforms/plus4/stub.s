; stub.s - start z cartridge Plus/4 (CART-1, $8000): KERNAL po resecie szuka "CBM" pod $8007 i bajtu 1 pod $8006,
; wtedy wywołuje JSR $8000 (przed inicjalizacją KERNAL-a). Kopiujemy BIOS do RAM ($E700, $F800) i przejmujemy maszynę.
        .include "bios.inc"
        .include "platform.inc"
        .include "hw.inc"
        .import __JUMPTAB_LOAD__, __BIOS_LOAD__, __BIOS_SIZE__, __DRV_LOAD__, __DRV_SIZE__
        .import Reset

        .segment "CARTHDR"
        jmp Boot                ; $8000 start
        jmp Boot                ; $8003 (drugi wektor)
        .byte 1                 ; $8006 identyfikator: autostart
        .byte "CBM"             ; $8007 sygnatura

        .segment "BOOT"
Boot:   sei
        cld
        ldx #$FF
        txs
        lda #<__BIOS_LOAD__
        sta ptr
        lda #>__BIOS_LOAD__
        sta ptr+1
        lda #0
        sta ptr2
        lda #$E7
        sta ptr2+1
        lda #<(__BIOS_SIZE__ + __DRV_SIZE__)
        sta tmp
        lda #>(__BIOS_SIZE__ + __DRV_SIZE__)
        sta tmp2
        jsr CopyN               ; zapis pod $E700 trafia do RAM (pod ROM)
        lda #<__JUMPTAB_LOAD__
        sta ptr
        lda #>__JUMPTAB_LOAD__
        sta ptr+1
        lda #0
        sta ptr2
        lda #$F8
        sta ptr2+1
        lda #1
        sta tmp
        jsr Copy
        ldx #TrampEnd - Tramp - 1   ; ostatni krok z RAM: po $FF3F cartridge znika
@t:     lda Tramp,x
        sta $0334,x
        dex
        bpl @t
        jmp $0334

Tramp:  sta TED_RAMON           ; RAM zamiast ROM
        jmp Reset
TrampEnd:

Copy:   ldy #0                  ; ptr -> ptr2, tmp = liczba stron
@c:     lda (ptr),y
        sta (ptr2),y
        iny
        bne @c
        inc ptr+1
        inc ptr2+1
        dec tmp
        bne @c
        rts

CopyN:  ldy #0                  ; ptr -> ptr2, liczba bajtów w tmp (lo) / tmp2 (hi)
@c:     lda tmp
        ora tmp2
        beq @d
        lda (ptr),y
        sta (ptr2),y
        inc ptr
        bne @a
        inc ptr+1
@a:     inc ptr2
        bne @b
        inc ptr2+1
@b:     lda tmp
        bne @e
        dec tmp2
@e:     dec tmp
        jmp @c
@d:     rts
