; HELLO.COM - wypisuje argv, kod wyjścia 0
        .include "sys.inc"
ac = $E0
ix = $E1
av = $E2
        .segment "CODE"
        sta ac
        stx av
        sty av+1
        lda #0
        sta ix
@l:     lda ix
        cmp ac
        beq @d
        asl
        tay
        iny
        lda (av),y
        tax
        dey
        lda (av),y
        jsr k_puts
        lda #10
        jsr k_putc
        inc ix
        jmp @l
@d:     lda #0
        rts
