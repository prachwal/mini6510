; GREET.COM - prints "Hello, <argv[1]>!" (default "world").
; Shows the program ABI: A = argc, X/Y = pointer to argv table of 16-bit pointers.
        .include "sys.inc"
ac = $E0
av = $E2
        .segment "CODE"
        sta ac
        stx av
        sty av+1
        lda #<msg
        ldx #>msg
        jsr k_puts
        lda ac
        cmp #2
        bcc @w
        ldy #2                  ; argv[1] is at offset 2
        lda (av),y
        pha
        iny
        lda (av),y
        tax
        pla
        jmp @p
@w:     lda #<world
        ldx #>world
@p:     jsr k_puts
        lda #'!'
        jsr k_putc
        lda #10
        jsr k_putc
        lda #0
        rts
msg:    .byte "Hello, ", 0
world:  .byte "world", 0
