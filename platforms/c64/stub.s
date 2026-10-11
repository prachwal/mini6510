; stub.s - program ładowany do $0801: wiersz BASIC "10 SYS2061" + kopiowanie BIOS do $F800 i start
        .include "bios.inc"
        .import __JUMPTAB_LOAD__, __BIOS_LOAD__, __BIOS_SIZE__
        .import Reset

        .segment "LOADADDR"
        .word $0801

        .segment "STUB"
        .word @next
        .word 10
        .byte $9E, "2061", 0    ; SYS 2061 = $080D
@next:  .word 0
        jmp Boot                ; $080D; jądro zaczyna się równo od $0810 (KBASE)

        .segment "BOOT"
Boot:   sei
        cld
        ldx #$FF
        txs
        lda #$2F
        sta $00
        lda #$34                ; cały RAM (bez ROM i I/O)
        sta $01
        lda #<__BIOS_LOAD__     ; reszta BIOS -> $E800
        ldy #>__BIOS_LOAD__
        ldx #>(__BIOS_SIZE__ + 255)
        stx tmp
        lda #<__BIOS_LOAD__
        sta ptr
        sty ptr+1
        lda #0
        sta ptr2
        lda #$E8
        sta ptr2+1
        jsr Copy
        lda #<__JUMPTAB_LOAD__  ; tablica skoków -> $F800
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
        lda #$35                ; RAM + I/O
        sta $01
        jmp Reset

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
