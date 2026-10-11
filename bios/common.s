; common.s - wspólny kod POST i wypisywania (BIOS, wszystkie platformy)
; Wymaga od platformy: PutChar (A zachowane), ConGotoXY (A = kolumna, X = wiersz).
        .include "bios.inc"
        .include "post.inc"
        .import PutChar, ConGotoXY
        .export PrintStr, PutCRLF, PrintHex8, PrintDec16
        .export PrtAY, RowAY, RowEnd, TestRange, ResultRam, DetectCpu
        .export MsgOk, MsgFail, MsgXX, MsgNmos, MsgCmos, MsgKb, MsgTimeout, MsgNoMedia, MsgPostFail, MsgNoBoot

DET_COL = 8
RES_COL = 24

        .segment "BIOS"

PrtAY:  sta ptr2                ; A/Y = adres tekstu
        sty ptr2+1
        jmp PrintStr
RowAY:  sta ptr2
        sty ptr2+1
        jmp RowHead

RowHead:                        ; ptr2 -> "etykieta",0,"szczegół",0
        ldx post_row
        lda #0
        jsr ConGotoXY
        jsr PrintStr
        tya
        sec
        adc ptr2
        sta ptr2
        bcc @a
        inc ptr2+1
@a:     ldx post_row
        lda #DET_COL
        jsr ConGotoXY
        jsr PrintStr
        ldx post_row
        lda #RES_COL
        jmp ConGotoXY

RowEnd: inc post_row
        rts

TestRange:
        TESTRANGE_BODY
        rts

ResultRam:                      ; A = 0 OK / 1 błąd
        bne @f
        PRT MsgOk
        rts
@f:     inc post_fail
        PRT MsgFail
        lda post_page
        jsr PrintHex8
        PRT MsgXX
        rts

DetectCpu:                      ; Z=1: CMOS (STZ zp), Z=0: NMOS (NOP zp)
        lda #$55
        sta tmp
        .byte $64, tmp
        lda tmp
        rts

PrintStr:                       ; ptr2 -> tekst zakończony 0; Y = indeks zera
        ldy #0
@l:     lda (ptr2),y
        beq @d
        jsr PutChar
        iny
        bne @l
@d:     rts

PutCRLF:
        lda #13
        jsr PutChar
        lda #10
        jmp PutChar

PrintHex8:
        pha
        lsr
        lsr
        lsr
        lsr
        jsr @nib
        pla
@nib:   and #$0F
        cmp #10
        bcc @d
        adc #6
@d:     adc #'0'
        jmp PutChar

PrintDec16:                     ; A = lo, X = hi
        sta ptr
        stx ptr+1
        ldx #0
        stx tmp2
@pw:    ldy #0
@sub:   lda ptr
        sec
        sbc PowLo,x
        sta tmp
        lda ptr+1
        sbc PowHi,x
        bcc @out
        sta ptr+1
        lda tmp
        sta ptr
        iny
        bne @sub
@out:   tya
        ora tmp2
        beq @nx
        tya
        clc
        adc #'0'
        jsr PutChar
        lda #1
        sta tmp2
@nx:    inx
        cpx #4
        bne @pw
        lda ptr
        clc
        adc #'0'
        jmp PutChar


PowLo:  .byte <10000, <1000, <100, <10
PowHi:  .byte >10000, >1000, >100, >10

MsgOk:       .byte "OK ",0
MsgFail:     .byte "FAIL ",0
MsgXX:       .byte "XX",0
MsgNmos:     .byte "OK NMOS",0
MsgCmos:     .byte "OK CMOS",0
MsgKb:       .byte " KB",0
MsgTimeout:  .byte "TIMEOUT",0
MsgNoMedia:  .byte "NO MEDIA",0
MsgPostFail: .byte "POST FAILED",0
MsgNoBoot:   .byte "NO BOOT MEDIA",0
