; MiniUnix 0.1 - jądro + shell (ca65). Ładowane pod $0400 przez loader BIOS.
; Konwencja: argumenty A/X/Y, błąd = C=1 (kod w A). Programy użytkownika: $2000, kończą RTS.
        .include "bios.inc"
        .include "platform.inc"
        .export Kstart

; ---- BIOS ----
PutChar   = BIOS_PutChar
ReadBlock = BIOS_ReadBlock
ConClear  = BIOS_ConClear
WriteBlock = BIOS_WriteBlock

; ---- zero page jądra ($80-$9F) ----
kp   = $80      ; wskaźnik ogólny (2)
ap   = $82      ; argumenty polecenia (2) - czytane przez programy
bp   = $84      ; bufor użytkownika dla k_read (2)
t0   = $86
t1   = $87
ep   = $88      ; (2)
spp  = $8A      ; (2)
dblk = $8C
dcnt = $8D
ridx = $8E
cc   = $8F
cn   = $90
cfd  = $91
idx  = $92
nb   = $93
bk   = $94      ; (2)
rem  = $96      ; (2)
jv   = $98      ; (2)
tp   = $9A      ; (2)
cp   = $9C      ; (2)
v16  = $9E      ; (2)
vfl  = $A0
f_start = $A1   ; (2)
f_len   = $A3   ; (2)
wi   = $A5
cp2  = $A6      ; (2)
tot  = $A8      ; (2) liczba bloków dysku
f_next = $AA
cur  = $AC      ; (2)
bst  = $AE      ; (2) najbliższy plik: start
ben  = $B0      ; (2) koniec (wył.)
g_start = $B2   ; (2) największa dziura
g_len   = $B4   ; (2)
g_sum   = $B6   ; (2) suma wolnych
gtmp = $B8      ; (2)
bfound = $BA
dd   = $BB      ; (2)
bdblk = $BD
boff = $BE
moved = $BF
lp   = $C0      ; (2) bieżąca linia
rp   = $C2      ; (2) prawa strona potoku
argc = $C4
in_fd = $C5     ; $FF = konsola
out_on = $C6    ; 1 = stdout do pliku
ipos = $C7
ilen = $C8
rc   = $C9      ; kod wyjścia ostatniego polecenia
pflags = $CA    ; bit0 wyjście do potoku, bit1 wejście z potoku
di   = $CB
cmode = $CC     ; 0 nowy, 1 zastąp, 2 dopisz
xc   = $CD
ecode = $CE
eo   = $CF
wbv  = $D0
afd  = $D1
lrc  = $D2      ; kod wyjścia poprzedniego polecenia
in_pipe = $D4   ; numer potoku stdin
out_pipe = $D5  ; numer potoku stdout
ibp  = $D6      ; (2) bufor stdin-pliku zadania
pp   = $D8      ; (2) wskaźnik bufora potoku
sp_id = $DA     ; id zadania utworzonego przez Dispatch ($FF brak)
rn   = $DB      ; (2)
rdelta = $DD
cwd  = $DF       ; bieżący katalog ($FF = root), dziedziczony przez zadania
qs   = $DE      ; stan cudzysłowu
; $E0-$EF: wolne dla programów użytkownika

; ---- bufory (RAM) ----
BLKBUF  = DB+$0600
LINEBUF = DB+$0700
DIRENT  = DB+$0780         ; 32 B (wpis katalogu)
nmbuf   = DB+$01A0         ; 11 B
fd_used = DB+$01B0         ; 8 deskryptorów
fd_sl   = DB+$01B8
fd_sh   = DB+$01C0
fd_ll   = DB+$01C8
fd_lh   = DB+$01D0
fd_pl   = DB+$01D8
fd_ph   = DB+$01E0
sv1     = DB+$01E8         ; 11 B (mv)
sv2     = DB+$01F4         ; 11 B (mv)
wr_act  = DB+$0200         ; pojedynczy plik do zapisu
wr_ll   = DB+$0201
wr_lh   = DB+$0202
wr_sl   = DB+$0203
wr_sh   = DB+$0204
slot_blk= DB+$0205
slot_off= DB+$0206
wl_l    = DB+$0207         ; koniec dostępnej dziury (wył.)
wl_h    = DB+$0208
wr_repl = DB+$0209         ; 1 = zastąp istniejący plik przy zamknięciu
wr_par  = DB+$020A         ; katalog nadrzędny zapisywanego pliku
wr_nm   = DB+$0210         ; 11 B
FNAME   = DB+$0220         ; nazwa/ścieżka z przekierowania (do 79 znaków)
PATHBUF = DB+$0270         ; ścieżka /bin/NAZWA (do 47 znaków)
RTC     = DB+$02A0         ; 7 bajtów z DS1307
tm_date = DB+$02A8         ; data FAT (2 B)
tm_time = DB+$02AA         ; czas FAT (2 B)
tm_sec  = DB+$02AC
PWDST   = DB+$02B0         ; stos indeksów katalogów dla pwd (8)
fparent = DB+$0570         ; katalog z ParsePath ($FF = root)
fidx    = DB+$0571         ; indeks znalezionego wpisu
f_flags = DB+$0572
dotk    = DB+$0573         ; 1 = '.', 2 = '..'
yt      = DB+$0574
lsdir   = DB+$0575
lflag   = DB+$0576
sv1p    = DB+$0577
sv2p    = DB+$0578
didx    = DB+$0579
pn      = DB+$057B
lt      = DB+$057C
tm_i    = DB+$02AD
tm_t    = DB+$02AE
KBUF    = DB+$0300
WBUF    = DB+$0400
; --- zadania i potoki (RAM, nie przełączane) ---
t_state = DB+$0500         ; 0 wolne, 1 gotowe, 2 zombie
t_sp    = DB+$0504
t_rc    = DB+$0508
t_name  = DB+$0510         ; 4 x 8
p_rd    = DB+$0530         ; 4 potoki
p_wr    = DB+$0534
p_wc    = DB+$0538         ; pisarz zamknął
p_rcl   = DB+$053C         ; czytelnik zamknął
kids    = DB+$0540
kidn    = DB+$0544
lastkid = DB+$0545
bgflag  = DB+$0546
nst     = DB+$0547
si      = DB+$0548
wfail   = DB+$0549         ; 1 = błąd zapisu przy przekierowaniu do pliku
lf_in   = DB+$054A         ; fd wejścia z pliku ($FF brak)
lf_out  = DB+$054B
ctask   = DB+$054C         ; bieżące zadanie
ticks   = DB+$0558         ; licznik impulsów zegara (2 B)
qcnt    = DB+$055A
ns      = DB+$054D
sbh     = DB+$054E
stg_lo  = DB+$0550         ; 4 etapy potoku
stg_hi  = DB+$0554
; --- per zadanie: blok 256 B @ $2800+256*t: +0 kopia ZP $80-$EF (112 B), +$70 ARGV, +$80 ARGBUF
TASK0   = DB+$0800
ARGV    = DB+$0870
ARGBUF  = DB+$0880
IBUF0   = DB+$0C00         ; bufor stdin-pliku zadania t: $2C00+256*t
PIPEBUF = DB+$1000         ; potok n: $3000+256*n
SLOT1   = $40           ; strony bazowe slotów programów: $4000, $7000, $A000

        .segment "CODE"
; ---- tablica wywołań systemowych (stałe adresy) ----
        jmp k_putc      ; $0400 A = znak (LF -> CRLF)
        jmp k_getc      ; $0403 -> A
        jmp k_puts      ; $0406 A/X = tekst zakończony 0
        jmp k_readline  ; $0409 A/X = bufor -> Y = długość
        jmp k_open      ; $040C A/X = nazwa -> A = fd
        jmp k_read      ; $040F A = fd, bp = bufor, Y = max (0=255) -> A = ile (0 = EOF)
        jmp k_close     ; $0412 A = fd
        jmp k_readdir   ; $0415 A = indeks -> DIRENT (16 B), C=1 koniec
        jmp k_nosys     ; $0418 (dawniej exec; programy uruchamia shell przez spawn)
        jmp k_creat     ; $041B A/X = nazwa, Y = tryb (0 nowy,1 zastąp,2 dopisz) -> C=1 błąd
        jmp k_wr        ; $041E bp = dane, Y = ile (1..255)
        jmp k_wclose    ; $0421 kończy zapis, wpisuje do katalogu
        jmp k_unlink    ; $0424 A/X = nazwa
        jmp PrintDec16  ; $0427 A/X = liczba 16-bit -> konsola/plik
        jmp k_seek      ; $042A A = fd, X/Y = pozycja (lo/hi)
        jmp k_strerror  ; $042D A = kod błędu -> A/X = tekst
        jmp k_eputs     ; $0430 A/X = tekst na konsolę (stderr, nie przekierowywany)
        jmp Yield       ; $0433 oddaj procesor innemu zadaniu
        jmp ExitTask    ; $0436 A = kod wyjścia, kończy zadanie

; ---------------- konsola ----------------
k_putc: pha
        lda out_on
        bne @o
        pla
        cmp #10
        bne @p
        lda #13
        jsr PutChar
        lda #10
@p:     jmp PutChar
@o:     cmp #1
        bne @pp
        pla
        jsr WrByte
        bcc @r
        lda #1
        sta wfail
        lda wbv
@r:     rts
@pp:    pla
        jmp PutPipe

; zapis bajtu do potoku (out_pipe); czeka (Yield) gdy pełny; zachowuje A, X, Y
PutPipe:
        sta wbv
        txa
        pha
        tya
        pha
        ldx out_pipe
@t:     lda p_rcl,x
        bne @drop               ; czytelnik zamknięty: dane są odrzucane
        lda p_wr,x
        clc
        adc #1
        cmp p_rd,x
        bne @room
        jsr Yield
        jmp @t
