; UPPER.COM - filtr: stdin -> stdout wielkimi literami
        .include "sys.inc"
        .segment "CODE"
@l:     jsr k_getc
        bcs @d
        cmp #'a'
        bcc @o
        cmp #'{'
        bcs @o
        and #$DF
@o:     jsr k_putc
        jmp @l
@d:     lda #0
        rts
