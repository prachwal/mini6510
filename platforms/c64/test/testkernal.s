; testkernal.s - zastępczy KERNAL do testów w VICE bez oryginalnych ROM-ów:
; po resecie kopiuje mini6510.prg ($0801...) do RAM i skacze do stubu SYS ($080D).
        .segment "KERNAL"
Start:  sei
        cld
        ldx #$FF
        txs
        lda #<PrgStart
        sta $FB
        lda #>PrgStart
        sta $FC
        lda #$01
        sta $FD
        lda #$08
        sta $FE
        ldx #>(PrgEnd - PrgStart + 255)
        ldy #0
@c:     lda ($FB),y
        sta ($FD),y
        iny
        bne @c
        inc $FC
        inc $FE
        dex
        bne @c
        jmp $080D
Nmi:    rti
PrgStart:
        .incbin "mini6510.prg", 2
PrgEnd:

        .segment "VECTORS"
        .word Nmi, Start, Nmi