@room:  lda #0
        sta pp
        txa
        clc
        adc #>PIPEBUF
        sta pp+1
        ldy p_wr,x
        lda wbv
        sta (pp),y
        inc p_wr,x
@drop:  pla
        tay
        pla
        tax
        lda wbv
        clc
        rts

k_eputs:
        sta t0
        stx t1
        lda out_on
        pha
        lda #0
        sta out_on
        lda t0
        ldx t1
        jsr k_puts
        pla
        sta out_on
        rts

k_getc: lda in_fd
        cmp #$FF
        bne @file
@c:     jsr BIOS_KeyGet
        bcc @k
        jsr Yield
        jmp @c
@k:     cmp #4                  ; ^D = koniec wejścia
        beq @eof
        clc
        rts
@eof:   sec
        rts
@file:  jmp RdByte

; bajt ze stdin-pliku: C=0 A=bajt, C=1 koniec
RdByte: lda in_fd
        cmp #$FE
        bne @fd
        ldx in_pipe             ; odczyt z potoku; czeka (Yield) gdy pusty
@t:     lda p_rd,x
        cmp p_wr,x
        bne @has
        lda p_wc,x
        bne @eof2
        jsr Yield
        jmp @t
@has:   lda #0
        sta pp
        txa
        clc
        adc #>PIPEBUF
        sta pp+1
        ldy p_rd,x
        lda (pp),y
        inc p_rd,x
        clc
        rts
@eof2:  sec
        rts
@fd:    lda ipos
        cmp ilen
        bcc @have
        lda bp
        pha
        lda bp+1
        pha
        lda ibp
        sta bp
        lda ibp+1
        sta bp+1
        lda in_fd
        ldy #0
        jsr k_read
        tay
        pla
        sta bp+1
        pla
        sta bp
        bcs @eof
        sty ilen
        lda #0
        sta ipos
        cpy #0
        beq @eof
@have:  ldy ipos
        lda (ibp),y
        inc ipos
        clc
        rts
@eof:   sec
        rts

k_puts: sta kp
        stx kp+1
        ldy #0
@l:     lda (kp),y
        beq @d
        jsr k_putc
        iny
        bne @l
        inc kp+1
        jmp @l
@d:     rts

Erase:  lda #8
        jsr PutChar
        lda #' '
        jsr PutChar
        lda #8
        jmp PutChar

k_readline:
        sta kp
        stx kp+1
        ldy #0
@c:     jsr k_getc
        cmp #13
        beq @e
        cmp #10
        beq @e
        cmp #8
        beq @bs
        cmp #$7F
        beq @bs
        cmp #$15
        beq @kill
        cmp #3
        beq @brk
        cmp #32
        bcc @c
        cpy #78
        bcs @c
        sta (kp),y
        iny
        jsr k_putc
        jmp @c
@bs:    cpy #0
        beq @c
        dey
        jsr Erase
        jmp @c
@kill:  cpy #0
        beq @c
        dey
        jsr Erase
        jmp @kill
@brk:   lda #'^'
        jsr PutChar
        lda #'C'
        jsr PutChar
        ldy #0
@e:     lda #0
        sta (kp),y
        lda #10
        jsr k_putc
        rts

PrintDec16:                     ; A = lo, X = hi
        sta v16
        stx v16+1
        ldx #0
        stx vfl
@pw:    ldy #0
@sub:   lda v16
        sec
        sbc PowLo,x
        sta t0
        lda v16+1
        sbc PowHi,x
        bcc @out
        sta v16+1
        lda t0
        sta v16
        iny
        bne @sub
@out:   tya
        ora vfl
        beq @nx
        tya
        clc
        adc #'0'
        jsr k_putc
        lda #1
        sta vfl
@nx:    inx
        cpx #4
        bne @pw
        lda v16
        clc
        adc #'0'
        jmp k_putc

; ---------------- dysk / FS ----------------
ReadB:                          ; X/Y = blok -> BLKBUF, C=1 błąd
        lda #<BLKBUF
        sta ptr
        lda #>BLKBUF
        sta ptr+1
        lda #0
        jmp ReadBlock

ConvName:                       ; kp -> komponent ścieżki; nmbuf 8.3 wielkie litery; dotk; Y = indeks końca
        ldx #10
        lda #' '
@f:     sta nmbuf,x
        dex
        bpl @f
        lda #0
        sta dotk
        ldy #0
        lda (kp),y
        cmp #'.'
        bne @norm
        iny
        lda (kp),y
        cmp #'.'
        beq @dd
        cmp #0
        beq @d1
        cmp #' '
        beq @d1
        cmp #'/'
        beq @d1
        ldy #0
        jmp @norm
@d1:    lda #1
        sta dotk
        rts
@dd:    iny
        lda (kp),y
        beq @d2
        cmp #' '
        beq @d2
        cmp #'/'
        beq @d2
        ldy #0
        jmp @norm
@d2:    lda #2
        sta dotk
        rts
@norm:  ldx #0
@a:     lda (kp),y
        beq @end
        cmp #' '
        beq @end
        cmp #'/'
        beq @end
        cmp #'.'
        beq @dot
        cpx #8
        bcs @skip
        jsr Upper
        sta nmbuf,x
        inx
@skip:  iny
        bne @a
        rts
@dot:   iny
        ldx #8
@b:     lda (kp),y
        beq @end
        cmp #' '
        beq @end
        cmp #'/'
        beq @end
        cpx #11
        bcs @s2
        jsr Upper
        sta nmbuf,x
        inx
@s2:    iny
        bne @b
@end:   rts

Upper:  cmp #'a'
        bcc @r
        cmp #'{'
        bcs @r
        and #$DF
@r:     rts

; ścieżka (kp) -> nmbuf = ostatni komponent, fparent = katalog; C=1 błąd (A = kod)
ParsePath:
        lda cwd
        sta fparent
        ldy #0
        lda (kp),y
        cmp #'/'
        bne @loop
        lda #$FF
        sta fparent
        inc kp
        bne @loop
        inc kp+1
@loop:  jsr ConvName
        lda (kp),y
        cmp #'/'
        beq @dir
        clc
        rts
@dir:   sty yt
        lda dotk
        beq @named
        cmp #1
        beq @adv
        lda fparent             ; ".." -> rodzic
        cmp #$FF
        beq @adv
        jsr LoadEntry
        bcs @io
        ldy #16
        lda (ep),y
        sta fparent
        jmp @adv
@named: lda nmbuf
        cmp #' '
        beq @adv
        jsr FindFile
        bcs @nf
        lda f_flags
        cmp #2
        bne @nd
        lda fidx
        sta fparent
@adv:   ldy yt
        iny
        tya
        clc
        adc kp
        sta kp
        lda kp+1
        adc #0
        sta kp+1
        jmp @loop
@nf:    lda #2
        sec
        rts
@nd:    lda #13
        sec
        rts
@io:    lda #3
        sec
        rts

ParseFile:                      ; jak ParsePath, ale cel musi mieć nazwę (nie '.', '..', pusty)
        jsr ParsePath
        bcs @r
        lda dotk
        bne @bad
        lda nmbuf
        cmp #' '
        beq @bad
        clc
@r:     rts
@bad:   lda #7
        sec
        rts

; ścieżka katalogu (kp) -> A = indeks katalogu ($FF root); C=1 błąd
ParseDir:
        jsr ParsePath
        bcs @r
        lda dotk
        cmp #1
        beq @cur
        cmp #2
        beq @up
        lda nmbuf
        cmp #' '
        beq @cur
        jsr FindFile
        bcs @nf
        lda f_flags
        cmp #2
        bne @nd
        lda fidx
        clc
        rts
@cur:   lda fparent
        clc
        rts
@up:    lda fparent
        cmp #$FF
        beq @cur
        jsr LoadEntry
        bcs @io
        ldy #16
        lda (ep),y
        clc
        rts
@nf:    lda #2
        sec
        rts
@nd:    lda #13
        sec
        rts
@io:    lda #3
        sec
@r:     rts

LoadEntry:                      ; A = indeks wpisu -> BLKBUF, ep -> wpis, dblk = blok; C=1 błąd
        sta ridx
        ldx #0
        ldy #0
        jsr ReadB
        bcs @e
        lda BLKBUF+$13
        sta dblk
        lda BLKBUF+$14
        sta dcnt
        lda ridx
        lsr
        lsr
        lsr
        cmp dcnt
        bcs @e
        clc
        adc dblk
        sta dblk
        tax
        ldy #0
        jsr ReadB
        bcs @e
        lda ridx
        and #$07
        asl
        asl
        asl
        asl
        asl
        sta ep
        lda #>BLKBUF
        sta ep+1
        clc
        rts
@e:     sec
        rts

FindFile:                       ; nmbuf + fparent -> f_start, f_len, f_flags, fidx; C=1 nie znaleziono
        ldx #0
        ldy #0
        jsr ReadB
        bcs @err
        lda BLKBUF+$13
        sta dblk
        lda BLKBUF+$14
        sta dcnt
        lda #0
        sta fidx
@blk:   ldx dblk
        ldy #0
        jsr ReadB
        bcs @err
        lda #<BLKBUF
        sta ep
        lda #>BLKBUF
        sta ep+1
        lda #8
        sta cc
@ent:   ldy #15
        lda (ep),y
        beq @nx
        sta f_flags
        ldy #16
        lda (ep),y
        cmp fparent
        bne @nx
        ldy #0
@cmp:   lda (ep),y
        cmp nmbuf,y
        bne @nx
        iny
        cpy #11
        bne @cmp
        ldy #11
        lda (ep),y
        sta f_start
        iny
        lda (ep),y
        sta f_start+1
        iny
        lda (ep),y
        sta f_len
        iny
        lda (ep),y
        sta f_len+1
        clc
        rts
