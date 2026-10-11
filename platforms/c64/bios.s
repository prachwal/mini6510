; bios.s - BIOS Commodore 64: POST, konsola (VIC-II 40x25), klawiatura (macierz CIA1),
; zegar 100 Hz (CIA1 timer A), czas (CIA1 TOD), nośnik bloków (REU). Przejmuje maszynę
; (ROM-y wyłączone, $01=$35), nie używa KERNAL-a. Tablica skoków i kontrakt jak w platformie 'generic'.
        .include "bios.inc"
        .include "hw.inc"
        .include "post.inc"
        .import LoadSystem, ReadBlk, WriteBlk
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
        lda #$2F                ; port procesora: ROM-y wyłączone, I/O widoczne
        sta $00
        lda #$35
        sta $01
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
        lda #$02                ; $0200-$07FF: zmienne BIOS i ekran, testujemy zanim ich użyjemy
        ldx #$08
        jsr TestRange
        sta scr_res
        lda post_page
        sta scr_pg
        jsr ConInit
        jmp PostMain

ZpFail:                         ; konsola jeszcze nie działa: czerwona ramka i stop
        lda #$1B
        sta VIC_CTRL1
        lda #2
        sta VIC_BORDER
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
        lda #$08
        ldx #$D0
        jsr TestRange
        jsr ResultRam
        jsr RowEnd

        ROW RowRamC
        lda #$E0
        ldx #$E8
        jsr TestRange
        jsr ResultRam
        jsr RowEnd

        ROW RowBios
        PRT MsgLoaded
        jsr RowEnd

        ; --- VIC-II ---
        ROW RowVic
        lda #$0E
        sta VIC_BORDER
        lda VIC_BORDER
        and #$0F
        cmp #$0E
        beq @vok
        inc post_fail
        PRT MsgFail
        jmp @vend
@vok:   PRT MsgOk
@vend:  jsr RowEnd

        ; --- REU (nośnik) ---
.ifdef CART
        jsr CartInit            ; instalacja czytnika banków w RAM, blk_mode = REU
.endif
        ROW RowDisk
        jsr ReuProbe
.ifdef CART
        bcs @cartrom
.else
        bcs @nodisk
.endif
        lda #1
        sta post_disk
        PRT MsgOk
        lda reu_banks           ; KB = banki * 64 (0 = 256 banków)
        bne @n256
        ldx #$40
        lda #0
        beq @pk
@n256:  lsr
        lsr
        tax                     ; starszy bajt
        lda reu_banks
        asl
        asl
        asl
        asl
        asl
        asl                     ; młodszy bajt
@pk:    jsr PrintDec16
        PRT MsgKb
.ifdef CART
        jsr CartToReu           ; ROM -> REU, dysk zapisywalny
        bcs @cfail
        PRT MsgPlusRom
        jmp @dend
@cfail: inc post_fail
        PRT MsgFail
        jmp @dend
@cartrom:                       ; brak REU: dysk tylko do odczytu z ROM
        lda #1
        sta blk_mode
        sta post_disk
        PRT MsgRomDisk
        jmp @dend
.endif
        jmp @dend
@nodisk:
        PRT MsgNoReu
@dend:  jsr RowEnd

        ; --- zegar i czas ---
        ROW RowTmr
        lda #<TICK_DIV
        sta CIA1_TALO
        lda #>TICK_DIV
        sta CIA1_TAHI
        lda #$11                ; start, wymuś załadowanie
        sta CIA1_CRA
        lda CIA1_TALO
        sta c_t
        ldx #30
@d:     dex
        bne @d
        lda CIA1_TALO
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

TICK_DIV = 9852                 ; PAL: 985248 Hz / 9852 = 100,01 Hz

; ---------------- czas: CIA1 TOD (12 h BCD + PM) od 09:00:00, data stała (brak baterii) ----------------
TodInit:
        lda #$00
        sta CIA1_CRB            ; zapis do TOD ustawia zegar (nie alarm)
        lda #$09                ; 09:00 AM (zapis godziny zatrzymuje TOD do zapisu dziesiątych)
        sta CIA1_TODHR
        lda #0
        sta CIA1_TODMIN
        sta CIA1_TODSEC
        sta CIA1_TOD10
        lda #$11
        sta rtc_day
        lda #$10
        sta rtc_month
        lda #$26
        sta rtc_year
        rts

RtcRead:                        ; 7 B BCD -> (ptr): sek, min, godz (24 h), dzień tyg., dzień, miesiąc, rok
        lda CIA1_TODHR          ; odczyt godziny zatrzymuje podgląd do odczytu dziesiątych
        sta c_t
        ldy #1
        lda CIA1_TODMIN
        sta (ptr),y
        dey
        lda CIA1_TODSEC
        sta (ptr),y
        lda CIA1_TOD10          ; odblokuj
        lda c_t
        and #$1F
        cmp #$12
        bne @h
        lda #0                  ; 12 AM = 00
