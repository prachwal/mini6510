; BIOS: reset, POST, procedury konsoli, tablica skoków (ca65)
; Mapa: ROM $F800-$FFFF (po POST kopia w RAM, shadow), I/O $D800-$DFFF.
        .include "bios.inc"
        .include "hw.inc"
        .include "post.inc"
        .import LoadSystem, ReadBlk, WriteBlk
        .import __RELOC_LOAD__, __RELOC_RUN__, __RELOC_SIZE__
        .export PutChar, ConGotoXY
        .import PrintStr, PutCRLF, PrintHex8, PrintDec16, PrtAY, RowAY, RowEnd, TestRange, ResultRam, DetectCpu
        .import MsgOk, MsgFail, MsgXX, MsgNmos, MsgCmos, MsgKb, MsgTimeout, MsgNoMedia, MsgPostFail, MsgNoBoot

; ---------------- tablica skoków (stałe adresy) ----------------
        .segment "JUMPTAB"
        jmp Unimpl              ; $F800 I2C_READ
        jmp Unimpl              ; $F803 I2C_WRITE
        jmp PutChar             ; $F806
        jmp PrintStr            ; $F809
        jmp PutCRLF             ; $F80C
        jmp Unimpl              ; $F80F PrintTime
        jmp LoadSystem          ; $F812
        jmp ReadBlock           ; $F815
        jmp WriteBlock          ; $F818
        jmp ConClear            ; $F81B
        jmp ConClearEol         ; $F81E
        jmp ConGotoXY           ; $F821
        jmp KeyGet              ; $F824
        jmp TickAck             ; $F827
        jmp TickStart           ; $F82A
        jmp RtcRead             ; $F82D

        .segment "BIOS"

; ---------------- RESET ----------------
Reset:
        sei
        cld
        ZPPASS $00
        ZPPASS $FF
        ZPPASS $A5
        ldx #$FF
        txs
        jsr ConInit
        ldx #0                  ; czy konsola żyje (TDRE w ograniczonym czasie)
        ldy #0
@w:     lda CON_CTRL
        and #$02
        bne @alive
        dex
        bne @w
        dey
        bne @w
@dead:  jmp @dead
@alive: jmp PostMain

ZpFail:
        lda #$03
        sta CON_CTRL
        lda #$15
        sta CON_CTRL
        ldx #0
@w:     lda CON_CTRL
        and #$02
        beq @w
        lda MsgZpFail,x
        beq @h
        sta CON_DATA
        inx
        bne @w
@h:     jmp @h

; ---------------- POST ----------------
PostMain:
        lda #0
        sta post_fail
        sta post_disk
        jsr ConClear
        PRT MsgBanner
        ldx #2
        lda #0
        jsr ConGotoXY
        PRT MsgHeader
        lda #3
        sta post_row

        ; --- CPU ---
        ROW RowCpu
        jsr DetectCpu
        bne @nmos
        PRT MsgCmos
        jmp @cpu
@nmos:  PRT MsgNmos
@cpu:   jsr RowEnd

        ; --- RAM ---
        ROW RowZp
        PRT MsgOk               ; sprawdzone w Reset
        jsr RowEnd

        ROW RowRam1
        lda #$02
        ldx #$D8
        jsr TestRange
        jsr ResultRam
        jsr RowEnd

        ROW RowRam2
        lda #$E0
        ldx #$F8
        jsr TestRange
        jsr ResultRam
        jsr RowEnd

        ROW RowRam3             ; $F800-$FFFF: kod w $0200, potem kopia ROM -> RAM
        ldy #0
@rl:    lda __RELOC_LOAD__,y
        sta __RELOC_RUN__,y
        iny
        cpy #<__RELOC_SIZE__
        bne @rl
        jsr __RELOC_RUN__
        jsr ResultRam
        lda post_fail
        bne @r3
        PRT MsgShadow
@r3:    jsr RowEnd

        ; --- konsola ---
        ROW RowCon
        lda CON_CTRL
        and #$22
        cmp #$02
        beq @cok
        inc post_fail
        PRT MsgFail
        jmp @cend