@nx:    lda ep
        clc
        adc #32
        sta ep
        inc fidx
        dec cc
        bne @ent
        inc dblk
        dec dcnt
        bne @blk
@err:   sec
        rts

k_readdir:                      ; A = indeks -> DIRENT (32 B), C=1 koniec
        jsr LoadEntry
        bcs @e
        ldy #31
@c:     lda (ep),y
        sta DIRENT,y
        dey
        bpl @c
        clc
        rts
@e:     sec
        rts

k_open: sta kp
        stx kp+1
        jsr ParseFile
        bcc OpenNm
        rts
OpenNm: ldx #0
@f:     lda fd_used,x
        beq @got
        inx
        cpx #8
        bne @f
        lda #1                  ; brak wolnych deskryptorów
        sec
        rts
@got:   stx t0
        jsr FindFile
        bcs @nf
        lda f_flags
        cmp #2
        bne @isf
        lda #12                 ; to katalog
        sec
        rts
@isf:   ldx t0
        lda #1
        sta fd_used,x
        lda f_start
        sta fd_sl,x
        lda f_start+1
        sta fd_sh,x
        lda f_len
        sta fd_ll,x
        lda f_len+1
        sta fd_lh,x
        lda #0
        sta fd_pl,x
        sta fd_ph,x
        txa
        clc
        rts
@nf:    lda #2                  ; brak pliku
        sec
        rts

k_close:
        tax
        lda #0
        sta fd_used,x
        clc
        rts

k_read: sta t0
        tax
        cpy #0
        bne @y
        ldy #255
@y:     sty t1
        sec
        lda fd_ll,x
        sbc fd_pl,x
        sta rem
        lda fd_lh,x
        sbc fd_ph,x
        sta rem+1
        ora rem
        beq @eof
        lda fd_pl,x
        beq @r1
        eor #$FF
        clc
        adc #1                  ; 256 - pos_lo
        cmp t1
        bcs @r1
        sta t1
@r1:    lda rem+1
        bne @r2
        lda rem
        cmp t1
        bcs @r2
        sta t1
@r2:    clc
        lda fd_sl,x
        adc fd_ph,x
        sta bk
        lda fd_sh,x
        adc #0
        sta bk+1
        ldx bk
        ldy bk+1
        jsr ReadB
        bcs @err
        ldx t0
        lda fd_pl,x
        sta spp
        lda #>BLKBUF
        sta spp+1
        ldy #0
@cp:    lda (spp),y
        sta (bp),y
        iny
        cpy t1
        bne @cp
        clc
        lda fd_pl,x
        adc t1
        sta fd_pl,x
        bcc @ok
        inc fd_ph,x
@ok:    lda t1
        clc
        rts
@eof:   lda #0
        clc
        rts
@err:   lda #3
        sec
        rts

k_nosys:
        lda #7
        sec
        rts

WriteB:                         ; X/Y = blok <- BLKBUF
        lda #<BLKBUF
        sta ptr
        lda #>BLKBUF
        sta ptr+1
        lda #0
        jmp WriteBlock

; najbliższy (najmniejszy start >= cur) niepusty plik -> bst/ben/bdblk/boff, bfound; ustawia tot
ScanMin:
        lda #0
        sta bfound
        ldx #0
        ldy #0
        jsr ReadB
        bcc @s0
        rts
@s0:    lda BLKBUF+$13
        sta dblk
        lda BLKBUF+$14
        sta dcnt
        lda BLKBUF+$15
        sta tot
        lda BLKBUF+$16
        sta tot+1
@blk:   ldx dblk
        ldy #0
        jsr ReadB
        bcc @r0
        rts
@r0:    lda #<BLKBUF
        sta ep
        lda #>BLKBUF
        sta ep+1
        lda #8
        sta cc
@ent:   ldy #15
        lda (ep),y
        bne @e1
        jmp @nx
@e1:    ldy #11
        lda (ep),y
        sta v16
        iny
        lda (ep),y
        sta v16+1
        ldy #14
        lda (ep),y
        clc
        adc v16
        sta gtmp
        lda v16+1
        adc #0
        sta gtmp+1
        ldy #13
        lda (ep),y
        beq @nz
        inc gtmp
        bne @nz
        inc gtmp+1
@nz:    lda gtmp
        cmp v16
        bne @ne
        lda gtmp+1
        cmp v16+1
        bne @ne
        jmp @nx
@ne:    lda v16+1
        cmp cur+1
        bcc @nx
        bne @ge
        lda v16
        cmp cur
        bcc @nx
@ge:    lda bfound
        beq @take
        lda v16+1
        cmp bst+1
        bcc @take
        bne @nx
        lda v16
        cmp bst
        bcs @nx
@take:  lda v16
        sta bst
        lda v16+1
        sta bst+1
        lda gtmp
        sta ben
        lda gtmp+1
        sta ben+1
        lda dblk
        sta bdblk
        lda ep
        sta boff
        lda #1
        sta bfound
@nx:    lda ep
        clc
        adc #32
        sta ep
        dec cc
        beq @nb
        jmp @ent
@nb:    inc dblk
        dec dcnt
        beq @fin
        jmp @blk
@fin:   clc
        rts

AddGap:                         ; gtmp = długość, cur = start
        lda gtmp
        ora gtmp+1
        beq @r
        clc
        lda g_sum
        adc gtmp
        sta g_sum
        lda g_sum+1
        adc gtmp+1
        sta g_sum+1
        lda gtmp+1
        cmp g_len+1
        bcc @r
        bne @set
        lda gtmp
        cmp g_len
        bcc @r
        beq @r
@set:   lda gtmp
        sta g_len
        lda gtmp+1
        sta g_len+1
        lda cur
        sta g_start
        lda cur+1
        sta g_start+1
@r:     rts

; dziury na dysku: g_start/g_len = największa, g_sum = suma wolnych, tot; C=1 błąd I/O
GapScan:
        ldx #0
        ldy #0
        jsr ReadB
        bcc @s0
        rts
@s0:    lda BLKBUF+$13
        clc
        adc BLKBUF+$14
        sta cur
        lda #0
        sta cur+1
        sta g_len
        sta g_len+1
        sta g_sum
        sta g_sum+1
        sta g_start
        sta g_start+1
@lp:    jsr ScanMin
        bcc @ok
        rts
@ok:    lda bfound
        beq @tail
        sec
        lda bst
        sbc cur
        sta gtmp
        lda bst+1
        sbc cur+1
        sta gtmp+1
        jsr AddGap
        lda ben
        sta cur
        lda ben+1
        sta cur+1
        jmp @lp
@tail:  sec
        lda tot
        sbc cur
        sta gtmp
        lda tot+1
        sbc cur+1
        sta gtmp+1
        bcc @d
        jsr AddGap
@d:     clc
        rts

; szuka wolnego wpisu katalogu -> slot_blk, slot_off; C=1 brak
FindFree:
        ldx #0
        ldy #0
        jsr ReadB
        bcs @err
        lda BLKBUF+$13
        sta dblk
        lda BLKBUF+$14
        sta dcnt
@blk:   ldx dblk
        ldy #0
        jsr ReadB
        bcs @err
        lda #<BLKBUF
        sta ep
        lda #8
        sta cc
@ent:   ldy #15
        lda (ep),y
        bne @nx
        lda dblk
        sta slot_blk
        lda ep
        sta slot_off
        clc
        rts
@nx:    lda ep
        clc
        adc #32
        sta ep
        dec cc
        bne @ent
        inc dblk
        dec dcnt
        bne @blk
@err:   sec
        rts

k_creat:                        ; A/X = nazwa, Y = tryb
        sta kp
        stx kp+1
        sty cmode
        lda wr_act
        beq @ok
        lda #6                  ; zapis już otwarty
        sec
        rts
@ok:    jsr ParseFile
        bcc @pf
        rts
@pf:    lda fparent
        sta wr_par
        jsr FindFile
        bcs @new
        lda f_flags
        cmp #2
        bne @nd2
        lda #12
        sec
        rts
@nd2:   lda cmode
        bne @old2
        lda #4
        sec
        rts
@old2:  jmp @old
@full:  lda #5
        sec
        rts
@io:    lda #3
        sec
        rts
@old:   lda #1
        bne @al
@new:   lda #0
@al:    sta wr_repl
        jsr FindFree
        bcs @full
        jsr GapScan
        bcs @io
        lda g_len
        ora g_len+1
        beq @full
        clc
        lda g_start
        adc g_len
        sta wl_l
        lda g_start+1
        adc g_len+1
        sta wl_h
        ldx #10
@c:     lda nmbuf,x
        sta wr_nm,x
        dex
        bpl @c
        lda g_start
        sta wr_sl
        lda g_start+1
        sta wr_sh
        lda #0
        sta wr_ll
        sta wr_lh
        lda #1
        sta wr_act
        lda cmode
        cmp #2
        bne @done
        lda wr_repl
        beq @done
        jsr TryInPlace
        bcc @done
        ; dopisywanie: skopiuj starą zawartość
        jsr OpenNm
        bcs @cerr
        sta afd
@cp:    lda #<KBUF
        sta bp
        lda #>KBUF
        sta bp+1
        lda afd
        ldy #0
        jsr k_read
        bcs @cd
        beq @cd
        tay
        jsr k_wr
        bcs @cw
        jmp @cp
@cd:    lda afd
        jsr k_close
@done:  clc
        rts
@cw:    pha
        lda afd
        jsr k_close
        pla
@cerr:  tax
        lda #0
        sta wr_act
        txa
        sec
        rts

FlushW:                         ; X/Y = blok <- WBUF; C=1 brak miejsca/błąd
        cpy wl_h
        bcc @ok
        bne @full
        cpx wl_l
        bcc @ok
