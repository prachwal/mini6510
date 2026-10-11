; COUNT.COM znak - liczy w pętli bez yield i co 4096 obiegów wypisuje znak (16 razy): test wywłaszczania
        .include "sys.inc"
cl = $E0
ch = $E1
n  = $E2
av = $E3
c  = $E5
        .segment "CODE"
        stx av
        sty av+1
        cmp #2
        bcs @ok
        lda #2
        rts
@ok:    ldy #2
        lda (av),y
        sta cl
        iny
        lda (av),y
        sta ch
        ldy #0
        lda (cl),y
        sta c
        lda #0
        sta cl
        sta ch
        sta n
@l:     inc cl
        bne @l
        inc ch
        lda ch
        and #$0F
        bne @l                  ; co 4096 obiegów
        lda c
        jsr k_putc
        inc n
        lda n
        cmp #16
        bne @l
        lda #10
        jsr k_putc
        lda #0
        rts
