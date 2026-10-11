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

; ---- kody błędów rozruchu (1-5 = BLK_ERR urządzenia) ----
ERR_TIMEOUT = 6
ERR_HEADER  = 7

; ---- tablica skoków BIOS (stałe adresy, wspólna dla wszystkich platform) ----
BIOS_PutChar   = $F806  ; A = znak
BIOS_PrintStr  = $F809  ; ptr2 -> tekst
BIOS_PutCRLF   = $F80C
BIOS_LoadSystem= $F812
BIOS_ReadBlock = $F815  ; A = napęd, X/Y = blok, ptr = bufor; C=1 błąd (A = kod)
BIOS_WriteBlock= $F818
BIOS_ConClear  = $F81B
BIOS_ConClearEol = $F81E
BIOS_ConGotoXY = $F821
BIOS_KeyGet    = $F824  ; -> C=0 A = znak (ASCII), C=1 brak klawisza; X i Y zachowane (k_readline polega na Y)
BIOS_TickAck   = $F827  ; C=1 gdy był impuls zegara (potwierdza go), C=0 gdy nie; tylko A
BIOS_TickStart = $F82A  ; uruchamia zegar systemowy 100 Hz z przerwaniem IRQ
BIOS_RtcRead   = $F82D  ; ptr -> 7 B BCD: sek, min, godz, dzień tyg., dzień, miesiąc, rok (00-99); C=1 brak RTC
