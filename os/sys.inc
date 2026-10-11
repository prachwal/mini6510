.include "platform.inc"   ; KBASE (adres jądra) zależy od platformy
; Wywołania systemowe MiniUnix (JSR). Programy: NAME.COM (relokowalne, 8-bajtowy nagłówek),
; start: A = argc, X/Y = wskaźnik tablicy argv (16-bitowe wskaźniki do tekstów),
; zakończenie: RTS albo k_exit z A = kod wyjścia. Wolne ZP: $E0-$EF (przełączane między zadaniami).
; Pamięć programu: kod + BSS (zerowane) w slocie 12 KB; stos 64 B (nie głębiej niż ~25 JSR).
k_putc     = KBASE+$00  ; A = znak (stdout: konsola/plik/potok)
k_getc     = KBASE+$03  ; -> A, C=1 koniec wejścia (plik, potok pusty i zamknięty, ^D)
k_puts     = KBASE+$06  ; A/X = tekst
k_readline = KBASE+$09  ; A/X = bufor -> Y = długość
k_open     = KBASE+$0C  ; A/X = nazwa -> A = fd, C=1 błąd (A = kod)
k_read     = KBASE+$0F  ; A = fd, bp = bufor, Y = max (0=255) -> A = ile, 0 = EOF
k_close    = KBASE+$12
k_readdir  = KBASE+$15
k_creat    = KBASE+$1B  ; A/X = nazwa, Y = tryb 0 nowy / 1 zastąp / 2 dopisz
k_wr       = KBASE+$1E  ; bp = dane, Y = ile
k_wclose   = KBASE+$21
k_unlink   = KBASE+$24
k_putdec   = KBASE+$27  ; A/X = liczba
k_seek     = KBASE+$2A  ; A = fd, X/Y = pozycja
k_strerror = KBASE+$2D  ; A = kod -> A/X = tekst
k_eputs    = KBASE+$30  ; A/X = tekst na konsolę (stderr)
k_yield    = KBASE+$33  ; oddaj procesor
k_exit     = KBASE+$36  ; A = kod wyjścia
bp         = $84
