; WC.COM plik - "linie bajty"; kod 1 (błąd) lub 2 (użycie)
        .include "sys.inc"
fd = $E0
cnt = $E1
by = $E2        ; 2
li = $E4        ; 2
av = $E6        ; 2
        .segment "BSS"
BUF:    .res 256
        .segment "CODE"
        stx av
        sty av+1
        cmp #2
        bcs @ok
        lda #2
        rts
@ok:    ldy #3
        lda (av),y
        tax
        dey
        lda (av),y
        jsr k_open
        bcc @o
        jsr k_strerror
        jsr k_eputs
        lda #<nl
        ldx #>nl
        jsr k_eputs
        lda #1
        rts
@o:     sta fd
        lda #0
        sta by
        sta by+1
        sta li
        sta li+1
@r:     lda #<BUF
        sta bp
        lda #>BUF
        sta bp+1
        lda fd
        ldy #0
        jsr k_read
        beq @p
        sta cnt
        ldy #0
@b:     lda BUF,y
        cmp #10
        bne @n
        inc li
        bne @n
        inc li+1
@n:     iny
        cpy cnt
        bne @b
        clc
        lda by
        adc cnt
        sta by
        bcc @r
        inc by+1
        jmp @r
@p:     lda fd
        jsr k_close
        lda li
        ldx li+1
        jsr k_putdec
        lda #' '
        jsr k_putc
        lda by
        ldx by+1
        jsr k_putdec
        lda #10
        jsr k_putc
        lda #0
        rts
nl:     .byte 10,0