@cok:   PRT MsgOk
@cend:  jsr RowEnd

        ; --- dysk ---
        ROW RowDisk
        lda #0
        sta BLK_UNIT
        lda #BLK_CMD_INFO
        sta BLK_CMD
        ldx #0
        ldy #0
@dw:    lda BLK_STATUS
        and #BLK_ST_BUSY
        beq @dd
        dex
        bne @dw
        dey
        bne @dw
        PRT MsgTimeout
        jmp @dend
@dd:    lda BLK_STATUS
        and #BLK_ST_NOMEDIA
        beq @dm
        PRT MsgNoMedia
        jmp @dend
@dm:    lda BLK_STATUS
        and #BLK_ST_ERR
        beq @ds
        PRT MsgFail
        jmp @dend
@ds:    lda #1
        sta post_disk
        PRT MsgOk
        lda BLK_SIZE_LO
        ora BLK_SIZE_HI
        bne @dc
        lda #0                  ; 0 = 65536 bloków = 16384 KB
        ldx #$40
        bne @dp
@dc:    lda BLK_SIZE_HI
        sta tmp
        lda BLK_SIZE_LO
        lsr tmp
        ror
        lsr tmp
        ror
        ldx tmp
@dp:    jsr PrintDec16
        PRT MsgKb
@dend:  jsr RowEnd

        ; --- zegar ---
        ROW RowTmr
        lda TMR_DIV
        cmp #10
        bne @tbad
        lda #1
        sta TMR_CTRL            ; start, bez IRQ
        PRT MsgTmrOk
        jmp @tend
@tbad:  PRT MsgFail
@tend:  jsr RowEnd

        ; --- werdykt ---
        inc post_row
        ldx post_row
        lda #0
        jsr ConGotoXY
        lda post_fail
        beq @pass
        PRT MsgPostFail
@halt:  jmp @halt
@pass:  PRT MsgSetup
        jsr WaitSetup
        bcc @boot
        jsr SetupMenu
@boot:  jsr PutCRLF
        lda post_disk
        bne @load
        PRT MsgNoBoot
@h2:    jmp @h2
@load:  jmp LoadSystem

; ---------------- POST: pomocnicze ----------------
; Czeka do 2 s (200 impulsów zegara); C=1 gdy wciśnięto S
WaitSetup:
        lda #0
        sta post_ticks
        sta wg_lo
        sta wg_hi
        sta wg_ov
        lda TMR_COUNT
        sta tmp
@lp:    lda CON_CTRL
        and #$01
        beq @nk
        lda CON_DATA
        and #$DF
        cmp #'S'
        beq @key
@nk:    lda TMR_COUNT
        cmp tmp
        bne @tick
        inc wg_lo               ; bezpiecznik na wypadek martwego zegara
        bne @lp
        inc wg_hi
        bne @lp
        inc wg_ov
        lda wg_ov
        cmp #4
        bne @lp
        clc
        rts
@tick:  sta tmp
        inc post_ticks
        lda post_ticks
        cmp #200
        bne @lp
        clc
        rts
@key:   sec
        rts

SetupMenu:
        jsr PutCRLF
        PRT MsgSetupMenu
        rts

; ---------------- konsola ----------------
ConInit:
        lda #$03                ; reset UART
        sta CON_CTRL
        lda #$15                ; 8N1, /16
        sta CON_CTRL
        rts

PutChar:                        ; A zachowane
        pha
@w:     lda CON_CTRL
        and #$02
        beq @w
        pla
        sta CON_DATA
        rts

ConGotoXY:                      ; A = kolumna, X = wiersz (od 0)
        sta con_col
        lda #27
        jsr PutChar
        lda #'['
        jsr PutChar
        txa
        clc
        adc #1
        ldx #0
        jsr PrintDec16
        lda #';'
        jsr PutChar
        lda con_col
        clc
        adc #1
        ldx #0
        jsr PrintDec16
        lda #'H'
        jmp PutChar

ConClear:
        PRT MsgClear
        rts

ConClearEol:
        PRT MsgEol
        rts

ReadBlock:                      ; A = napęd, X/Y = blok, ptr = bufor
        sta BLK_UNIT
        jmp ReadBlk

WriteBlock:                     ; A = napęd, X/Y = blok, ptr = bufor
        sta BLK_UNIT
        jmp WriteBlk

