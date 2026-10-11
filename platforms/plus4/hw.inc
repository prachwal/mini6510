; hw.inc - rejestry Plus/4 (tylko BIOS; jądro ich nie używa)
SCREEN      = $0C00     ; macierz znaków
COLORRAM    = $0800     ; macierz atrybutów (bity 0-3 barwa, 4-6 jasność)
; TED 7360/8360
TED_T1LO    = $FF00     ; timer 1 (zapis starszego bajtu uruchamia)
TED_T1HI    = $FF01
TED_KBD     = $FF08     ; zapis zatrzaskuje klawiaturę/joysticki, odczyt = kolumny (0 = wciśnięty)
TED_IRQST   = $FF09     ; flagi przerwań (zapis 1 kasuje): bit 1 raster, 3 timer 1, 4 timer 2, 6 timer 3
TED_IRQEN   = $FF0A     ; maska przerwań (te same bity), bit 0 = bit 8 linii rastra
TED_CURHI   = $FF0C     ; pozycja kursora sprzętowego (bity 0-1 = bity 8-9)
TED_CURLO   = $FF0D
TED_CTRL1   = $FF06     ; bit 4 ekran włączony, bit 3 25 wierszy
TED_CTRL2   = $FF07     ; bit 3 = 40 kolumn
TED_CHARSEL = $FF12     ; bit 2 = znaki z ROM
TED_CHARBASE= $FF13     ; bity 2-7 = adres znaków
TED_VMBASE  = $FF14     ; bity 3-7 = adres macierzy atrybutów (znaki 1 KB wyżej)
TED_BG      = $FF15
TED_BORDER  = $FF19
TED_ROMON   = $FF3E     ; zapis: ROM widoczny
TED_RAMON   = $FF3F     ; zapis: RAM widoczny
KB_SELECT   = $FD30     ; port 6529: wybór wiersza klawiatury (0 = aktywny)
ROM_BANK    = $FDD0     ; zapis pod $FDD0+n wybiera ROM: bity 0-1 niski ($8000), 2-3 wysoki ($C000): 0 wewn., 1 funkcyjny, 2 cartridge
CHAR_BASE   = $D4       ; zestaw małe/duże litery z ROM ($D400)
TEXT_COLOR  = $71       ; biały, jasność 7
BG_COLOR    = $26       ; niebieski, jasność 2
BORDER_COLOR= $46       ; niebieski, jasność 4
IO_START_HI = $E8       ; jądro nie może sięgać BIOS-u ($E800)
LOAD_MIN_HI = $02
; zmienne BIOS w RAM ($0300-$03FF; test RAM $0200-$0FFF robimy zanim ich użyjemy)
cur_lo      = $0300     ; wskaźnik kursora w pamięci ekranu
cur_hi      = $0301
cur_col     = $0302
cur_row     = $0303
kb_prev     = $0310     ; 8 B: poprzedni stan macierzy klawiatury
kb_now      = $0318     ; 8 B: bieżący stan
rtc_day     = $0320     ; data (BCD), czas liczy TickAck
rtc_month   = $0321
rtc_year    = $0322
rtc_tk      = $0323     ; setne części sekundy (binarnie 0-99)
rtc_sec     = $0324     ; BCD
rtc_min     = $0325
rtc_hr      = $0326     ; 24 h
; zero page BIOS (pożyczone z pól POST; PutChar nie jest wołany podczas TestRange)
c_p         = $F8       ; 2 B: wskaźnik w pamięci ekranu
c_t         = $FB       ; bajt roboczy
scr_res     = $E0       ; wynik testu RAM $0200-$0FFF (przed startem jądra ZP $E0 jest wolna)
scr_pg      = $E1
; dysk w ROM cartridge: bloki 0-47 w c1lo od $9000, bloki 48-107 w c1hi od $C000; strona = numer bloku + $90
ROM_SPLIT   = 48        ; pierwszy blok w c1hi
OVL_PAGE0   = $D0       ; nakładka zapisów: strony $D000-$E7FF (24 bloki)
OVL_SLOTS   = 24
ovl_cnt     = $03A0     ; liczba zajętych slotów nakładki
ovl_map     = $03A1     ; 24 B: numer bloku w każdym slocie
RAMCODE     = $0340     ; czytnik bloków kopiowany do RAM (działa przy ROM widocznym)
RAMCODE_LEN = 96
