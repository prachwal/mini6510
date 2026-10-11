; bios.inc - stałe platformy (zgodne z platforma.md, 2026-10-11)
; Wspólne dla wszystkich modułów BIOS. Tylko stałe, bez kodu.

; ---- zero page zarezerwowana dla BIOS: $F0-$FF ----
ptr         = $F0       ; 2 B: wskaźnik RAM (testy, loader, bufor bloku)
ptr2        = $F2       ; 2 B: wskaźnik tekstu dla PrintStr
tmp         = $F4
tmp2        = $F5
ldr_cnt     = $F7       ; loader: pozostałe bloki
ldr_entry   = $FC       ; loader: adres startowy (2 B)
ldr_tmo     = $FE       ; loader: licznik limitu czasu (2 B)
; zmienne POST (POST kończy się przed loaderem, więc nakładanie jest bezpieczne)
post_fail   = $F6       ; licznik błędów krytycznych
post_row    = $F7       ; bieżący wiersz tabeli
wg_ov       = $F8       ; WaitSetup: bezpiecznik, przepełnienia
tr_pm       = $F9       ; test RAM: strona początkowa (też wg_lo)
tr_xm       = $FA       ; test RAM: strona końcowa wył. (też wg_hi)
tr_k        = $FB       ; test RAM: numer przebiegu (też post_ticks)
post_page   = $FC       ; test RAM: strona z błędem
post_disk   = $FD       ; 1 = nośnik obecny
tr_ph       = $FE       ; test RAM: faza 0 zapis / 1 odczyt
con_col     = $FF       ; ConGotoXY: kolumna
wg_lo       = tr_pm
wg_hi       = tr_xm
post_ticks  = tr_k

; ---- zatrzask shadow ----
SHADOW_LATCH = $DE00    ; bit 0: 0 = ROM, 1 = RAM

; ---- konsola szeregowa ----
CON_CTRL    = $DF00     ; zapis CONTROL, odczyt STATUS
CON_DATA    = $DF01
CON_RXCOUNT = $DF02

; ---- urządzenie blokowe ----
BLK_CMD     = $DF10     ; zapis
BLK_STATUS  = $DF10     ; odczyt
BLK_LO      = $DF11
BLK_HI      = $DF12
BLK_ADDR_LO = $DF13
BLK_ADDR_HI = $DF14
BLK_SIZE_LO = $DF15
BLK_SIZE_HI = $DF16
BLK_ERR     = $DF17
BLK_UNIT    = $DF18

BLK_CMD_RESET = $00
BLK_CMD_READ  = $01
BLK_CMD_WRITE = $02
BLK_CMD_INFO  = $03

BLK_ST_BUSY    = $01
BLK_ST_ERR     = $02
BLK_ST_NOMEDIA = $04
BLK_ST_WP      = $08

; ---- kontroler I2C ----
I2C_CTRL    = $DF20
I2C_DATA    = $DF21
I2C_STAT    = $DF22

; ---- zegar systemowy ----
TMR_CTRL    = $DF30
TMR_STATUS  = $DF31
TMR_DIV     = $DF32
TMR_COUNT   = $DF33

; ---- kody błędów rozruchu (1-5 = BLK_ERR urządzenia) ----
ERR_TIMEOUT = 6
ERR_HEADER  = 7
