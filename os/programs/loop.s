; LOOP.COM - bezczynna pętla oddająca procesor (do testu kill)
        .include "sys.inc"
        .segment "CODE"
@l:     jsr k_yield
        jmp @l
