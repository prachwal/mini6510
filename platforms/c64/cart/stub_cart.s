; stub_cart.s - start z cartridge Magic Desk (bank 0 pod $8000): KERNAL widzi CBM80 i skacze tutaj.
; Kopiuje BIOS do RAM ($E800, $F800), potem wyłącza ROM-y z kodu w RAM (kod w cartridge nie może zmienić $01).
        .include "bios.inc"
        .import __JUMPTAB_LOAD__, __BIOS_LOAD__, __BIOS_SIZE__, __DRV_LOAD__, __DRV_SIZE__
        .import Reset

        .segment "CARTHDR"
        .word Boot              ; $8000 cold start
        .word Boot              ; $8002 warm start (NMI)
        .byte $C3, $C2, $CD, '8', '0'   ; "CBM80"

        .segment "BOOT"
Boot:   sei
        cld
        ldx #$FF
        txs
        lda #$37                ; KERNAL sprawdza CBM80 jako pierwszy krok resetu, jeszcze przed IOINIT:
        sta $01                 ; zatrzask portu = $37 PRZED ustawieniem DDR (inaczej bity 0-2 = 0 -> RAM, cartridge znika)
        lda #$2F
        sta $00
        lda #<__BIOS_LOAD__
        sta ptr
        lda #>__BIOS_LOAD__
        sta ptr+1
        lda #0
        sta ptr2
        lda #$E8
        sta ptr2+1
        lda #>(__BIOS_SIZE__ + 255)
        sta tmp
        jsr Copy
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
        lda #<__DRV_LOAD__      ; sterownik napędu -> $F900
        sta ptr
        lda #>__DRV_LOAD__
        sta ptr+1
        lda #0
        sta ptr2
        lda #$F9
        sta ptr2+1
        lda #>(__DRV_SIZE__ + 255)
        sta tmp
        jsr Copy
        ldx #TrampEnd - Tramp - 1   ; ostatni krok z RAM: po $01=$35 cartridge znika
@t:     lda Tramp,x
        sta $0334,x
        dex
        bpl @t
        jmp $0334

Tramp:  lda #$35                ; RAM + I/O
        sta $01
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
