; platform.inc - Commodore 64: parametry widoczne dla jądra i programów
; Mapa (po wyłączeniu ROM: $01 = $35): RAM wszędzie poza I/O $D000-$DFFF.
;   $0200-$03FF BIOS (zmienne), $0400-$07E7 ekran, $0810-$24xx jądro, DB.. dane jądra,
;   $4000/$7000/$A000 sloty programów (12 KB), BIOS $F800-$FFFF w RAM.
KBASE        = $0810    ; jądro ładowane tuż za stubem BASIC ($0801-$080F)
DB           = $2400    ; dane jądra: $2400-$37FF (BLKBUF $2A00, zadania $2C00, potoki $3400)
SLOT_END_HI  = $D0      ; sloty programów kończą się przed I/O ($A000+$3000 = $D000)
IEC = 1
