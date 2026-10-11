; ROT13.COM - filter: stdin -> stdout, rotates letters by 13 places.
; Example of a minimal MiniUnix filter. Try:  echo Hello | rot13 | rot13
        .include "sys.inc"
        .segment "CODE"
@l:     jsr k_getc              ; A = char, C=1 at end of input
        bcs @done
        sta $E0                 ; user zero page is $E0-$EF
        and #$DF                ; fold to upper case
        sec
        sbc #'A'
        cmp #26
        bcs @raw                ; not a letter -> pass through
        clc
        adc #13
        cmp #26
        bcc @n
        sbc #26                 ; carry is set here
@n:     clc
        adc #'A'
        sta $E1
        lda $E0
        and #$20                ; keep original case bit
        ora $E1
        jmp @out
@raw:   lda $E0
@out:   jsr k_putc
        jmp @l
@done:  lda #0                  ; exit code 0
        rts
