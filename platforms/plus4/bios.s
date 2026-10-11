; bios.s - BIOS Commodore Plus/4 (TED 7360/8360): POST, konsola (TED tekst 40x25), klawiatura (macierz przez $FD30/$FF08),
; zegar 100 Hz (TED timer 1), czas programowy (brak TOD/RTC), nośnik: dysk w ROM cartridge + zapisywalna nakładka w RAM.
; Przejmuje maszynę (RAM wszędzie poza I/O $FD00-$FF3F, $FF3F), nie używa KERNAL-a. Tablica skoków jak w innych platformach.
        .include "bios.inc"
        .include "platform.inc"
        .include "hw.inc"
        .include "post.inc"
        .import LoadSystem, ReadBlk, WriteBlk, RomRdStart, IecInit, IecRead, IecWrite
        .export LdrRead
        .import PrintStr, PutCRLF, PrintHex8, PrintDec16, PrtAY, RowAY, RowEnd, TestRange, ResultRam, DetectCpu
        .import MsgOk, MsgFail, MsgNmos, MsgCmos, MsgKb, MsgPostFail, MsgNoBoot
        .export PutChar, ConGotoXY, Reset

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
        ldx #$FF
        txs
        sta TED_RAMON           ; $FF3F: RAM zamiast ROM wszędzie poza I/O $FD00-$FF3F
        sta ROM_BANK            ; wewnętrzne ROM-y (znaki TED z $D400 nie mogą pochodzić z cartridge)
        ZPPASS $00
        ZPPASS $FF
        ZPPASS $A5
        ldx #$FF
        txs
        lda #<NmiIrq            ; wektory (RAM pod ROM-em)
        sta $FFFA
        sta $FFFE
        lda #>NmiIrq
        sta $FFFB
        sta $FFFF
        lda #<Reset
        sta $FFFC
        lda #>Reset
        sta $FFFD
        lda #$02                ; $0200-$0FFF: zmienne BIOS i ekran, testujemy zanim ich użyjemy
        ldx #$10
        jsr TestRange
        sta scr_res
        lda post_page
        sta scr_pg
        jsr ConInit
        jmp PostMain

ZpFail:                         ; konsola jeszcze nie działa: czerwona ramka i stop
        lda #$1B
        sta TED_CTRL1
        lda #$42                ; czerwona ramka
        sta TED_BORDER
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

        ROW RowCpu
        jsr DetectCpu
        bne @nmos
        PRT MsgCmos
        jmp @cpu
@nmos:  PRT MsgNmos
@cpu:   jsr RowEnd

        ROW RowZp
        PRT MsgOk
        jsr RowEnd

        ROW RowRamA
        lda scr_pg
        sta post_page
        lda scr_res
        jsr ResultRam
        jsr RowEnd

        ROW RowRamB
        lda #$10
        ldx #$E7
        jsr TestRange
        jsr ResultRam
        jsr RowEnd

        ROW RowBios
        PRT MsgLoaded
        jsr RowEnd

        ; --- TED ---
        ROW RowVic
        lda #$6E
        sta TED_BORDER
        lda TED_BORDER
        and #$7F
        cmp #$6E
        beq @vok
        inc post_fail
        PRT MsgFail
        jmp @vend
@vok:   PRT MsgOk
@vend:  jsr RowEnd

        ; --- nośnik: dysk w ROM cartridge ---
        jsr CartInit            ; czytnik cartridge do RAM
        ROW RowDisk
        lda #1
        sta post_disk
        jsr IecInit             ; napęd 8 z dyskiem MiniUnix ma pierwszeństwo przed ROM
        bcs @romd
        bit drv_tr
        bpl @ie
        PRT MsgTcbDisk
        jmp @dend
@ie:    PRT MsgIecDisk
        jmp @dend
@romd:  PRT MsgRomDisk
@dend:
        jsr RowEnd

        ; --- zegar i czas ---
        ROW RowTmr
        lda #<TICK_DIV
        sta TED_T1LO
        lda #>TICK_DIV
        sta TED_T1HI            ; zapis starszego bajtu uruchamia timer 1
        lda TED_T1LO
        sta c_t
        ldx #30