@full:  lda #5
        sec
        rts
@ok:    lda #<WBUF
        sta ptr
        lda #>WBUF
        sta ptr+1
        lda #0
        jmp WriteBlock

; A = bajt do pliku zapisu; zachowuje A, X, Y; C=1 brak miejsca
WrByte: sta wbv
        txa
        pha
        tya
        pha
        lda wbv
        ldx wr_ll
        sta WBUF,x
        inc wr_ll
        clc
        bne @n
        lda wr_sl
        adc wr_lh
        tax
        lda wr_sh
        adc #0
        tay
        inc wr_lh
        jsr FlushW
@n:     pla
        tay
        pla
        tax
        bcc @ok
        lda #5
        rts
@ok:    lda wbv
        rts

k_wr:   sty t1
        lda #0
        sta wi
@l:     lda wi
        cmp t1
        beq @done
        tay
        lda (bp),y
        jsr WrByte
        bcs @err
        inc wi
        jmp @l
@done:  clc
@err:   rts

k_wclose:
        lda wr_act
        bne @go
        clc
        rts
@go:    lda wr_ll
        beq @dir
        tax
        lda #0
@z:     sta WBUF,x
        inx
        bne @z
        clc
        lda wr_sl
        adc wr_lh
        tax
        lda wr_sh
        adc #0
        tay
        jsr FlushW
        bcc @fo
        jmp @err
@fo:
@dir:   lda wr_repl
        beq @slot
        ldx #10
@o:     lda wr_nm,x
        sta nmbuf,x
        dex
        bpl @o
        lda wr_par
        sta fparent
        jsr FindFile
        bcs @slot
        ldy #15
        lda #0
        sta (ep),y
        ldx dblk
        ldy #0
        jsr WriteB
        bcs @err
@slot:  jsr GetTime
        ldx slot_blk
        ldy #0
        jsr ReadB
        bcs @err
        lda slot_off
        sta ep
        lda #>BLKBUF
        sta ep+1
        ldy #10
@n:     lda wr_nm,y
        sta (ep),y
        dey
        bpl @n
        ldy #11
        lda wr_sl
        sta (ep),y
        iny
        lda wr_sh
        sta (ep),y
        iny
        lda wr_ll
        sta (ep),y
        iny
        lda wr_lh
        sta (ep),y
        iny
        lda #1
        sta (ep),y
        iny
        lda wr_par
        sta (ep),y
        iny
        lda tm_date
        sta (ep),y
        iny
        lda tm_date+1
        sta (ep),y
        iny
        lda tm_time
        sta (ep),y
        iny
        lda tm_time+1
        sta (ep),y
        ldx slot_blk
        ldy #0
        jsr WriteB
        bcs @err
        lda #0
        sta wr_act
        clc
        rts
@err:   tax
        lda #0
        sta wr_act
        txa
        sec
        rts

k_unlink:
        sta kp
        stx kp+1
        jsr ParseFile
        bcc @pf
        rts
@pf:    jsr FindFile
        bcs @nf
        lda f_flags
        cmp #2
        bne @isf
        lda #12
        sec
        rts
@isf:
        ldy #15
        lda #0
        sta (ep),y
        ldx dblk
        ldy #0
        jmp WriteB
@nf:    lda #2
        sec
        rts

k_seek:                         ; A = fd, X/Y = pozycja (lo/hi), obcięta do długości
        stx bk
        sty bk+1
        tax
        lda bk+1
        cmp fd_lh,x
        bcc @ok
        bne @cl
        lda bk
        cmp fd_ll,x
        bcc @ok
        beq @ok
@cl:    lda fd_ll,x
        sta bk
        lda fd_lh,x
        sta bk+1
@ok:    lda bk
        sta fd_pl,x
        lda bk+1
        sta fd_ph,x
        clc
        rts

k_strerror:                     ; A = kod -> A/X = tekst
        cmp #15
        bcc @in
        lda #0
@in:    asl
        tax
        lda ErrTab,x
        pha
        lda ErrTab+1,x
        tax
        pla
        rts

; ---------------- zadania (wielozadaniowość kooperatywna) ----------------
; Stos: 4 plasterki po 64 B w stronie 1 (zadanie t: SP startowy SpTop[t]). Zmiana zadania = zapis/odczyt
; ZP $80-$EF (112 B) do bloku zadania i zmiana SP. Przełącza tylko Yield (czekanie na potok,
; konsolę, wait) i ExitTask, więc jądro nie wymaga reentrancji.
Yield:  php                     ; ramka jak z przerwania: Y,X,A,P,PCL,PCH (powrót przez RTI)
        pha
        txa
        pha
        tya
        pha
        tsx
        inc $0105,x             ; adres powrotu JSR+1 = dokładny PC
        bne Save
        inc $0106,x
Save:   lda #0
        sta ptr
        lda ctask
        clc
        adc #>TASK0
        sta ptr+1
        ldy #111
@s:     lda $80,y
        sta (ptr),y
        dey
        bpl @s
        tsx
        txa
        ldx ctask
        sta t_sp,x
Pick:   ldx ctask
@n:     inx
        cpx #4
        bcc @c
        ldx #0
@c:     lda t_state,x
        cmp #1
        bne @n
        stx ctask
        lda #0
        sta ptr
        txa
        clc
        adc #>TASK0
        sta ptr+1
        ldy #111
@r:     lda (ptr),y
        sta $80,y
        dey
        bpl @r
        ldx ctask
        lda t_sp,x
        tax
        txs
        pla
        tay
        pla
        tax
        pla
        rti

; przerwanie zegara: kod użytkownika (PC w $4000-$D7FF) jest wywłaszczany co QUANTUM impulsów,
; przerwanie w jądrze/BIOS tylko potwierdza i wraca (jądro nie jest reentrantne).
QUANTUM = 2
IrqHandler:
        pha
        txa
        pha
        tya
        pha
        jsr BIOS_TickAck
        bcc @exit
        inc ticks
        bne @t
        inc ticks+1
@t:     tsx
        lda $0106,x             ; starszy bajt przerwanego PC
        cmp #SLOT1
        bcc @exit
        cmp #SLOT_END_HI
        bcs @exit
        inc qcnt
        lda qcnt
        cmp #QUANTUM
        bcc @exit
        lda #0
        sta qcnt
        jmp Save
@exit:  pla
        tay
        pla
        tax
        pla
        rti

; A = kod wyjścia: zamyka końce potoków, zadanie -> zombie, przełącza
ExitTask:
        ldx ctask
        sta t_rc,x
        lda in_fd
        cmp #$FE
        bne @a
        ldx in_pipe
        lda #1
        sta p_rcl,x
@a:     lda out_on
        cmp #2
        bne @b
        ldx out_pipe
        lda #1
        sta p_wc,x
@b:     ldx ctask
        lda #2
        sta t_state,x
        jmp Pick

TaskEntry:                      ; start nowego zadania (ZP = kopia z Spawn)
        ldx ctask
        lda SlotHi-1,x
        sta jv+1
        lda #8                  ; kod programu po 8-bajtowym nagłówku
        sta jv
        txa
        clc
        adc #>TASK0
        tay                     ; X/Y = wskaźnik tablicy argv zadania
        ldx #$70
        lda argc
        jsr @call
        jmp ExitTask
@call:  jmp (jv)

SlotHi: .byte $40, $70, $A0
SpTop:  .byte $FF, $BF, $7F, $3F

BinPfx: .byte "/bin/"
ComExt: lda nmbuf+8
        cmp #' '
        bne @r
        lda #'C'
        sta nmbuf+8
        lda #'O'
        sta nmbuf+9
        lda #'M'
        sta nmbuf+10
@r:     rts

; Spawn: cp = nazwa polecenia, argv/ARGBUF z bloku zadania 0. Ładuje NAZWA.COM do wolnego slotu,
; relokuje, tworzy zadanie. Wyjście: C=0 A=numer zadania (sp_id); C=1 A=kod błędu.
Spawn:  ldx #1
@f:     lda t_state,x
        beq @got
        inx
        cpx #4
        bne @f
        lda #10
        sec
        rts
@got:   stx ns
        lda cp
        sta kp
        lda cp+1
        sta kp+1
        jsr ParseFile
        bcs @try2
        jsr ComExt
        jsr FindFile
        bcc @ff
@try2:  ldx #0                  ; nie znaleziono: spróbuj /bin/NAZWA
@p1:    lda BinPfx,x
        sta PATHBUF,x
        inx
        cpx #5
        bne @p1
        ldy #0
@p2:    lda (cp),y
        sta PATHBUF,x
        beq @p3
        inx
        iny
        cpy #40
        bne @p2
@p3:    lda #<PATHBUF
        sta kp
        lda #>PATHBUF
        sta kp+1
        jsr ParseFile
        bcs @nf8
        jsr ComExt
        jsr FindFile
        bcc @ff
@nf8:   lda #8
        sec
        rts
@ff:    lda f_len+1
        cmp #$2F
        bcc @sz
        lda #11
        sec
        rts
@sz:    ldx ns
        lda SlotHi-1,x
        sta sbh
        lda f_len+1
        sta nb
        lda f_len
        beq @z
        inc nb
@z:     lda #0
        sta ptr
        lda sbh
        sta ptr+1
        lda f_start
        sta bk
        lda f_start+1
        sta bk+1
@ld:    lda nb
        beq @loaded
        ldx bk
        ldy bk+1
        lda #0
        jsr ReadBlock
        bcc @rd
        lda #3
        sec
        rts
@rd:    inc ptr+1
        inc bk
        bne @nb
        inc bk+1
@nb:    dec nb
        jmp @ld
