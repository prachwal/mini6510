; BIOS: reset, POST, procedury konsoli, tablica skoków (ca65)
; Mapa: ROM $F800-$FFFF (po POST kopia w RAM, shadow), I/O $D800-$DFFF.
        .include "bios.inc"
        .import LoadSystem, ReadBlk, WriteBlk
        .import __RELOC_LOAD__, __RELOC_RUN__, __RELOC_SIZE__
        .export PutChar, PrintStr, PutCRLF

DET_COL = 8
RES_COL = 24

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

; ---------------- makra ----------------
; test ZP/stosu bez użycia stosu i ZP-zmiennych: tylko A, X
.macro ZPPASS K
        .local w0, w1, v0, v1, bad, good
        ldx #2
w0:     txa
        eor #K
        sta $00,x
        inx
        bne w0
        ldx #0
w1:     txa
        eor #(K ^ $5A)
        sta $0100,x
        inx
        bne w1
        ldx #2
v0:     txa
        eor #K
        cmp $00,x
        bne bad
        inx
        bne v0
        ldx #0
v1:     txa
        eor #(K ^ $5A)
        cmp $0100,x
        bne bad
        inx
        bne v1
        jmp good
bad:    jmp ZpFail
good:
.endmacro

; test zakresu stron: A = pierwsza strona, X = strona końcowa (wył., mod 256)
; wyjście: A = 0 OK / 1 błąd (post_page = strona). Kod niezależny od położenia.
.macro TESTRANGE_BODY
        .local pass, phase, page, byte, wr, nxt, k1, k2, kd, fail, done
        sta tr_pm
        stx tr_xm
        lda #0
        sta tr_k
pass:   lda #0
        sta tr_ph
phase:  lda tr_pm
        sta ptr+1
        lda #0
        sta ptr
page:   lda tr_k
        beq k1                  ; przebieg 0: K = 0 (A = 0)
        cmp #1
        bne k2
        lda #$FF                ; przebieg 1: K = $FF
        bne kd
k2:     lda ptr+1               ; przebieg 2: K = numer strony
        bne kd
        lda #$00
kd:     sta tmp
k1:     sta tmp                 ; (przebieg 0: A = 0)
        ldy #0
byte:   tya
        eor tmp
        ldx tr_ph
        bne wr
        sta (ptr),y             ; faza zapisu
        clc
        bcc nxt
wr:     cmp (ptr),y             ; faza odczytu
        bne fail
nxt:    iny
        bne byte
        inc ptr+1
        lda ptr+1
        cmp tr_xm
        bne page
        inc tr_ph
        lda tr_ph
        cmp #2
        bcc phase
        inc tr_k
        lda tr_k
        cmp #3
        bcc pass
        lda #0
        beq done
fail:   lda ptr+1
        sta post_page
        lda #1
done:
.endmacro

.macro PRT lbl
        lda #<lbl
        sta ptr2
        lda #>lbl
        sta ptr2+1
        jsr PrintStr
.endmacro

.macro ROW lbl
        lda #<lbl
        sta ptr2
        lda #>lbl
        sta ptr2+1
        jsr RowHead
.endmacro

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

NmiIrq: rti

; ---------------- dane ----------------
PowLo:  .byte <10000, <1000, <100, <10
PowHi:  .byte >10000, >1000, >100, >10

MsgClear:    .byte 27,"[2J",27,"[H",0
MsgEol:      .byte 27,"[K",0
MsgBanner:   .byte "BIOS 6510 V0.1",0
MsgHeader:   .byte "TEST    RANGE           RESULT",0
MsgZpFail:   .byte "ZP/STACK RAM FAIL",13,10,0
MsgOk:       .byte "OK ",0
MsgFail:     .byte "FAIL ",0
MsgXX:       .byte "XX",0
MsgShadow:   .byte "SHADOW",0
MsgNmos:     .byte "OK NMOS",0
MsgCmos:     .byte "OK CMOS",0
MsgKb:       .byte " KB",0
MsgTimeout:  .byte "TIMEOUT",0
MsgNoMedia:  .byte "NO MEDIA",0
MsgTmrOk:    .byte "OK 100 HZ",0
MsgPostFail: .byte "POST FAILED",0
MsgSetup:    .byte "PRESS S FOR SETUP",0
MsgSetupMenu:.byte "SETUP: NOT IMPLEMENTED",13,10,0
MsgNoBoot:   .byte "NO BOOT MEDIA",0
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