@d:     dex
        bne @d
        lda TED_T1LO
        cmp c_t
        bne @tok
        inc post_fail
        PRT MsgFail
        jmp @tend
@tok:   jsr TodInit
        PRT MsgTmrOk
@tend:  jsr RowEnd

        inc post_row
        ldx post_row
        lda #0
        jsr ConGotoXY
        lda post_fail
        beq @pass
        PRT MsgPostFail
@halt:  jmp @halt
@pass:  jsr PutCRLF
        lda post_disk
        bne @load
        PRT MsgNoBoot
@h2:    jmp @h2
@load:  jmp LoadSystem

TICK_DIV = 8867                 ; PAL: timer 1 TED liczy z 886724 Hz / 8867 = 100,0 Hz (NTSC: 8949)

; ---------------- czas: zegar programowy (TED nie ma TOD), 100 Hz z TickAck, od 09:00:00, data stała ----------------
TodInit:
        lda #0
        sta rtc_tk
        sta rtc_sec
        sta rtc_min
        lda #$09
        sta rtc_hr
        lda #$11
        sta rtc_day
        lda #$10
        sta rtc_month
        lda #$26
        sta rtc_year
        rts

RtcRead:                        ; 7 B BCD -> (ptr): sek, min, godz (24 h), dzień tyg., dzień, miesiąc, rok
        sei                     ; spójny odczyt (zegar zmienia IRQ)
        ldy #0
        lda rtc_sec
        sta (ptr),y
        iny
        lda rtc_min
        sta (ptr),y
        iny
        lda rtc_hr
        sta (ptr),y
        iny
        lda #1
        sta (ptr),y             ; dzień tygodnia (nieznany)
        iny
        lda rtc_day
        sta (ptr),y
        iny
        lda rtc_month
        sta (ptr),y
        iny
        lda rtc_year
        sta (ptr),y
        cli
        clc
        rts

; ---------------- zegar systemowy 100 Hz: TED timer 1 ----------------
TickStart:
        lda #$FF
        sta TED_IRQST           ; skasuj zaległe flagi
        lda #$08
        sta TED_IRQEN           ; maska: tylko timer 1
        lda #<TICK_DIV
        sta TED_T1LO
        lda #>TICK_DIV
        sta TED_T1HI            ; start (tryb ciągły, przeładowanie samo)
        rts

TickAck:                        ; C=1 gdy był impuls timera 1; przy okazji liczy czas
        lda TED_IRQST
        and #$08
        beq @n
        lda #$08
        sta TED_IRQST           ; zapis 1 kasuje flagę
        sed
        inc rtc_tk              ; (binarnie; SED nie wpływa na INC)
        lda rtc_tk
        cmp #100
        bcc @done
        lda #0
        sta rtc_tk
        clc
        lda rtc_sec
        adc #1
        sta rtc_sec
        cmp #$60
        bcc @done
        lda #0
        sta rtc_sec
        clc
        lda rtc_min
        adc #1
        sta rtc_min
        cmp #$60
        bcc @done
        lda #0
        sta rtc_min
        clc
        lda rtc_hr
        adc #1
        sta rtc_hr
        cmp #$24
        bcc @done
        lda #0
        sta rtc_hr
@done:  cld
        sec
        rts
@n:     clc
        rts

; ---------------- konsola: TED tekst 40x25 (atrybuty $0800, znaki $0C00), kursor = odwrócony znak ----------------
ConInit:
        lda #0
        sta TED_IRQEN           ; bez przerwań (rastra, timerów)
        lda #$FF
        sta TED_IRQST           ; skasuj flagi
        lda #$1B                ; tekst, 25 wierszy, ekran włączony
        sta TED_CTRL1
        lda #$08                ; 40 kolumn
        sta TED_CTRL2
        lda #$04                ; zestaw znaków z ROM
        sta TED_CHARSEL
        lda #CHAR_BASE          ; znaki z ROM: $D400 = małe/duże litery
        sta TED_CHARBASE
        lda #$08                ; macierz atrybutów $0800, znaków $0C00
        sta TED_VMBASE
        lda #3                  ; kursor sprzętowy TED poza ekranem (pozycja 1023), własny kursor = odwrócony znak
        sta TED_CURHI
        lda #$FF
        sta TED_CURLO
        lda #BG_COLOR
        sta TED_BG
        lda #BORDER_COLOR
        sta TED_BORDER
        rts

