; drive.s - block device on a disk drive (1541 over IEC, 1551 over TCBM), unit 8. Shared by C64 and Plus/4.
; A disk block (256 B) = one drive sector, linear order T1/S0.. (1541/1551: 683 blocks). Read = "U1:5 0 t s" + read
; buffer channel 5, write = fill buffer + "U2:5 0 t s". Status (channel 15) is checked after every U1/U2.
; Transport: iec.s (bit-banged serial bus) and, when platform.inc defines TCBM, tcbm.s (Plus/4 1551 interface);
; the one that answers at boot is remembered in drv_tr (bit 7 = TCBM).
        .include "bios.inc"
        .include "platform.inc"
        .include "hw.inc"
        .export IecInit, IecRead, IecWrite
        .import IecListen, IecSend, IecEnd, IecTalk, IecRecv, IecIdle, IecPrep
.ifdef TCBM
        .import TcbListen, TcbSend, TcbEnd, TcbTalk, TcbRecv, TcbIdle, TcbPrep
.endif
        .segment "DRV"

IEC_TRIES   = 10            ; boot probe rounds (a round without a drive takes up to ~0.3 s)
IEC_BLOCKS  = 683           ; 1541/1551: 35 tracks, no error bytes
HDR         = $0200         ; scratch for the boot-disk probe (RAM already tested at this point)

; ---- transport dispatch
.macro Dispatch iecname, tcbname
.ifdef TCBM
        bit drv_tr
        bmi @t
        jmp iecname
@t:     jmp tcbname
.else
        jmp iecname
.endif
.endmacro
DrvListen: Dispatch IecListen, TcbListen
DrvSend:   Dispatch IecSend, TcbSend
DrvEnd:    Dispatch IecEnd, TcbEnd
DrvTalk:   Dispatch IecTalk, TcbTalk
DrvRecv:   Dispatch IecRecv, TcbRecv
DrvIdle:   Dispatch IecIdle, TcbIdle

; ---- commands on channel 15. ptr2 -> bytes ending with CR then 0 (CR is sent with EOI). C=1 error
IecCmd:
        lda #$6F
        jsr DrvListen
        bcs @e
        lda #0
        sta iec_i
@l:     ldy iec_i
        lda (ptr2),y
        pha
        iny
        lda (ptr2),y
        beq @last
        lda #0
        beq @snd
@last:  lda #$80
@snd:   sta iec_eoi
        pla
        jsr DrvSend
        bcs @e
        inc iec_i
        lda iec_eoi
        bpl @l
        lda #$3F
        jmp DrvEnd
@e:     jmp IecIdle_c

IecIdle_c:
        jsr DrvIdle
        sec
        rts

; status of channel 15 -> iec_st; C=1 on bus error or drive error (first digit not 0)
IecStatus:
        lda #$6F
        jsr DrvTalk
        bcs @e
        lda #0
        sta iec_i
@l:     jsr DrvRecv
        bcs @e
        ldy iec_i
        bne @n
        sta iec_st              ; first character
@n:     inc iec_i
        bit iec_eoi
        bmi @end
        lda iec_i
        cmp #64
        bcc @l
@end:   lda #$5F
        jsr DrvEnd
        lda iec_st
        cmp #'0'
        bne @bad
        clc
        rts
@bad:   sec
        rts
@e:     jmp IecIdle_c

; ---- block -> track/sector. X/Y = block. C=1 out of range
BlkToTs:
        cpy #>IEC_BLOCKS
        bcc @ok
        bne @bad
        cpx #<IEC_BLOCKS
        bcs @bad
@ok:    stx tmp
        sty tmp2
        lda #1
        sta iec_trk
@loop:  jsr Spt
        lda tmp2
        bne @sub
        lda tmp
        cmp iec_spt
        bcc @done
@sub:   sec
        lda tmp
        sbc iec_spt
        sta tmp
        lda tmp2
        sbc #0
        sta tmp2
        inc iec_trk
        jmp @loop
@done:  lda tmp
        sta iec_sec
        clc
        rts
@bad:   sec
        rts

Spt:    lda iec_trk
        ldx #21
        cmp #18
        bcc @r
        ldx #19
        cmp #25
        bcc @r
        ldx #18
        cmp #31
        bcc @r
        ldx #17
@r:     stx iec_spt
        rts

AppendDec:                      ; A < 100 -> decimal digits at iec_cmd,y (Y advances)
        ldx #'0'
@t:     cmp #10
        bcc @u
        sbc #10
        inx
        bne @t
@u:     pha
        cpx #'0'
        beq @nt
        txa
        sta iec_cmd,y
        iny
@nt:    pla
        ora #'0'
        sta iec_cmd,y
        iny
        rts

; build "Un:5 0 t s" (A = '1' or '2') in iec_cmd, ptr2 -> it
BuildTs:
        pha
        ldx #6
