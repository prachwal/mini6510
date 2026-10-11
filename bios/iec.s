; iec.s - IEC serial bus transport (1541-class drive, unit 8), shared by C64 and Plus/4.
; Bit-banged LISTEN/TALK/SECOND/CIOUT/ACPTR (same line protocol as the CBM KERNAL), no KERNAL needed.
; The block layer (U1/U2 on a 1541) is in drive.s. Platform supplies (hw.inc): IEC_PORT, IEC_ATN/CLK/DATA
; (1 = pull line low), IEC_CLKIN/DATAIN (1 = line high), macro IecHwInit, and RAM variables iec_*.
        .include "bios.inc"
        .include "hw.inc"
        .export IecListen, IecSend, IecEnd, IecTalk, IecRecv, IecIdle, IecPrep
        .segment "DRV"

IEC_UNIT    = 8

; ---- line control ----
.macro IecPull mask
        lda IEC_PORT
        ora #mask
        sta IEC_PORT
.endmacro
.macro IecRelease mask
        lda IEC_PORT
        and #<~mask
        sta IEC_PORT
.endmacro
.macro WaitFor mask, want
        lda #mask
        sta tmp
        lda #want
        sta tmp2
        jsr IecWait
.endmacro

AtnHi:  IecRelease IEC_ATN
        rts
ClkHi:  IecRelease IEC_CLK
        rts
ClkLo:  IecPull IEC_CLK
        rts
DataHi: IecRelease IEC_DATA
        rts
DataLo: IecPull IEC_DATA
        rts

Delay:                          ; X = n: about 5n+12 cycles
@l:     dex
        bne @l
        rts

IecIdle:                        ; release all lines
        jsr AtnHi
        jsr ClkHi
        jmp DataHi

IecWait:                        ; wait until (port & tmp) == tmp2; C=1 on timeout (iec_to * 65536 * ~17 cycles)
        ldy iec_to
        ldx #0
@l:     lda IEC_PORT
        and tmp
        cmp tmp2
        beq @ok
        dex
        bne @l
        dey
        bne @l
        sec
        rts
@ok:    clc
        rts

; ---- send one byte (CLK low, DATA held low by listener on entry). A = byte, iec_eoi bit 7 = last byte. C=1 error
IecSend:
        sta iec_b
        php
        sei
        jsr DataHi
        lda IEC_PORT
        and #IEC_DATAIN
        bne @fail               ; DATA high: nobody listens
        jsr ClkHi               ; ready to send
        WaitFor IEC_DATAIN, IEC_DATAIN
        bcs @fail
        lda iec_eoi
        bpl @go
        WaitFor IEC_DATAIN, 0   ; EOI: listener acknowledges after 200 us
        bcs @fail
        WaitFor IEC_DATAIN, IEC_DATAIN
        bcs @fail
@go:    jsr ClkLo
        lda #8
        sta iec_bc
@bit:   lsr iec_b
        bcs @one
        jsr DataLo
        jmp @set
@one:   jsr DataHi
@set:   ldx #6
        jsr Delay
        jsr ClkHi
        ldx #8
        jsr Delay
        lda IEC_PORT
        and #<~IEC_DATA
        ora #IEC_CLK
        sta IEC_PORT            ; CLK low, DATA released
        dec iec_bc
        bne @bit
        WaitFor IEC_DATAIN, 0   ; frame acknowledge
        bcs @fail
        plp
        clc
        rts
@fail:  plp
        sec
        rts

; ---- command byte under ATN. A = byte. C=1: no device (bus released)
IecAtnSend:
        pha
        jsr DataHi
        IecPull IEC_ATN
        jsr ClkLo
        jsr DataHi
        lda #64
        sta iec_to
        WaitFor IEC_DATAIN, 0   ; device answers by pulling DATA
        lda #255
        sta iec_to
        bcs @nodev
        ldx #0                  ; let the drive's ATN service run (~1 ms) before the clock is released
        jsr Delay
        pla
        ldx #0
        stx iec_eoi
        jsr IecSend
        bcc @ok
        jsr IecIdle
        sec
@ok:    rts
@nodev: pla
        jsr IecIdle
        sec
        rts

IecListen:                      ; A = secondary address ($6x data/command, $Fx open)
        pha
        lda #$20 + IEC_UNIT
        jsr IecAtnSend
        bcs @e
        pla
        ldx #0
        stx iec_eoi
        jsr IecSend
        bcs @e2
        jmp AtnHi               ; leaves C=0 (AtnHi ends with rts after sta)
@e:     pla
@e2:    jsr IecIdle
        sec
        rts

IecEnd:                         ; A = $3F (UNLISTEN) or $5F (UNTALK)
        jsr IecAtnSend
        php
        jsr AtnHi
        ldx #20
        jsr Delay
        jsr ClkHi
        jsr DataHi
        plp
        rts

IecTalk:                        ; A = secondary address; turns the bus around
        pha
        lda #$40 + IEC_UNIT
        jsr IecAtnSend
        bcs @e
        pla
        ldx #0
        stx iec_eoi
        jsr IecSend
        bcs @e2
        php
        sei
        jsr DataLo
        jsr AtnHi
        jsr ClkHi
        WaitFor IEC_CLKIN, 0    ; talker takes the clock
        bcs @t
        plp
        clc
        rts
@t:     plp
        jmp @e2
@e:     pla
@e2:    jsr IecIdle
        sec
        rts

; ---- receive one byte. A = byte, iec_eoi bit 7 = EOI (last byte). C=1 error
IecRecv:
        php
        sei
        lda #0
        sta iec_eoi
        jsr ClkHi
        WaitFor IEC_CLKIN, IEC_CLKIN    ; talker ready to send
        bcs @err
@rdy:   jsr DataHi                      ; we are ready
        ldx #40
@w:     lda IEC_PORT
        and #IEC_CLKIN
        beq @start
        dex
        bne @w
        lda iec_eoi                     ; 200 us without clock: EOI
        bne @err
        lda #$80
        sta iec_eoi
        jsr DataLo                      ; acknowledge EOI
        ldx #30
        jsr Delay
        jmp @rdy
@start: lda #8
        sta iec_bc
@bit:   ldy iec_to
        ldx #0
@h:     lda IEC_PORT
        asl a                           ; N = CLK, C = DATA
        bmi @got
        dex
        bne @h
        dey
        bne @h
        jmp @err
@got:   ror iec_r
        ldy iec_to
        ldx #0
@lo:    lda IEC_PORT
        and #IEC_CLKIN
        beq @next
        dex
        bne @lo
        dey
        bne @lo
        jmp @err
@next:  dec iec_bc
        bne @bit
        jsr DataLo                      ; frame acknowledge
        lda iec_eoi
        bpl @done
        ldx #10
        jsr Delay
        jsr ClkHi                       ; last byte: release the bus
        jsr DataHi
@done:  lda iec_r
        plp
        clc
        rts
@err:   jsr IecIdle
        plp
        sec
        rts

IecPrep:                        ; one-time hardware setup
        IecHwInit
        lda #255
        sta iec_to
        jmp IecIdle