CurLoad:
        lda cur_lo
        sta c_p
        lda cur_hi
        sta c_p+1
        rts

CurFlip:                        ; zamienia odwrócenie znaku pod kursorem
        jsr CurLoad
        ldy #0
        lda (c_p),y
        eor #$80
        sta (c_p),y
        rts

ConClear:
        lda #$20
        ldx #0
@s:     sta SCREEN,x
        sta SCREEN+$100,x
        sta SCREEN+$200,x
        sta SCREEN+$2E8,x
        inx
        bne @s
        lda #TEXT_COLOR
        ldx #0
@c:     sta COLORRAM,x
        sta COLORRAM+$100,x
        sta COLORRAM+$200,x
        sta COLORRAM+$2E8,x
        inx
        bne @c
        lda #0
        sta cur_col
        sta cur_row
        sta cur_lo
        lda #>SCREEN
        sta cur_hi
        jmp CurFlip

ConClearEol:
        jsr CurFlip
        ldy #0
@l:     lda #$20
        sta (c_p),y
        iny
        tya
        clc
        adc cur_col
        cmp #40
        bcc @l
        jmp CurFlip

ConGotoXY:                      ; A = kolumna, X = wiersz
        sta c_t
        txa
        pha
        jsr CurFlip
        pla
        tax
        stx cur_row
        lda c_t
        sta cur_col
        clc
        adc RowLo,x
        sta cur_lo
        lda RowHi,x
        adc #0
        sta cur_hi
        jmp CurFlip

Scroll:                         ; przewiń ekran o wiersz, ostatni wiersz pusty (kursor wyłączony)
        ldx #0                  ; kolejne strony osobno (kopiowanie w górę, bez nakładania)
@a:     lda SCREEN+40,x
        sta SCREEN,x
        inx
        bne @a
@b:     lda SCREEN+$128,x
        sta SCREEN+$100,x
        inx
        bne @b
@c:     lda SCREEN+$228,x
        sta SCREEN+$200,x
        inx
        bne @c
@d:     lda SCREEN+$328,x
        sta SCREEN+$300,x
        inx
        cpx #$C0
        bne @d
        ldx #39
        lda #$20
@e:     sta SCREEN+24*40,x
        dex
        bpl @e
        rts

PutChar:                        ; zachowuje A, X, Y
        sta c_t
        txa
        pha
        tya
        pha
        jsr CurFlip             ; zdejmij kursor
        lda c_t
        cmp #13
        beq @cr
        cmp #10
        beq @lf
        cmp #8
        bne :+
        jmp @bs
:
        cmp #32
        bcc @skip
        cmp #128
        bcs @skip
        tax
        lda AsciiToScr-32,x
        pha
        jsr CurLoad
        pla
        ldy #0
        sta (c_p),y
        inc cur_lo
        bne @i
        inc cur_hi
@i:     inc cur_col
        lda cur_col
        cmp #40
        bcc @done
        lda #0                  ; zawinięcie: wskaźnik już wskazuje początek następnego wiersza
        sta cur_col
        jmp @nextrow
@skip:  jmp @done
@cr:    sec
        lda cur_lo
        sbc cur_col
        sta cur_lo
        lda cur_hi
        sbc #0
        sta cur_hi
        lda #0
        sta cur_col
        jmp @done
@lf:    clc
        lda cur_lo
        adc #40
        sta cur_lo
        lda cur_hi
        adc #0
        sta cur_hi
@nextrow:
        inc cur_row
        lda cur_row
        cmp #25
        bcc @done
        jsr Scroll
        lda #24
        sta cur_row
        sec
        lda cur_lo
        sbc #40
        sta cur_lo
        lda cur_hi
        sbc #0
        sta cur_hi
        jmp @done
@bs:    lda cur_col
        beq @up
        dec cur_col
        jmp @dec
@up:    lda cur_row
        beq @done
        dec cur_row
        lda #39
        sta cur_col
@dec:   lda cur_lo
        bne @d1
        dec cur_hi
