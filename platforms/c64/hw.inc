; hw.inc - rejestry C64 (tylko BIOS; jądro ich nie używa)
SCREEN      = $0400
COLORRAM    = $D800
VIC_CTRL1   = $D011
VIC_CTRL2   = $D016
VIC_MEM     = $D018
VIC_SPREN   = $D015
VIC_IRQEN   = $D01A
VIC_BORDER  = $D020
VIC_BG      = $D021
CIA1_PRA    = $DC00     ; kolumny klawiatury (wyjście)
CIA1_PRB    = $DC01     ; wiersze klawiatury (wejście, 0 = wciśnięty)
CIA1_DDRA   = $DC02
CIA1_DDRB   = $DC03
CIA1_TALO   = $DC04
CIA1_TAHI   = $DC05
CIA1_TOD10  = $DC08
CIA1_TODSEC = $DC09
CIA1_TODMIN = $DC0A
CIA1_TODHR  = $DC0B
CIA1_ICR    = $DC0D
CIA1_CRA    = $DC0E
CIA1_CRB    = $DC0F
CIA2_PRA    = $DD00     ; bity 0-1: bank VIC
CIA2_DDRA   = $DD02
CIA2_ICR    = $DD0D
; REU (1700/1764/1750; w VICE: -reu) - nośnik bloków
REU_STATUS  = $DF00
REU_CMD     = $DF01
REU_C64LO   = $DF02
REU_C64HI   = $DF03
REU_LO      = $DF04
REU_MID     = $DF05
REU_BANK    = $DF06
REU_LENLO   = $DF07
REU_LENHI   = $DF08
REU_IRQM    = $DF09
REU_ACTL    = $DF0A
REU_STASH   = $90       ; execute, natychmiast, C64 -> REU
REU_FETCH   = $91       ; execute, natychmiast, REU -> C64
IO_START_HI = $D0
LOAD_MIN_HI = $02
; zmienne BIOS w RAM ($0300-$03FF; test RAM $0200-$07FF robimy zanim ich użyjemy)
cur_lo      = $0300     ; wskaźnik kursora w pamięci ekranu
cur_hi      = $0301
cur_col     = $0302
cur_row     = $0303
reu_banks   = $0304     ; liczba banków 64 KB (0 = 256)
reu_tmp     = $0305     ; bajt roboczy do DMA
kb_prev     = $0310     ; 8 B: poprzedni stan macierzy klawiatury
kb_now      = $0318     ; 8 B: bieżący stan
rtc_day     = $0320     ; data (BCD), TOD zlicza tylko godzinę
rtc_month   = $0321
rtc_year    = $0322
; zero page BIOS (pożyczone z pól POST; PutChar nie jest wołany podczas TestRange)
c_p         = $F8       ; 2 B: wskaźnik w pamięci ekranu
c_t         = $FB       ; bajt roboczy
scr_res     = $E0       ; wynik testu RAM $0200-$07FF (przed startem jądra ZP $E0 jest wolna)
scr_pg      = $E1