@loaded:
        ; --- relokacja: nagłówek [0,1] długość kodu [2,3] bss [4,5] liczba reloc [6,7] offset tabeli
        lda #0
        sta ptr
        lda sbh
        sta ptr+1
        ldy #4
        lda (ptr),y
        sta rn
        iny
        lda (ptr),y
        sta rn+1
        ldy #6
        lda (ptr),y
        sta ptr2
        iny
        lda (ptr),y
        clc
        adc sbh
        sta ptr2+1
        lda sbh
        sec
        sbc #SLOT1
        sta rdelta
        beq @bss
@lp:    lda rn
        ora rn+1
        beq @bss
        ldy #0
        lda (ptr2),y
        sta tmp
        iny
        lda (ptr2),y
        clc
        adc sbh
        sta tmp2
        ldy #0
        lda (tmp),y
        clc
        adc rdelta
        sta (tmp),y
        clc
        lda ptr2
        adc #2
        sta ptr2
        bcc @nc
        inc ptr2+1
@nc:    lda rn
        bne @dr
        dec rn+1
@dr:    dec rn
        jmp @lp
@bss:   ldy #0                  ; zerowanie BSS za kodem
        lda (ptr),y
        clc
        adc #8
        sta tmp
        iny
        lda (ptr),y
        adc sbh
        sta tmp2
        ldy #2
        lda (ptr),y
        sta rn
        iny
        lda (ptr),y
        sta rn+1
@zl:    lda rn
        ora rn+1
        beq @made
        ldy #0
        lda #0
        sta (tmp),y
        inc tmp
        bne @zn
        inc tmp2
@zn:    lda rn
        bne @zd
        dec rn+1
@zd:    dec rn
        jmp @zl
@made:  ; --- blok zadania: kopia ZP, argv/argbuf, nazwa, ramka stosu
        ldx ns
        lda #0
        sta ptr
        txa
        clc
        adc #>TASK0
        sta ptr+1
        ldy #111
@cz:    lda $80,y
        sta (ptr),y
        dey
        bpl @cz
        lda #0
        ldy #(ibp-$80)
        sta (ptr),y
        lda ns
        clc
        adc #>IBUF0
        ldy #(ibp+1-$80)
        sta (ptr),y
        ldy #$70
@ca:    lda TASK0,y
        sta (ptr),y
        iny
        bne @ca
        ldy #$71
@cf:    lda (ptr),y
        clc
        adc ns
        sta (ptr),y
        iny
        iny
        cpy #$81
        bcc @cf
        lda ns
        asl
        asl
        asl
        tax
        ldy #0
@nm:    lda ARGBUF,y
        beq @ne
        sta t_name,x
        inx
        iny
        cpy #7
        bne @nm
@ne:    lda #0
        sta t_name,x
        ldx ns
        lda SpTop,x
        sec
        sbc #5
        sta ptr                 ; ptr = $0100 + SP0 - 5
        lda #1
        sta ptr+1
        ldy #0
        lda #0
        sta (ptr),y             ; Y
        iny
        sta (ptr),y             ; X
        iny
        sta (ptr),y             ; A
        iny
        sta (ptr),y             ; P
        iny
        lda #<TaskEntry
        sta (ptr),y
        iny
        lda #>TaskEntry
        sta (ptr),y
        lda SpTop,x
        sec
        sbc #6
        sta t_sp,x
        lda #0
        sta t_rc,x
        lda #1
        sta t_state,x
        stx sp_id
        txa
        clc
        rts

; ---------------- shell ----------------
Kstart: cld
        ldx #$FF
        txs
        lda #0
        sta wr_act
        sta out_on
        sta rc
        sta lrc
        sta wfail
        sta ctask
        sta in_pipe
        sta out_pipe
        lda #$FF
        sta cwd
        sta in_fd
        sta lf_in
        lda #0
        ldx #3
@t:     sta t_state,x
        dex
        bpl @t
        lda #1
        sta t_state             ; zadanie 0 = shell
        lda #0
        sta ticks
        sta ticks+1
        sta qcnt
        lda #0
        sta ibp
        lda #>IBUF0
        sta ibp+1
        ldx #5
@sn:    lda ShellNm,x
        sta t_name,x
        dex
        bpl @sn
        lda #0                  ; zamknij deskryptory
        ldx #7
@z:     sta fd_used,x
        dex
        bpl @z
        lda #<IrqHandler        ; wektor IRQ/BRK jest w RAM (shadow)
        sta $FFFE
        lda #>IrqHandler
        sta $FFFF
        jsr BIOS_TickStart      ; zegar 100 Hz + IRQ
        cli
        lda #<MsgBanner
        ldx #>MsgBanner
        jsr k_puts
Shell:  jsr Reap
        lda #<MsgPrompt
        ldx #>MsgPrompt
        jsr k_puts
        lda #<LINEBUF
        ldx #>LINEBUF
        jsr k_readline
        lda #<LINEBUF
        sta lp
        lda #>LINEBUF
        sta lp+1
        jsr RunLine
        jmp Shell

ShellNm: .byte "shell",0

; zakończone zadania w tle: komunikat i zwolnienie
Reap:   ldx #1
@l:     lda t_state,x
        cmp #2
        bne @n
        txa
        pha
        lda #'['
        jsr k_putc
        txa
        clc
        adc #'0'
        jsr k_putc
        lda #<MsgDone
        ldx #>MsgDone
        jsr k_puts
        pla
        tax
        lda #0
        sta t_state,x
@n:     inx
        cpx #4
        bne @l
        rts

; wykonuje całą linię: etapy potoku, & (tło), czekanie na zadania
RunLine:
        jsr TrimR
        lda #0
        sta bgflag
        ldy #0
@e:     lda (lp),y
        beq @en
        iny
        bne @e
@en:    cpy #0
        beq @nobg
        dey
        lda (lp),y
        cmp #'&'
        bne @nobg
        lda #0
        sta (lp),y
        lda #1
        sta bgflag
        jsr TrimR
@nobg:  lda #0                  ; podział na etapy po '|'
        sta nst
@stage: ldx nst
        lda lp
        sta stg_lo,x
        lda lp+1
        sta stg_hi,x
        inc nst
        lda #0
        sta qs
        ldy #0
@f:     lda (lp),y
        beq @split
        cmp #'"'
        bne @nq
        lda qs
        eor #1
        sta qs
        jmp @nx
@nq:    cmp #'|'
        bne @nx
        lda qs
        bne @nx
        lda nst
        cmp #4
        bcs @nx
        lda #0
        sta (lp),y
        iny
        tya
        clc
        adc lp
        sta lp
        lda lp+1
        adc #0
        sta lp+1
        jmp @stage
@nx:    iny
        bne @f
@split: lda bgflag
        beq @go
        lda nst
        cmp #1
        beq @go
        lda #<MsgRedir          ; & tylko dla pojedynczego polecenia
        sta cp
        lda #>MsgRedir
        sta cp+1
        lda #7
        jmp Perror
@go:    lda #0
        ldx #15
@pz:    sta p_rd,x              ; wyzeruj potoki (p_rd..p_rcl)
        dex
        bpl @pz
        sta kidn
        lda #$FF
        sta lastkid
        sta lf_in
        lda #0
        sta lf_out
        ldx nst
        dex
        stx si
@run:   ldx si
        lda stg_lo,x
        sta lp
        lda stg_hi,x
        sta lp+1
        jsr Exec1
        dec si
        bpl @run
        lda bgflag
        beq @wait
        lda kidn                ; tło: komunikat z numerem zadania
        beq @bgd
        lda #'['
        jsr k_putc
        lda kids
        clc
        adc #'0'
        jsr k_putc
        lda #']'
        jsr k_putc
        lda #10
        jsr k_putc
@bgd:   rts
@wait:  jsr WaitKids
        lda lf_out
        beq @t1
        jsr k_wclose
        bcc @w1
        jsr Perror
        lda #0
        sta wfail
@w1:    lda wfail
        beq @t0
        lda #5
        jsr Perror
        lda #0
        sta wfail
@t0:    lda #0
        sta lf_out
@t1:    lda lf_in
        cmp #$FF
        beq @t2
        jsr k_close
        lda #$FF
        sta lf_in
@t2:    rts

WaitKids:
        ldx #0
@l:     cpx kidn
        beq @d
        lda kids,x
        tay
@w:     lda t_state,y
        cmp #2
        beq @ok
        jsr Yield
        jmp @w
@ok:    cpy lastkid
        bne @f
        lda t_rc,y
        sta rc
        sta lrc
@f:     lda #0
        sta t_state,y
        inx
        jmp @l
@d:     rts

; wycina z linii (lp) przekierowanie znakiem xc; C=0 znaleziono (FNAME, cmode)
Extract:
        lda #0
        sta qs
        ldy #0
@f:     lda (lp),y
        beq @none
        cmp #'"'
        bne @c1
        lda qs
        eor #1
        sta qs
        jmp @nxt
@c1:    cmp xc
        bne @nxt
        ldx qs
        beq @got
@nxt:   iny
        bne @f
@none:  sec
        rts
@got:   lda #1
        sta cmode
        lda #' '
        sta (lp),y
        iny
        lda (lp),y
        cmp xc
        bne @sp
        lda #2
        sta cmode
        lda #' '
        sta (lp),y
        iny
@sp:    lda (lp),y
        cmp #' '
        bne @nm
        iny
        bne @sp
@nm:    ldx #0
@c:     lda (lp),y
        beq @end
        cmp #' '
        beq @end
        cmp #'<'
        beq @end
        cmp #'>'
        beq @end
        cpx #78
        bcs @skip
        sta FNAME,x
        inx
@skip:  lda #' '
        sta (lp),y
        iny
        bne @c
@end:   lda #0
        sta FNAME,x
        clc
        rts