@c:     lda CmdTpl,x
        sta iec_cmd,x
        dex
        bpl @c
        pla
        sta iec_cmd+1
        ldy #7
        lda iec_trk
        jsr AppendDec
        lda #' '
        sta iec_cmd,y
        iny
        lda iec_sec
        jsr AppendDec
        lda #13
        sta iec_cmd,y
        iny
        lda #0
        sta iec_cmd,y
        jmp SetCmdPtr

SetCmdPtr:
        lda #<iec_cmd
        sta ptr2
        lda #>iec_cmd
        sta ptr2+1
        rts

CmdTpl: .byte "U?:5 0 "
CmdBP:  .byte "B-P:5 0", 13, 0

SendBP:
        lda #<CmdBP
        sta ptr2
        lda #>CmdBP
        sta ptr2+1
        jmp IecCmd

; ---- block API: X/Y = block, ptr = buffer. C=1 error (A=1 range, A=3 I/O). X/Y preserved
IecRead:
        stx iec_sx
        sty iec_sy
        jsr BlkToTs
        bcs @range
        lda #'1'
        jsr BuildTs
        jsr IecCmd
        bcs @io
        jsr IecStatus
        bcs @io
        jsr SendBP
        bcs @io
        lda #$65
        jsr DrvTalk
        bcs @io
        lda #0
        sta iec_i
@r:     jsr DrvRecv
        bcs @io
        ldy iec_i
        sta (ptr),y
        inc iec_i
        bne @r
        lda #$5F
        jsr DrvEnd
        bcs @io
        ldx iec_sx
        ldy iec_sy
        clc
        rts
@range: lda #1
        bne @x
@io:    lda #3
@x:     ldx iec_sx
        ldy iec_sy
        sec
        rts

IecWrite:
        stx iec_sx
        sty iec_sy
        jsr BlkToTs
        bcs @range
        jsr SendBP
        bcs @io
        lda #$65
        jsr DrvListen
        bcs @io
        lda #0
        sta iec_i
@w:     ldy iec_i
        lda (ptr),y
        pha
        lda #0
        cpy #255
        bne @n
        lda #$80
@n:     sta iec_eoi
        pla
        jsr DrvSend
        bcs @io
        inc iec_i
        bne @w
        lda #$3F
        jsr DrvEnd
        bcs @io
        lda #'2'
        jsr BuildTs
        jsr IecCmd
        bcs @io
        jsr IecStatus
        bcs @io
        ldx iec_sx
        ldy iec_sy
        clc
        rts
@range: lda #1
        bne @x
@io:    lda #3
@x:     ldx iec_sx
        ldy iec_sy
        sec
        rts

; ---- init: C=0 and blk_dev=1 when a drive with a MiniUnix disk answers; otherwise blk_dev=0.
; Up to IEC_TRIES rounds (the drive may still be resetting): each tries TCBM (if present) and then IEC.
IecInit:
        lda #0
        sta blk_dev
        sta drv_tr
        jsr IecPrep
        lda #IEC_TRIES
        sta iec_try
@round:
.ifdef TCBM
        jsr TcbPrep             ; C=0: a 1551 answers on TCBM
        bcs @iec
        lda #$80
        sta drv_tr
        jsr Probe
        bcc @ok
        cmp #1
        beq @none               ; a drive is there but the disk is not ours
        jmp @next               ; the interface answered but the drive did not: retry
@iec:   lda #0
        sta drv_tr
.endif
        jsr Probe
        bcc @ok
        cmp #1
        beq @none               ; drive answered, wrong disk
@next:  dec iec_try
        bne @round
@none:
        lda #0
        sta drv_tr
        jsr DrvIdle
        sec
        rts
@ok:    lda #1
        sta blk_dev
        clc
        rts

Probe:                          ; open channels 15 and 5, look for the MiniUnix signature in block 0.
        lda #$FF                ; C=1: A=0 no drive, A=1 drive without a MiniUnix disk
        jsr DrvListen           ; OPEN 15,8,15 (the 1551 needs it, the 1541 does not mind)
        bcs @nodrv
        lda #$3F
        jsr DrvEnd
        bcs @bad
        lda #$F5
        jsr DrvListen           ; open channel 5 = buffer
        bcs @bad
        lda #$80
        sta iec_eoi
        lda #'#'
        jsr DrvSend
        bcs @bad
        lda #$3F
        jsr DrvEnd
        bcs @bad
        lda #<HDR
        sta ptr
        lda #>HDR
        sta ptr+1
        ldx #0
        ldy #0
        jsr IecRead
        bcs @bad
        lda HDR+$10
        cmp #'S'
        bne @bad
        lda HDR+$11
        cmp #'F'
        bne @bad
        clc
        rts
@bad:   jsr DrvIdle
        lda #1
        sec
        rts
@nodrv: lda #0
        sec
        rts
