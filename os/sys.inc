; Wywołania systemowe MiniUnix (JSR). Programy: NAME.COM (relokowalne, 8-bajtowy nagłówek),
; start: A = argc, X/Y = wskaźnik tablicy argv (16-bitowe wskaźniki do tekstów),
; zakończenie: RTS albo k_exit z A = kod wyjścia. Wolne ZP: $E0-$EF (przełączane między zadaniami).
; Pamięć programu: kod + BSS (zerowane) w slocie 12 KB; stos 64 B (nie głębiej niż ~25 JSR).
k_putc     = $0400  ; A = znak (stdout: konsola/plik/potok)
k_getc     = $0403  ; -> A, C=1 koniec wejścia (plik, potok pusty i zamknięty, ^D)
k_puts     = $0406  ; A/X = tekst
k_readline = $0409  ; A/X = bufor -> Y = długość
k_open     = $040C  ; A/X = nazwa -> A = fd, C=1 błąd (A = kod)
k_read     = $040F  ; A = fd, bp = bufor, Y = max (0=255) -> A = ile, 0 = EOF
k_close    = $0412
k_readdir  = $0415
k_creat    = $041B  ; A/X = nazwa, Y = tryb 0 nowy / 1 zastąp / 2 dopisz
k_wr       = $041E  ; bp = dane, Y = ile
k_wclose   = $0421
k_unlink   = $0424
k_putdec   = $0427  ; A/X = liczba
k_seek     = $042A  ; A = fd, X/Y = pozycja
k_strerror = $042D  ; A = kod -> A/X = tekst
k_eputs    = $0430  ; A/X = tekst na konsolę (stderr)
k_yield    = $0433  ; oddaj procesor
k_exit     = $0436  ; A = kod wyjścia
bp         = $84