TrimR:  ldy #0
@e:     lda (lp),y
        beq @t
        iny
        bne @e
@t:     cpy #0
        beq @d
        dey
        lda (lp),y
        cmp #' '
        bne @d
        lda #0
        sta (lp),y
        jmp @t
@d:     rts

Tokenize:
        lda #0
        sta argc
        sta di
        sta qs
        ldy #0
@sk:    lda (lp),y
        beq @fin
        cmp #' '
        bne @st
        iny
        bne @sk
        rts
@st:    lda argc
        cmp #8
        bcs @fin
        asl
        tax
        lda di
        clc
        adc #<ARGBUF
        sta ARGV,x
        lda #>ARGBUF
        adc #0
        sta ARGV+1,x
        inc argc
@cp:    lda (lp),y
        beq @en
        cmp #'"'
        bne @sp
        lda qs
        eor #1
        sta qs
        iny
        jmp @cp
@sp:    cmp #' '
        bne @put
        ldx qs
        beq @en
@put:   ldx di
        sta ARGBUF,x
        inc di
        iny
        bne @cp
@en:    ldx di
        lda #0
        sta ARGBUF,x
        inc di
        jmp @sk
@fin:   rts

; wykonuje jeden etap (lp) potoku: przekierowania, tokenizacja, polecenie wbudowane lub spawn
Exec1:  lda #'<'
        sta xc
        jsr Extract
        bcs @noin
        lda bgflag
        bne @bad2
        lda FNAME
        beq @bad2
        lda #<FNAME
        ldx #>FNAME
        jsr k_open
        bcc @i2
        jmp @fail
@i2:    sta in_fd
        sta lf_in
        lda #0
        sta ipos
        sta ilen
        jmp @out
@bad2:  jmp @bad
@noin:  lda si
        beq @out
        lda #$FE                ; stdin z potoku (si-1)
        sta in_fd
        lda si
        sec
        sbc #1
        sta in_pipe
@out:   lda #'>'
        sta xc
        jsr Extract
        bcs @noout
        lda bgflag
        bne @bad2
        lda FNAME
        beq @bad2
        lda #<FNAME
        ldx #>FNAME
        ldy cmode
        jsr k_creat
        bcc @o2
        jmp @fail
@o2:    lda #1
        sta out_on
        sta lf_out
        lda #0
        sta wfail
        jmp @run
@noout: lda si
        clc
        adc #1
        cmp nst
        bcs @run                ; ostatni etap: konsola
        lda si
        sta out_pipe
        lda #2
        sta out_on
@run:   jsr TrimR
        jsr Tokenize
        lda argc
        beq @none
        jsr Dispatch
        lda sp_id
        cmp #$FF
        beq @sync
        ldx kidn                ; zadanie utworzone
        sta kids,x
        inc kidn
        ldx si
        inx
        cpx nst
        bne @rst
        sta lastkid             ; ostatni etap -> kod wyjścia zadania
        jmp @rst
@sync:  lda rc                  ; polecenie wbudowane wykonane od razu
        ldx si
        inx
        cpx nst
        bne @none
        sta lrc
@none:  lda out_on
        cmp #2
        bne @c1
        ldx out_pipe
        lda #1
        sta p_wc,x              ; builtin kończy pisanie
@c1:    lda in_fd
        cmp #$FE
        bne @rst
        ldx in_pipe
        lda #1
        sta p_rcl,x
        jmp @rst
@bad:   lda #<MsgRedir
        sta cp
        lda #>MsgRedir
        sta cp+1
        lda #7
        jsr Perror
        jmp @none
@fail:  pha
        lda #<FNAME
        sta cp
        lda #>FNAME
        sta cp+1
        pla
        jsr Perror
        jmp @none
@rst:   lda #$FF                ; shell wraca do konsoli
        sta in_fd
        lda #0
        sta out_on
        rts

Dispatch:
        lda ARGV
        sta cp
        lda ARGV+1
        sta cp+1
        ldy #0                  ; ap = argumenty (surowy tekst po poleceniu)
@a:     lda (lp),y
        cmp #' '
        bne @b
        iny
        bne @a
@b:     lda (lp),y
        beq @c
        cmp #' '
        beq @c
        iny
        bne @b
@c:     lda (lp),y
        cmp #' '
        bne @d
        iny
        bne @c
@d:     tya
        clc
        adc lp
        sta ap
        lda lp+1
        adc #0
        sta ap+1
        lda #0
        sta rc
        lda #$FF
        sta sp_id
        lda #<Cmds
        sta tp
        lda #>Cmds
        sta tp+1
@try:   ldy #0
        lda (tp),y
        beq @ext
@m:     lda (tp),y
        cmp (cp),y
        bne @no
        cmp #0
        beq @hit
        iny
        jmp @m
@no:    ldy #0
@zz:    lda (tp),y
        beq @ze
        iny
        bne @zz
@ze:    iny
        iny
        iny
        tya
        clc
        adc tp
        sta tp
        bcc @try
        inc tp+1
        jmp @try
@hit:   iny
        lda (tp),y
        sta jv
        iny
        lda (tp),y
        sta jv+1
        jmp (jv)                ; polecenie kończy RTS do Exec1
@ext:   jsr Spawn
        bcc @ok
        jmp Perror
@ok:    rts

; komunikat błędu na konsolę: "polecenie: tekst"; A = kod
Perror: sta ecode
        lda #1
        sta rc
        lda out_on
        sta eo
        lda #0
        sta out_on
        lda cp
        ldx cp+1
        jsr k_puts
        lda #<MsgCol
        ldx #>MsgCol
        jsr k_puts
        lda ecode
        jsr k_strerror
        jsr k_puts
        lda #10
        jsr k_putc
        lda eo
        sta out_on
        rts

cmd_help:
        lda #<MsgHelp
        ldx #>MsgHelp
        jmp k_puts

cmd_ver:
        lda #<MsgBanner
        ldx #>MsgBanner
        jmp k_puts

cmd_clear:
        jmp ConClear

cmd_echo:
        lda #1
        sta cn
@l:     lda cn
        cmp argc
        bcs @d
        cmp #1
        beq @s
        lda #' '
        jsr k_putc
@s:     lda cn
        asl
        tax
        lda ARGV+1,x
        pha
        lda ARGV,x
        sta t0
        pla
        tax
        lda t0
        jsr k_puts
        inc cn
        jmp @l
@d:     lda #10
        jmp k_putc

cmd_status:
        lda #<MsgRc
        ldx #>MsgRc
        jsr k_puts
        lda lrc
        ldx #0
        jsr PrintDec16
        lda #10
        jmp k_putc

ErrCreate:
        jmp Perror

SplitArgs:                      ; ap = "a b" -> a zakończone 0, cp2 -> b; C=1 brak drugiego
        ldy #0
@f:     lda (ap),y
        beq @u
        cmp #' '
        beq @s
        iny
        bne @f
@u:     sec
        rts
@s:     lda #0
        sta (ap),y
        iny
@k:     lda (ap),y
        cmp #' '
        bne @g
        iny
        bne @k
@g:     tya
        clc
        adc ap
        sta cp2
        lda ap+1
        adc #0
        sta cp2+1
        ldy #0
        lda (cp2),y
        beq @u
        clc
        rts

Usage:  lda #<MsgUsage
        ldx #>MsgUsage
        jmp k_puts

cmd_rm: lda ap
        ldx ap+1
        jsr k_unlink
        bcc @ok
        jmp Perror
@ok:    rts

cmd_touch:
        lda ap
        ldx ap+1
        ldy #0
        jsr k_creat
        bcs ErrCreate
        jmp WClose

WClose: jsr k_wclose
        bcc @ok
        jmp Perror
@ok:    rts

cmd_cp: jsr SplitArgs
        bcs Usage
        lda ap
        ldx ap+1
        jsr k_open
        bcs @nf
        sta cfd
        lda cp2
        ldx cp2+1
        ldy #1
        jsr k_creat
        bcc @r0
        pha
        lda cfd
        jsr k_close
        pla
        jmp Perror
@r0:
@r:     lda #<KBUF
        sta bp
        lda #>KBUF
        sta bp+1
        lda cfd
        ldy #0
        jsr k_read
        bcs @fin
        beq @fin
        tay
        jsr k_wr
        bcs @werr
        jmp @r
@fin:   jsr k_wclose
        lda cfd
        jmp k_close
@werr:  pha
        jsr k_wclose
        lda cfd
        jsr k_close
        lda cp2
        ldx cp2+1
        jsr k_unlink
        pla
        jmp Perror
@nf:    jmp Perror

NmToSv1: ldx #10
@l:     lda nmbuf,x
        sta sv1,x
        dex
        bpl @l
        rts
NmToSv2: ldx #10
@l:     lda nmbuf,x
        sta sv2,x
        dex
        bpl @l
        rts
Sv1ToNm: ldx #10
@l:     lda sv1,x
        sta nmbuf,x
        dex
        bpl @l
        rts
Sv2ToNm: ldx #10
@l:     lda sv2,x
        sta nmbuf,x
        dex
        bpl @l
        rts

cmd_mv: jsr SplitArgs
        bcc @a0
        jmp Usage
@a0:    lda ap
        sta kp
        lda ap+1
        sta kp+1
        jsr ParseFile
        bcc @p1
        jmp Perror
@p1:    jsr NmToSv1
        lda fparent
        sta sv1p
        jsr FindFile
        bcc @s1
        jmp @nf
@s1:    lda fidx
        sta didx
        lda f_flags
        sta lflag
        lda cp2
        sta kp
        lda cp2+1
        sta kp+1
        jsr ParseDir
        bcc @isdir
        cmp #2
        beq @ren
        jmp Perror
