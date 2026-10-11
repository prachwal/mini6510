; TICK.COM nazwa N - N razy wypisuje "nazwa i" i oddaje procesor (test wielozadaniowości)
        .include "sys.inc"
cnt = $E0
i   = $E1
av  = $E2
nm  = $E4
        .segment "CODE"
        stx av
        sty av+1
        cmp #3
        bcs @ok
        lda #2
        rts
@ok:    ldy #3
        lda (av),y
        sta nm+1
        dey
        lda (av),y
        sta nm
        ldy #5
        lda (av),y
        sta cnt+1               ; wskaźnik do cyfr N w ($E0/$E1)
        dey
        lda (av),y
        sta cnt
        ldy #0
        lda (cnt),y             ; jedna cyfra
        sec
        sbc #'0'
        sta cnt
        lda #1
        sta i
@l:     lda i
        cmp cnt
        beq @pr
        bcs @d
@pr:    lda nm
        ldx nm+1
        jsr k_puts
        lda #' '
        jsr k_putc
        lda i
        ldx #0
        jsr k_putdec
        lda #10
        jsr k_putc
        jsr k_yield
        inc i
        jmp @l
@d:     lda #0
        rts