@h:     ldx c_t
        bpl @am
        sed
        clc
        adc #$12                ; PM: +12 (BCD)
        cld
@am:    ldy #2
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
        clc
        rts

; ---------------- zegar systemowy 100 Hz: CIA1 timer A ----------------
TickStart:
        lda #$7F
        sta CIA1_ICR            ; maska: wszystko wyłączone
        lda CIA1_ICR            ; skasuj zaległe
        lda #<TICK_DIV
        sta CIA1_TALO
        lda #>TICK_DIV
        sta CIA1_TAHI
        lda #$81                ; IRQ od timera A
        sta CIA1_ICR
        lda #$91                ; 50 Hz dla TOD, wymuś załadowanie, start (tryb ciągły)
        sta CIA1_CRA
        rts

TickAck:                        ; C=1 gdy był impuls (odczyt ICR kasuje flagi)
        lda CIA1_ICR
        and #1
        beq @n
        sec
        rts
@n:     clc
        rts

; ---------------- REU: wykrycie i rozmiar ----------------
reu_orig = $0306
reu_mark = $0307
reu_cur  = $0308
reu_save = $0309
reu_cmp  = $030A

ReuByte:                        ; A = polecenie, Y = bank, adres w banku 0, 1 bajt <-> reu_tmp
        sta c_t
        sty REU_BANK
        lda #0
        sta REU_LO
        sta REU_MID
        sta REU_LENHI
        sta REU_ACTL
        lda #<reu_tmp
        sta REU_C64LO
        lda #>reu_tmp
        sta REU_C64HI
        lda #1
        sta REU_LENLO
        lda c_t
        sta REU_CMD
        rts

; wyjście: C=1 brak REU; reu_banks = liczba banków 64 KB (0 = 256). Nie zmienia zawartości REU.
ReuProbe:
        jmp @start
@no:    sec
        rts
@start: lda #$A5
        sta REU_MID
        lda REU_MID
        cmp #$A5
        bne @no
        lda #$5A
        sta REU_MID
        lda REU_MID
        cmp #$5A
        bne @no
        lda #0
        sta reu_banks
        lda #REU_FETCH
        ldy #0
        jsr ReuByte
        lda reu_tmp
        sta reu_orig
        eor #$FF
        sta reu_mark
        ldy #2
@lp:    sty reu_cur
        lda #REU_FETCH          ; zachowaj bajt z banku Y
        jsr ReuByte
        lda reu_tmp
        sta reu_save
        lda reu_mark            ; wpisz znacznik do banku Y
        sta reu_tmp
        lda #REU_STASH
        ldy reu_cur
        jsr ReuByte
        lda #REU_FETCH          ; czy bank Y istnieje (odczyt zwrotny = znacznik)?
        ldy reu_cur
        jsr ReuByte
        lda reu_tmp
        cmp reu_mark
        beq @ex
        jmp @alias              ; nie istnieje: rozmiar = Y banków (nic nie zapisano)
@ex:
        lda #REU_FETCH          ; czy bank 0 się zmienił (alias)?
        ldy #0
        jsr ReuByte
        lda reu_tmp
        sta reu_cmp
        lda reu_save            ; przywróć bank Y
        sta reu_tmp
        lda #REU_STASH
        ldy reu_cur
        jsr ReuByte
        lda reu_cmp
        cmp reu_mark
        beq @alias
        lda reu_cur
        asl
        bcs @big                ; 128 -> 256: pełne 16 MB
        tay
        bne @lp
@big:   lda #0
        beq @set
@alias: lda reu_cur
@set:   sta reu_banks
        clc
        rts

; ---------------- konsola: VIC-II tekst 40x25, kursor = odwrócony znak ----------------
ConInit:
        lda #$7F
        sta CIA1_ICR
        sta CIA2_ICR
        lda CIA1_ICR
        lda CIA2_ICR
        lda #$FF                ; klawiatura: PA wyjście (kolumny), PB wejście (wiersze)
        sta CIA1_DDRA
        sta CIA1_PRA
        lda #$00
        sta CIA1_DDRB
        lda #$03                ; bank VIC 0 ($0000-$3FFF)
        sta CIA2_DDRA
        lda CIA2_PRA
        ora #$03
        sta CIA2_PRA
        lda #0
        sta VIC_SPREN
        sta VIC_IRQEN
        lda #$1B                ; tekst, 25 wierszy, ekran włączony
        sta VIC_CTRL1
        lda #$08                ; 40 kolumn
        sta VIC_CTRL2
        lda #$17                ; ekran $0400, zestaw znaków $1800 (małe/duże litery)
        sta VIC_MEM
        lda #$0E
        sta VIC_BORDER
        lda #$06
        sta VIC_BG
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
        lda #$0E
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