@ren:   lda cp2
        sta kp
        lda cp2+1
        sta kp+1
        jsr ParseFile
        bcc @r1
        jmp Perror
@r1:    jsr NmToSv2
        lda fparent
        sta sv2p
        jsr FindFile
        bcc @ex
        jmp @do
@isdir: sta sv2p
        ldx #10
@cn:    lda sv1,x
        sta sv2,x
        dex
        bpl @cn
        jsr Sv2ToNm
        lda sv2p
        sta fparent
        jsr FindFile
        bcc @ex
@do:    lda lflag
        cmp #2
        bne @mvit
        lda sv2p
@w:     cmp #$FF
        beq @mvit
        cmp didx
        beq @bad
        jsr k_readdir
        bcs @mvit
        lda DIRENT+16
        jmp @w
@mvit:  jsr Sv1ToNm
        lda sv1p
        sta fparent
        jsr FindFile
        bcs @nf
        ldy #10
@c:     lda sv2,y
        sta (ep),y
        dey
        bpl @c
        ldy #16
        lda sv2p
        sta (ep),y
        ldx dblk
        ldy #0
        jsr WriteB
        bcc @ok
        lda #3
        jmp Perror
@ok:    rts
@ex:    lda #4
        jmp Perror
@nf:    lda #2
        jmp Perror
@bad:   lda #7
        jmp Perror

cmd_cd: lda ap
        sta kp
        lda ap+1
        sta kp+1
        ldy #0
        lda (kp),y
        bne @p
        lda #$FF
        sta cwd
        rts
@p:     jsr ParseDir
        bcc @ok
        jmp Perror
@ok:    sta cwd
        rts

cmd_pwd:
        lda #0
        sta pn
        lda cwd
@u:     cmp #$FF
        beq @p
        ldx pn
        sta PWDST,x
        inc pn
        cpx #7
        bcs @p
        jsr k_readdir
        bcs @p
        lda DIRENT+16
        jmp @u
@p:     lda pn
        bne @n
        lda #'/'
        jsr k_putc
        jmp @nl
@n:     dec pn
        ldx pn
        lda PWDST,x
        pha
        lda #'/'
        jsr k_putc
        pla
        jsr k_readdir
        jsr PrintNm
        lda pn
        bne @n
@nl:    lda #10
        jmp k_putc

cmd_mkdir:
        lda ap
        sta kp
        lda ap+1
        sta kp+1
        jsr ParseFile
        bcc @p
        jmp Perror
@p:     jsr FindFile
        bcs @new
        lda #4
        jmp Perror
@new:   jsr FindFree
        bcs @full
        jsr GetTime
        ldx slot_blk
        ldy #0
        jsr ReadB
        bcs @io
        lda slot_off
        sta ep
        lda #>BLKBUF
        sta ep+1
        ldy #10
@n:     lda nmbuf,y
        sta (ep),y
        dey
        bpl @n
        ldy #11
        lda #0
        sta (ep),y
        iny
        sta (ep),y
        iny
        sta (ep),y
        iny
        sta (ep),y
        iny
        lda #2
        sta (ep),y
        iny
        lda fparent
        sta (ep),y
        iny
        lda tm_date
        sta (ep),y
        iny
        lda tm_date+1
        sta (ep),y
        iny
        lda tm_time
        sta (ep),y
        iny
        lda tm_time+1
        sta (ep),y
        ldx slot_blk
        ldy #0
        jsr WriteB
        bcs @io
        rts
@full:  lda #5
        jmp Perror
@io:    lda #3
        jmp Perror

cmd_rmdir:
        lda ap
        sta kp
        lda ap+1
        sta kp+1
        jsr ParseFile
        bcc @p
        jmp Perror
@p:     jsr NmToSv1
        lda fparent
        sta sv1p
        jsr FindFile
        bcs @nf
        lda f_flags
        cmp #2
        bne @nd
        lda fidx
        sta didx
        cmp cwd
        beq @busy
        lda #0
        sta idx
@l:     lda idx
        jsr k_readdir
        bcs @del
        lda DIRENT+15
        beq @nx
        lda DIRENT+16
        cmp didx
        beq @ne
@nx:    inc idx
        bne @l
@del:   jsr Sv1ToNm
        lda sv1p
        sta fparent
        jsr FindFile
        bcs @nf
        ldy #15
        lda #0
        sta (ep),y
        ldx dblk
        ldy #0
        jsr WriteB
        bcc @ok
        lda #3
        jmp Perror
@ok:    rts
@nf:    lda #2
        jmp Perror
@nd:    lda #13
        jmp Perror
@ne:    lda #14
        jmp Perror
@busy:  lda #6
        jmp Perror

cmd_date:
        jsr GetTime
        lda tm_date
        sta DIRENT+17
        lda tm_date+1
        sta DIRENT+18
        lda tm_time
        sta DIRENT+19
        lda tm_time+1
        sta DIRENT+20
        jsr PrintDT
        lda #':'
        jsr k_putc
        lda tm_sec
        jsr Print2
        lda #10
        jmp k_putc

cmd_df: jsr GapScan
        bcs @e
        lda #<MsgTotal
        ldx #>MsgTotal
        jsr k_puts
        lda tot
        ldx tot+1
        jsr PrintDec16
        lda #<MsgFree
        ldx #>MsgFree
        jsr k_puts
        lda g_sum
        ldx g_sum+1
        jsr PrintDec16
        lda #<MsgLargest
        ldx #>MsgLargest
        jsr k_puts
        lda g_len
        ldx g_len+1
        jsr PrintDec16
        lda #10
        jmp k_putc
@e:     rts

; defrag: przesuwa pliki w dół, likwidując dziury
DfErr:  lda #3
        jmp Perror

cmd_defrag:
        ldx #0
        ldy #0
        jsr ReadB
        bcc :+
        jmp DfErr
:
        lda BLKBUF+$13
        clc
        adc BLKBUF+$14
        sta cur
        lda #0
        sta cur+1
        sta moved
@lp:    jsr ScanMin
        bcc :+
        jmp DfErr
:
        lda bfound
        bne :+
        jmp @done
:
        lda bst
        cmp cur
        bne @mv
        lda bst+1
        cmp cur+1
        bne @mv
        lda ben
        sta cur
        lda ben+1
        sta cur+1
        jmp @lp
@mv:    sec
        lda ben
        sbc bst
        sta gtmp
        lda ben+1
        sbc bst+1
        sta gtmp+1
        lda bst
        sta bk
        lda bst+1
        sta bk+1
        lda cur
        sta dd
        lda cur+1
        sta dd+1
@cp:    lda gtmp
        ora gtmp+1
        beq @patch
        ldx bk
        ldy bk+1
        jsr ReadB
        bcc :+
        jmp DfErr
:
        ldx dd
        ldy dd+1
        jsr WriteB
        bcc :+
        jmp DfErr
:
        inc bk
        bne @a
        inc bk+1
@a:     inc dd
        bne @b
        inc dd+1
@b:     lda gtmp
        bne @c
        dec gtmp+1
@c:     dec gtmp
        jmp @cp
@patch: ldx bdblk
        ldy #0
        jsr ReadB
        bcc :+
        jmp DfErr
:
        lda boff
        sta ep
        lda #>BLKBUF
        sta ep+1
        ldy #11
        lda cur
        sta (ep),y
        iny
        lda cur+1
        sta (ep),y
        ldx bdblk
        ldy #0
        jsr WriteB
        bcc :+
        jmp DfErr
:
        lda dd
        sta cur
        lda dd+1
        sta cur+1
        inc moved
        jmp @lp
@done:  lda #<MsgDefrag
        ldx #>MsgDefrag
        jsr k_puts
        lda moved
        ldx #0
        jsr PrintDec16
        lda #10
        jmp k_putc

PrintNm:                        ; nazwa 8.3 z DIRENT, cc = liczba znaków
        lda #0
        sta cc
        ldy #0
@n:     lda DIRENT,y
        cmp #' '
        beq @sn
        jsr k_putc
        inc cc
@sn:    iny
        cpy #8
        bne @n
        lda DIRENT+8
        cmp #' '
        beq @r
        lda #'.'
        jsr k_putc
        inc cc
        ldy #8
@e:     lda DIRENT,y
        cmp #' '
        beq @se
        jsr k_putc
        inc cc
@se:    iny
        cpy #11
        bne @e
@r:     rts

Print2: ldx #'0'                ; A (<100) jako dwie cyfry
@t:     cmp #10
        bcc @o
        sbc #10
        inx
        bne @t
@o:     pha
        txa
        jsr k_putc
        pla
        clc
        adc #'0'
        jmp k_putc

PrintDT:                        ; data i czas FAT z DIRENT+17..20 -> "RRRR-MM-DD GG:MM"
        lda DIRENT+18
        lsr
        clc
        adc #<1980
        pha
        lda #>1980
        adc #0
        tax
        pla
        jsr PrintDec16
        lda #'-'
        jsr k_putc
        lda DIRENT+18
        and #1
        asl
        asl
        asl
        sta lt
        lda DIRENT+17
        lsr
        lsr
        lsr
        lsr
        lsr
        ora lt
        jsr Print2
        lda #'-'
        jsr k_putc
        lda DIRENT+17
        and #$1F
        jsr Print2
        lda #' '
        jsr k_putc
        lda DIRENT+20
        lsr
        lsr
        lsr
        jsr Print2
        lda #':'
        jsr k_putc
        lda DIRENT+20
        and #7
        asl
        asl
        asl
        sta lt
        lda DIRENT+19
        lsr
        lsr
        lsr
        lsr
        lsr
        ora lt
        jmp Print2

cmd_ls: lda #0
        sta lflag
        ldy #0
        lda (ap),y
        cmp #'-'
        bne @np
        iny
        lda (ap),y
        cmp #'l'
        bne @np
        lda #1
        sta lflag
        iny
