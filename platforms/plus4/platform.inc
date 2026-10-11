; platform.inc - Commodore Plus/4 (TED, 64 KB RAM): parametry widoczne dla jądra i programów
; Mapa (RAM wszędzie, $FF3F; I/O i TED $FD00-$FF3F):
;   $0200-$03FF BIOS (zmienne, czytnik cartridge), $0800-$0FFF ekran TED (atrybuty $0800, znaki $0C00),
;   $1000-$2Cxx jądro, DB.. dane jądra, $4000/$7000/$A000 sloty programów (12 KB), BIOS $E800-$F8xx w RAM.
KBASE        = $1000    ; jądro ładowane nad ekranem TED
DB           = $2C00    ; dane jądra: $2C00-$3FFF (BLKBUF $3200, zadania $3400, potoki $3C00)
SLOT_END_HI  = $D0      ; sloty programów kończą się przed $D000
DISK_BLOCKS  = 108      ; obraz dysku w ROM cartridge (zapisy: nakładka 24 bloków w RAM $D000-$E7FF): 48 bloków w c1lo ($9000-$BFFF) + 60 bloków w c1hi ($C000-$FBFF)