; ---------------- klawiatura: macierz 8x8 przez CIA1, wykrywanie nowego naciśnięcia ----------------
KbScan:                         ; kb_now[kolumna] = wiersze wciśnięte (1 = wciśnięty)
        ldx #0
        lda #$FE
        sta tmp
@c:     lda tmp
        sta CIA1_PRA
        lda CIA1_PRB
        eor #$FF
        sta kb_now,x
        sec
        rol tmp
        inx
        cpx #8
        bne @c
        lda #$FF
        sta CIA1_PRA
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
        lda kb_now+1            ; Shift: LSHIFT (kol.1 bit7), RSHIFT (kol.6 bit4)
        and #$80
        sta tmp
        lda kb_now+6
        and #$10
        ora tmp
        bne @sh
        lda KeyTab,x
        jmp @got
@sh:    lda KeyTabS,x
@got:   sta tmp2
        cmp #'@'                ; C= + @ = '_' (VICE: host '_' => @ + C=; na klawiaturze jest klawisz <-)
        bne @nu
        lda kb_now+7
        and #$20
        beq @nu
        lda #'_'
        sta tmp2
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

KbMask: .byte $FF, $7F, $FF, $FF, $FF, $FF, $EF, $DB   ; bez LSHIFT, RSHIFT, CTRL i C=

;       wiersze 0..7 dla kolumn 0..7 (PA0..PA7); 0 = brak znaku
KeyTab: .byte 8, 13, 0, 0, 0, 0, 0, 0
        .byte '3', 'w', 'a', '4', 'z', 's', 'e', 0
        .byte '5', 'r', 'd', '6', 'c', 'f', 't', 'x'
        .byte '7', 'y', 'g', '8', 'b', 'h', 'u', 'v'
        .byte '9', 'i', 'j', '0', 'm', 'k', 'o', 'n'
        .byte '+', 'p', 'l', '-', '.', ':', '@', ','
        .byte '\', '*', ';', 0, 0, '=', '^', '/'
        .byte '1', '_', 0, '2', ' ', 0, 'q', 3
KeyTabS:.byte 8, 13, 0, 0, 0, 0, 0, 0
        .byte '#', 'W', 'A', '$', 'Z', 'S', 'E', 0
        .byte '%', 'R', 'D', '&', 'C', 'F', 'T', 'X'
        .byte 39, 'Y', 'G', '(', 'B', 'H', 'U', 'V'
        .byte ')', 'I', 'J', '0', 'M', 'K', 'O', 'N'
        .byte '+', 'P', 'L', '-', '>', '[', '@', '<'
        .byte '|', '*', ']', 0, 0, '=', '^', '?'
        .byte '!', '_', 0, '"', ' ', 0, 'Q', 3

; ---------------- nośnik bloków ----------------
ReadBlock:                      ; A = napęd (ignorowany), X/Y = blok, ptr = bufor
        jmp ReadBlk
WriteBlock:
        jmp WriteBlk

Unimpl: sec
        rts

NmiIrq: rti

; ---------------- dane ----------------
MsgBanner:   .byte "BIOS C64 V0.1",0
MsgHeader:   .byte "TEST    RANGE           RESULT",0
MsgLoaded:   .byte "OK",0
MsgNoReu:    .byte "NO REU",0
MsgPlusRom:  .byte " +ROM",0
MsgRomDisk:  .byte "OK RO 120 KB ROM",0
MsgTmrOk:    .byte "OK 100 HZ",0
RowCpu:      .byte "CPU",0,0
RowZp:       .byte "RAM",0,"0002-01FF",0
RowRamA:     .byte "RAM",0,"0200-07FF",0
RowRamB:     .byte "RAM",0,"0800-CFFF",0
RowRamC:     .byte "RAM",0,"E000-E7FF",0
RowBios:     .byte "BIOS",0,"E800-FFFF",0
RowVic:      .byte "VIDEO",0,"D000",0
RowDisk:     .byte "DISK",0,"DF00",0
RowTmr:      .byte "TIMER",0,"DC04",0

.ifdef CART
        .import RomRdStart, ReuWrite
; ---------------- cartridge: czytnik banków w RAM i kopia ROM -> REU ----------------
CartInit:
        lda #0
        sta blk_mode
        ldx #(RAMCODE_LEN - 1)
@c:     lda RomRdStart,x
        sta RAMCODE,x
        dex
        bpl @c
        rts

CartToReu:                      ; 480 bloków ROM -> REU (blok n -> adres n*256); C=1 błąd
        lda #<XFER_BUF
        sta ptr
        lda #>XFER_BUF
        sta ptr+1
        ldx #0
        ldy #0
@lp:    jsr RAMCODE             ; czyta blok X/Y z ROM do ptr (zachowuje X/Y)
        bcs @err
        jsr ReuWrite
        bcs @err
        inx
        bne @n
        iny
@n:     cpx #ROM_BLK_LO
        bne @lp
        cpy #ROM_BLK_HI
        bne @lp
        clc
        rts
@err:   sec
        rts
.endif