@sk:    lda (ap),y
        cmp #' '
        bne @pp
        iny
        bne @sk
@pp:    tya
        clc
        adc ap
        sta kp
        lda ap+1
        adc #0
        sta kp+1
        jmp @gp
@np:    lda ap
        sta kp
        lda ap+1
        sta kp+1
@gp:    ldy #0
        lda (kp),y
        bne @pd
        lda cwd
        jmp @go
@pd:    jsr ParseDir
        bcc @go
        jmp Perror
@go:    sta lsdir
        lda #0
        sta idx
@l:     lda idx
        jsr k_readdir
        bcc @r1
        rts
@r1:    lda DIRENT+15
        beq @nx
        lda DIRENT+16
        cmp lsdir
        bne @nx
        lda lflag
        beq @nm
        jsr PrintDT
        lda #' '
        jsr k_putc
@nm:    jsr PrintNm
        lda DIRENT+15
        cmp #2
        bne @pad
        lda #'/'
        jsr k_putc
        inc cc
@pad:   lda #' '
        jsr k_putc
        inc cc
        lda cc
        cmp #13
        bcc @pad
        lda DIRENT+15
        cmp #2
        bne @sz
        lda #'d'
        jsr k_putc
        lda #'i'
        jsr k_putc
        lda #'r'
        jsr k_putc
        jmp @eol
@sz:    lda DIRENT+13
        ldx DIRENT+14
        jsr PrintDec16
@eol:   lda #10
        jsr k_putc
@nx:    inc idx
        bne @l
        rts

cmd_uptime:
        lda ticks
        ldx ticks+1
        jsr PrintDec16
        lda #<MsgTicks
        ldx #>MsgTicks
        jsr k_puts
        lda #10
        jmp k_putc

cmd_ps: lda #0
        sta idx
@l:     ldx idx
        lda t_state,x
        beq @nx
        txa
        clc
        adc #'0'
        jsr k_putc
        lda #' '
        jsr k_putc
        ldx idx
        lda t_state,x
        cmp #1
        bne @z
        lda #'R'
        bne @p
@z:     lda #'Z'
@p:     jsr k_putc
        lda #' '
        jsr k_putc
        lda idx
        asl
        asl
        asl
        clc
        adc #<t_name
        sta kp
        lda #>t_name
        adc #0
        sta kp+1
        lda kp
        ldx kp+1
        jsr k_puts
        lda #10
        jsr k_putc
@nx:    inc idx
        lda idx
        cmp #4
        bne @l
        rts

cmd_kill:
        ldy #0
        lda (ap),y
        sec
        sbc #'0'
        cmp #1
        bcc @bad
        cmp #4
        bcs @bad
        tax
        lda t_state,x
        cmp #1
        bne @bad
        stx idx
        lda #0                  ; zamknij końce potoków z zapisanego ZP zadania
        sta ptr
        txa
        clc
        adc #>TASK0
        sta ptr+1
        ldy #(in_fd-$80)
        lda (ptr),y
        cmp #$FE
        bne @a
        ldy #(in_pipe-$80)
        lda (ptr),y
        tax
        lda #1
        sta p_rcl,x
@a:     ldy #(out_on-$80)
        lda (ptr),y
        cmp #2
        bne @b
        ldy #(out_pipe-$80)
        lda (ptr),y
        tax
        lda #1
        sta p_wc,x
@b:     ldx idx
        lda #137
        sta t_rc,x
        lda #2
        sta t_state,x
        rts
@bad:   lda #7
        jmp Perror

; ---------------- czas (RTC DS1307 przez I2C) ----------------
Bcd:    sta lt                  ; A (BCD) -> A (binarnie)
        lsr
        lsr
        lsr
        lsr
        sta tm_t
        asl
        asl
        asl
        clc
        adc tm_t
        adc tm_t
        sta tm_t
        lda lt
        and #$0F
        clc
        adc tm_t
        rts

GetTime:
        jsr GetTimeRd
        bcs @def
        rts
@def:   lda #$21
        sta tm_date
        lda #0
        sta tm_date+1
        sta tm_time
        sta tm_time+1
        sta tm_sec
        rts

GetTimeRd:
        lda #<RTC
        sta ptr
        lda #>RTC
        sta ptr+1
        jsr BIOS_RtcRead        ; 7 B BCD -> RTC; C=1 brak
        bcc @rd
        sec
        rts
@rd:
        ldx #0
@cv:    lda RTC,x
        cpx #0
        bne @c1
        and #$7F
@c1:    cpx #2
        bne @c2
        and #$3F
@c2:    cpx #4
        bne @c3
        and #$3F
@c3:    cpx #5
        bne @c4
        and #$1F
@c4:    stx tm_i
        jsr Bcd
        ldx tm_i
        sta RTC,x
        inx
        cpx #7
        bne @cv
        lda RTC
        sta tm_sec
        lda RTC+6
        clc
        adc #20
        asl
        sta tm_date+1
        lda RTC+5
        lsr
        lsr
        lsr
        ora tm_date+1
        sta tm_date+1
        lda RTC+5
        and #7
        asl
        asl
        asl
        asl
        asl
        ora RTC+4
        sta tm_date
        lda RTC+2
        asl
        asl
        asl
        sta tm_time+1
        lda RTC+1
        lsr
        lsr
        lsr
        ora tm_time+1
        sta tm_time+1
        lda RTC+1
        and #7
        asl
        asl
        asl
        asl
        asl
        sta tm_time
        lda RTC
        lsr
        ora tm_time
        sta tm_time
        clc
        rts
@bad:   sec
        rts

; dopisywanie w miejscu: wolne bloki za plikiem; C=1 -> trzeba kopiować
TryInPlace:
        lda f_len
        ora f_len+1
        bne @nz
        sec
        rts
@nz:    lda f_len+1
        clc
        adc f_start
        sta cur
        lda f_start+1
        adc #0
        sta cur+1
        lda f_len
        beq @e1
        inc cur
        bne @e1
        inc cur+1
@e1:    jsr ScanMin
        bcs @no
        lda bfound
        beq @tot
        lda bst
        sta gtmp
        lda bst+1
        sta gtmp+1
        jmp @rm
@tot:   lda tot
        sta gtmp
        lda tot+1
        sta gtmp+1
@rm:    sec
        lda gtmp
        sbc cur
        tax
        lda gtmp+1
        sbc cur+1
        bne @ok
        cpx #2
        bcc @no
@ok:    lda f_len
        beq @nol
        clc
        lda f_start
        adc f_len+1
        tax
        lda f_start+1
        adc #0
        tay
        jsr ReadB
        bcs @no
        ldx #0
@cp:    lda BLKBUF,x
        sta WBUF,x
        inx
        bne @cp
@nol:   lda gtmp
        sta wl_l
        lda gtmp+1
        sta wl_h
        lda f_start
        sta wr_sl
        lda f_start+1
        sta wr_sh
        lda f_len
        sta wr_ll
        lda f_len+1
        sta wr_lh
        clc
        rts
@no:    sec
        rts

; ---------------- dane ----------------
PowLo:  .byte <10000, <1000, <100, <10
PowHi:  .byte >10000, >1000, >100, >10

Cmds:   .byte "help",0
        .addr cmd_help
        .byte "ls",0
        .addr cmd_ls
        .byte "uptime",0
        .addr cmd_uptime
        .byte "ps",0
        .addr cmd_ps
        .byte "kill",0
        .addr cmd_kill
        .byte "echo",0
        .addr cmd_echo
        .byte "clear",0
        .addr cmd_clear
        .byte "ver",0
        .addr cmd_ver
        .byte "rm",0
        .addr cmd_rm
        .byte "cp",0
        .addr cmd_cp
        .byte "mv",0
        .addr cmd_mv
        .byte "touch",0
        .addr cmd_touch
        .byte "df",0
        .addr cmd_df
        .byte "status",0
        .addr cmd_status
        .byte "defrag",0
        .addr cmd_defrag
        .byte "cd",0
        .addr cmd_cd
        .byte "pwd",0
        .addr cmd_pwd
        .byte "mkdir",0
        .addr cmd_mkdir
        .byte "rmdir",0
        .addr cmd_rmdir
        .byte "date",0
        .addr cmd_date
        .byte 0

MsgBanner:   .byte "MiniUnix 0.1 (6510)",10,0
MsgPrompt:   .byte "# ",0
MsgHelp:     .byte "ls [-l] cd pwd mkdir rmdir date echo cp mv rm touch df defrag status ps kill uptime clear ver help",10,"cmd > f, >> f, < f, a | b, cmd &; NAME runs NAME.COM (cat upper wc tick ...)",10,0
MsgDone:     .byte "] done",10,0
MsgTicks:    .byte " ticks (10 ms)",0
MsgRedir:    .byte "redirect",0
MsgCol:      .byte ": ",0
MsgRc:       .byte "rc ",0
ErrTab:      .addr E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13, E14
E0:          .byte "error",0
E1:          .byte "too many open files",0
E2:          .byte "no such file",0
E3:          .byte "I/O error",0
E4:          .byte "file exists",0
E5:          .byte "no space",0
E6:          .byte "busy",0
E7:          .byte "bad argument",0
E8:          .byte "command not found",0
E9:          .byte "pipe full (output truncated)",0
E10:         .byte "no free task slot",0
E11:         .byte "bad executable",0
E12:         .byte "is a directory",0
E13:         .byte "not a directory",0
E14:         .byte "directory not empty",0
MsgUsage:    .byte "usage: cmd src dst",10,0
MsgTotal:    .byte "blocks total ",0
MsgFree:     .byte ", free ",0
MsgLargest:  .byte ", largest ",0
MsgDefrag:   .byte "defrag: moved ",0
