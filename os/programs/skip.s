; SKIP.COM plik N - wypisuje plik od pozycji N (test seek)
        .include "sys.inc"
fd = $E0
nl = $E1
nh = $E2
cnt = $E3
av = $E4
sv = $E6
t2 = $E8
        .segment "BSS"
BUF:    .res 256
        .segment "CODE"
        stx av
        sty av+1
        cmp #3
        bcs @ok
        lda #2
        rts
@ok:    lda #0
        sta nl
        sta nh
        ldy #5
        lda (av),y
        sta sv+1
        dey
        lda (av),y
        sta sv
        ldy #0
@d:     lda (sv),y
        beq @e
        sec
        sbc #'0'
        pha
        lda nl
        sta t2
        lda nh
        sta t2+1
        asl nl
        rol nh
        asl nl
        rol nh
        clc
        lda nl
        adc t2
        sta nl
        lda nh
        adc t2+1
        sta nh
        asl nl
        rol nh
        pla
        clc
        adc nl
        sta nl
        bcc @n
        inc nh
@n:     iny
        bne @d
@e:     ldy #3
        lda (av),y
        tax
        dey
        lda (av),y
        jsr k_open
        bcc @o
        lda #1
        rts
@o:     sta fd
        ldx nl
        ldy nh
        lda fd
        jsr k_seek
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