@d1:    dec cur_lo
@done:  jsr CurFlip             ; załóż kursor
        pla
        tay
        pla
        tax
        lda c_t
        rts

; ASCII (32-127) -> kod ekranowy zestawu małe/duże litery
AsciiToScr:
        .repeat 96, I
        .if (I + 32) = 64
        .byte 0
        .elseif ((I + 32) >= 91) .and ((I + 32) <= 95)
        .byte I + 32 - 64
        .elseif (I + 32) = 96
        .byte 39
        .elseif ((I + 32) >= 97) .and ((I + 32) <= 122)
        .byte I + 32 - 96
        .elseif (I + 32) = 123
        .byte 91
        .elseif (I + 32) = 124
        .byte 93
        .elseif (I + 32) = 125
        .byte 94
        .elseif (I + 32) = 126
        .byte 95
        .elseif (I + 32) = 127
        .byte 32
        .else
        .byte I + 32
        .endif
        .endrepeat

RowLo:  .repeat 25, I
        .byte <(SCREEN + I * 40)
        .endrepeat
RowHi:  .repeat 25, I
        .byte >(SCREEN + I * 40)
        .endrepeat

; ---------------- klawiatura: macierz 8x8 przez $FD30 (wybór wiersza, 0 = aktywny) i $FF08 (kolumny, 0 = wciśnięty) ----------------
KbScan:                         ; kb_now[wiersz] = kolumny wciśnięte (1 = wciśnięty)
        ldx #0
        lda #$FE
        sta tmp
@c:     lda tmp
        sta KB_SELECT
        lda #$FF
        sta TED_KBD             ; zapis zatrzaskuje stan klawiatury (bez joysticków)
        lda TED_KBD
        eor #$FF
        sta kb_now,x
        sec
        rol tmp
        inx
        cpx #8
        bne @c
        lda #$FF
        sta KB_SELECT
        rts

KbDelay:                        ; ok. 2 ms przy 1 MHz (odbicia styków)
        ldx #8
@o:     ldy #0
@i:     dey
        bne @i
        dex
        bne @o
        rts

; C=0, A = ASCII (nowe naciśnięcie), C=1 brak. Kontrakt: X i Y zachowane.
KeyGet: txa
        pha
        tya
        pha
        jsr KeyGetI
        sta c_t
        lda #0
        rol                     ; A = C
        sta tmp
        pla
        tay
        pla
        tax
        lda tmp
        lsr                     ; C z powrotem
        lda c_t
        rts

KeyGetI:
        jsr KbScan
        jsr KbNew               ; A = indeks klawisza+1 lub 0
        bne @cand
        jmp KbSync
@cand:  sta tmp2
        jsr KbDelay             ; potwierdź po chwili
        jsr KbScan
        jsr KbNew
        cmp tmp2
        beq @ok
        jmp KbSync              ; to były drgania
@ok:    sec
        sbc #1
        tax                     ; X = kolumna*8 + wiersz
        lda kb_now+1            ; Shift: wiersz 1, kolumna 7
        and #$80
        bne @sh
        lda KeyTab,x
        jmp @got
@sh:    lda KeyTabS,x
@got:   sta tmp2
        lda kb_now+7            ; C= (CBM): { } _ ~ na klawiszach W Q @ = (jak w VICE dla hosta)
        and #$20
        beq @nu
        ldx #3
@cb:    lda tmp2
        cmp CbmFrom,x
        bne @cn
        lda CbmTo,x
        sta tmp2
        jmp @nu
@cn:    dex
        bpl @cb
@nu:
        lda kb_now+7
        and #$04                ; CTRL
        beq @nc
        lda tmp2
        cmp #'a'
        bcc @nc
        cmp #'{'
        bcs @nc
        and #$1F
        sta tmp2
@nc:    jsr KbCopy
        lda tmp2
        beq @none
        clc
        rts
@none:  sec
        rts

KbCopy: ldx #7
@l:     lda kb_now,x
        sta kb_prev,x
        dex
        bpl @l
        rts

KbSync: jsr KbCopy
        sec
        rts

