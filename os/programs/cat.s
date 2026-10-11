; CAT.COM [plik] - kopiuje plik (lub stdin) na stdout
        .include "sys.inc"
fd = $E0
cnt = $E1
av = $E2
        .segment "BSS"
BUF:    .res 256
        .segment "CODE"
        stx av
        sty av+1
        cmp #2
        bcs @file
@in:    jsr k_getc
        bcs @done
        jsr k_putc
        jmp @in
@done:  lda #0
        rts
@file:  ldy #3
        lda (av),y
        tax
        dey
        lda (av),y
        jsr k_open
        bcc @o
        pha
        lda #<pre
        ldx #>pre
        jsr k_eputs
        pla
        jsr k_strerror
        jsr k_eputs
        lda #<nl
        ldx #>nl
        jsr k_eputs
        lda #1
        rts
@o:     sta fd
@r:     lda #<BUF
        sta bp
        lda #>BUF
        sta bp+1
        lda fd
        ldy #0
        jsr k_read
        beq @x
        sta cnt
        ldy #0
@p:     lda BUF,y
        jsr k_putc
        iny
        cpy cnt
        bne @p
        jmp @r
@x:     lda fd
        jsr k_close
        lda #0
        rts
pre:    .byte "cat: ",0
nl:     .byte 10,0
