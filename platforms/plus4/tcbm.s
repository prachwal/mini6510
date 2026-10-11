; tcbm.s - Plus/4 TCBM transport (1551 drive, unit 8 = 6525 TPI at $FEF0), same primitives as iec.s.
; Protocol as in the Plus/4 KERNAL: one handshaked transfer = command code on PA ($81 LISTEN/TALK/UNLISTEN/UNTALK,
; $82 secondary address, $83 data byte, $84 receive), drive pulls ACK (PC7) low, host puts the byte on PA and strobes
; DAV (PC6 low), drive raises ACK again and reports status in PB bits 0-1 (receive: 3 = last byte / EOI).
        .include "bios.inc"
        .include "hw.inc"
        .export TcbListen, TcbSend, TcbEnd, TcbTalk, TcbRecv, TcbIdle, TcbPrep
        .segment "DRV"

TcbIdle:
        lda #0
        sta TPI_PA
        lda #$40
        sta TPI_PC
        rts

TcbWait:                        ; wait for PC7 == A ($00 / $80); C=1 on timeout (about 8 s)
        sta tmp
        lda #8
        sta tmp2
@o:     ldy iec_to
        ldx #0
@l:     lda TPI_PC
        and #$80
        cmp tmp
        beq @ok
        dex
        bne @l
        dey
        bne @l
        dec tmp2
        bne @o
        sec
        rts
@ok:    clc
        rts

TcbPrep:                        ; C=0 when a 1551 interface answers
        lda #$FF
        sta TPI_DDRA
        lda #0
        sta TPI_DDRB
        sta TPI_PA
        lda #$40
        sta TPI_DDRC
        sta TPI_PC
        lda #255
        sta iec_to
        lda #$55                ; same presence test as the KERNAL
        sta TPI_PA
        eor TPI_PA
        bne @none
        lda TPI_PB
        and #$02
        bne @none
        jsr TcbIdle
        clc
        rts
@none:  jsr TcbIdle
        sec
        rts

TcbByte:                        ; A = command code, iec_b = data. C=1 error
        pha
        lda #$80                ; drive idle (ACK high) before a new command: it signals busy while it works
        jsr TcbWait
        pla
        bcs @fail1
        sta TPI_PA
        lda #$00
        jsr TcbWait
        bcs @fail1
        lda iec_b
        sta TPI_PA
        lda #0
        sta TPI_PC              ; DAV
        lda #$80
        jsr TcbWait
        bcs @fail2
        lda TPI_PB
        and #$03
        sta iec_ts
        jsr TcbIdle
        lda iec_ts
        bne @err
        clc
        rts
@fail1:
@fail2:
@fail:  jsr TcbIdle
        sec
        rts
@err:   sec
        rts

TcbListen:                      ; A = secondary address
        pha
        lda #$20
        sta iec_b
        lda #$81
        jsr TcbByte
        bcs @e
        pla
        sta iec_b
        lda #$82
        jmp TcbByte
@e:     pla
        rts

TcbTalk:
        pha
        lda #$40
        sta iec_b
        lda #$81
        jsr TcbByte
        bcs @e
        pla
        sta iec_b
        lda #$82
        jmp TcbByte
@e:     pla
        rts

TcbSend:                        ; A = byte
        sta iec_b
        lda #$83
        jmp TcbByte

TcbEnd:                         ; A = $3F / $5F
        sta iec_b
        lda #$81
        jmp TcbByte

TcbRecv:                        ; A = byte, iec_eoi bit 7 = last byte. C=1 error
        lda #0
        sta iec_eoi
        lda #$84
        sta TPI_PA
        lda #$00
        jsr TcbWait
        bcs @fail
        lda #0
        sta TPI_DDRA            ; PA becomes input
        sta TPI_PC              ; DAV
        lda #$80
        jsr TcbWait
        bcs @fail2
        lda TPI_PB
        and #$03
        sta iec_ts
        lda TPI_PA
        sta iec_r
        lda #$40
        sta TPI_PC
        lda #$00
        jsr TcbWait
        lda #$FF
        sta TPI_DDRA
        lda #0
        sta TPI_PA
        sta TPI_PC
        lda #$80
        jsr TcbWait
        lda #$40
        sta TPI_PC
        lda iec_ts
        cmp #3
        bne @nz
        lda #$80
        sta iec_eoi
        bne @done
@nz:    cmp #0
        bne @err
@done:  lda iec_r
        clc
        rts
@fail2: lda #$FF
        sta TPI_DDRA
@fail:  jsr TcbIdle
@err:   sec
        rts