; pierwszy nowo wciśnięty klawisz (poza Shift/CTRL/C=) -> A = kolumna*8+wiersz+1, 0 = brak
KbNew:  ldx #0
@c:     lda kb_prev,x
        eor #$FF
        and kb_now,x
        and KbMask,x
        bne @f
        inx
        cpx #8
        bne @c
        lda #0
        rts
@f:     ldy #0
@r:     lsr
        bcs @h
        iny
        bne @r
@h:     txa
        asl
        asl
        asl
        sty tmp
        clc
        adc tmp
        adc #1
        rts

KbMask: .byte $FF, $7F, $FF, $FF, $FF, $FF, $FF, $DB   ; bez SHIFT (1,7), CTRL (7,2) i C= (7,5)

CbmFrom: .byte '@', 'w', 'q', '='
CbmTo:   .byte '_', '{', '}', '~'

;       wiersze 0..7 (zapis do $FD30), kolumny 0..7 (odczyt $FF08); 0 = brak znaku
KeyTab: .byte 8, 13, '\', 0, 0, 0, 0, '@'
        .byte '3', 'w', 'a', '4', 'z', 's', 'e', 0
        .byte '5', 'r', 'd', '6', 'c', 'f', 't', 'x'
        .byte '7', 'y', 'g', '8', 'b', 'h', 'u', 'v'
        .byte '9', 'i', 'j', '0', 'm', 'k', 'o', 'n'
        .byte 0, 'p', 'l', 0, '.', ':', '-', ','
        .byte 0, '*', ';', 0, 27, '=', '+', '/'
        .byte '1', 0, 0, '2', ' ', 0, 'q', 3
KeyTabS:.byte 8, 13, 0, 0, 0, 0, 0, '@'
        .byte '#', 'W', 'A', '$', 'Z', 'S', 'E', 0
        .byte '%', 'R', 'D', '&', 'C', 'F', 'T', 'X'
        .byte 39, 'Y', 'G', '(', 'B', 'H', 'U', 'V'
        .byte ')', 'I', 'J', '^', 'M', 'K', 'O', 'N'
        .byte 0, 'P', 'L', 0, '>', '[', '|', '<'
        .byte 0, '*', ']', 0, 27, '`', '+', '?'
        .byte '!', 0, 0, '"', ' ', 0, 'Q', 3

; ---------------- nośnik bloków (dysk w ROM cartridge + nakładka RAM, blk_rom.s) ----------------
ReadBlock:                      ; A = napęd (ignorowany), X/Y = blok, ptr = bufor
LdrRead:
        lda blk_dev             ; 0 = dysk ROM, 1 = napęd IEC
        bne @iec
        jmp ReadBlk
@iec:   jmp IecRead
WriteBlock:
        lda blk_dev
        bne @iec
        jmp WriteBlk
@iec:   jmp IecWrite

Unimpl: sec
        rts

NmiIrq: rti

; ---------------- dane ----------------
MsgBanner:   .byte "BIOS PLUS4 V0.1",0
MsgHeader:   .byte "TEST    RANGE           RESULT",0
MsgLoaded:   .byte "OK",0
MsgRomDisk:  .byte "OK 26KB ROM+RAM",0
MsgIecDisk:  .byte "OK IEC 8",0
MsgTcbDisk:  .byte "OK 1551 TCBM 8",0
MsgTmrOk:    .byte "OK 100 HZ",0
RowCpu:      .byte "CPU",0,0
RowZp:       .byte "RAM",0,"0002-01FF",0
RowRamA:     .byte "RAM",0,"0200-0FFF",0
RowRamB:     .byte "RAM",0,"1000-E6FF",0
RowBios:     .byte "BIOS",0,"E700-FFFF",0
RowVic:      .byte "VIDEO",0,"FF00",0
RowDisk:     .byte "DISK",0,"8000",0
RowTmr:      .byte "TIMER",0,"FF00",0

; ---------------- cartridge: czytnik bloków ROM kopiowany do RAM ----------------
CartInit:
        lda #0
        sta ovl_cnt             ; nakładka zapisów pusta
        ldx #(RAMCODE_LEN - 1)
@c:     lda RomRdStart,x
        sta RAMCODE,x
        dex
        bpl @c
        rts