Unimpl: sec
        rts

; ---- usługi wejścia/zegara dla systemu (kontrakt: bios.inc) ----
KeyGet: lda CON_CTRL            ; C=0, A = znak / C=1 brak
        and #1
        beq @n
        lda CON_DATA
        clc
        rts
@n:     sec
        rts

TickAck:                        ; C=1 gdy impuls zegara (potwierdzony)
        lda TMR_STATUS
        and #1
        beq @n
        sta TMR_STATUS          ; zapis = potwierdzenie
        sec
        rts
@n:     clc
        rts

TickStart:
        lda TMR_STATUS          ; skasuj zaległe
        sta TMR_STATUS
        lda #3                  ; start + IRQ
        sta TMR_CTRL
        rts

; RTC DS1307 ($68) przez kontroler I2C: 7 bajtów BCD -> (ptr)
I2cOp:  sta I2C_CTRL            ; A = ctrl; C=1 timeout
        ldx #0
        ldy #0
@w:     lda I2C_STAT
        and #1
        beq @ok
        dex
        bne @w
        dey
        bne @w
        sec
        rts
@ok:    clc
        rts

RtcRead:
        lda #$D0
        sta I2C_DATA
        lda #5                  ; START | WRITE
        jsr I2cOp
        bcs @f
        lda I2C_STAT
        and #2
        bne @f
        lda #0
        sta I2C_DATA
        lda #4
        jsr I2cOp
        bcs @f
        lda #$D1
        sta I2C_DATA
        lda #5
        jsr I2cOp
        bcs @f
        ldy #0
@r:     lda #8                  ; READ
        cpy #6
        bne @n
        lda #26                 ; READ | NACK | STOP
@n:     sty tmp
        jsr I2cOp
        bcs @f
        ldy tmp
        lda I2C_DATA
        sta (ptr),y
        iny
        cpy #7
        bne @r
        clc
        rts
@f:     sec
        rts

NmiIrq: rti

; ---------------- dane ----------------

MsgClear:    .byte 27,"[2J",27,"[H",0
MsgEol:      .byte 27,"[K",0
MsgBanner:   .byte "BIOS 6510 V0.1",0
MsgHeader:   .byte "TEST    RANGE           RESULT",0
MsgZpFail:   .byte "ZP/STACK RAM FAIL",13,10,0
MsgShadow:   .byte "SHADOW",0
MsgTmrOk:    .byte "OK 100 HZ",0
MsgSetup:    .byte "PRESS S FOR SETUP",0
MsgSetupMenu:.byte "SETUP: NOT IMPLEMENTED",13,10,0
RowCpu:      .byte "CPU",0,0
RowZp:       .byte "RAM",0,"0002-01FF",0
RowRam1:     .byte "RAM",0,"0200-D7FF",0
RowRam2:     .byte "RAM",0,"E000-F7FF",0
RowRam3:     .byte "RAM",0,"F800-FFFF",0
RowCon:      .byte "CONSOLE",0,"DF00",0
RowDisk:     .byte "DISK",0,"DF10",0
RowTmr:      .byte "TIMER",0,"DF30",0

; ---------------- kod uruchamiany z $0200 ----------------
        .segment "RELOC"
; test RAM $F800-$FFFF przy shadow=1, potem kopia ROM -> RAM i shadow=1.
; Wyjście: A = 0 OK (shadow=1, RAM = kopia ROM) / 1 błąd (shadow=0).
HiTest:
        lda #1
        sta SHADOW_LATCH
        lda #$F8
        ldx #0
        TESTRANGE_BODY
        bne @bad
        lda #0
        sta SHADOW_LATCH        ; widać ROM, zapis idzie do RAM
        sta ptr
        lda #$F8
        sta ptr+1
        ldy #0
@c:     lda (ptr),y
        sta (ptr),y
        iny
        bne @c
        inc ptr+1
        bne @c
        lda #1
        sta SHADOW_LATCH
        lda #0
        rts
@bad:   lda #0
        sta SHADOW_LATCH
        lda #1
        rts

        .segment "VECTORS"
        .word NmiIrq, Reset, NmiIrq
