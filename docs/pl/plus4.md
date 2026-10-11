# Port Commodore Plus/4

- Sprzęt: 7501 (NMOS), TED 7360/8360, 64 KB RAM. Mapa pracy BIOS: RAM wszędzie (`$FF3F`), I/O i TED `$FD00-$FF3F`, KERNAL/BASIC nieużywane.
- Pamięć: `$0200-$03FF` zmienne BIOS i czytnik cartridge, `$0800-$0FFF` ekran TED (atrybuty `$0800`, znaki `$0C00`), jądro od `$1000` (KBASE),
  dane jądra DB=`$2C00`, sloty programów `$4000/$7000/$A000`, nakładka zapisów `$D000-$E6FF`, BIOS + sterownik napędu `$E700-$F8xx`.
- Konsola: tekst 40x25, zestaw małe/duże litery z ROM znaków (`$FF13=$D4`), atrybut `$71` (biały), kursor = odwrócony znak; kursor sprzętowy TED odsunięty poza ekran (`$FF0C/$FF0D` = 1023).
- Klawiatura: wybór wiersza zapisem do `$FD30` (0 = aktywny), zatrzask `$FF08=$FF`, odczyt kolumn z `$FF08` (0 = wciśnięty). Macierz z VICE (`gtk3_pos.vkm`):
  Shift (1,7), CTRL (7,2), C= (7,5). `|` = Shift+`-`, `_ { } ~` = C= + `@ W Q =`, RUN/STOP = ^C.
- Timer: TED timer 1, odliczanie z 886724 Hz (PAL), przeładowanie 8867 -> 100 Hz; IRQ przez flagę `$FF09` bit 3 (kasowanie zapisem 1), maska `$FF0A=$08`.
- Czas: TED nie ma TOD ani RTC, więc `TickAck` liczy zegar programowy (start 09:00:00, data stała 2026-10-11).
- Cartridge CART-1 (`-cart`, 32 KB = c1lo + c1hi): KERNAL po resecie (procedura POLL, `$FC1E`) wybiera kolejno ROM-y (`$FDD0+n`, n = 15, 10, 5, 0), sprawdza `CBM` pod `$8007` i bajt `1` pod `$8006`,
  po czym robi `JSR $8000` jeszcze przed inicjalizacją. Boot kopiuje BIOS do RAM, trampolina w `$0334` przełącza na RAM (`$FF3F`) i skacze do `Reset`.
- Dysk w ROM: 104 bloki = 44 w c1lo (`$9400-$BFFF`) + 60 w c1hi (`$C000-$FBFF`); strona źródła = numer bloku + `$94`. Wybór banku zapisem pod `$FDD0+n`
  (n=2 niski CART-1, n=8 wysoki CART-1), potem `$FF3E` (ROM widoczny). Czytnik działa w RAM (`$0340`) z maskowanymi przerwaniami.
- Zapisy: nakładka 23 bloków w RAM (`$D000-$E6FF`, tablica numerów w `$03A1`); odczyt sprawdza nakładkę przed ROM. Pełna nakładka -> błąd 5. Znika przy resecie.
- Test: VICE xplus4 z oryginalnymi ROM-ami (`PLUS4_ROMS`: `kernal.bin` 318004-05, `basic.bin` 318006-01, `3plus1.bin` 32 KB lub `functionlo/hi.bin`).
- Do potwierdzenia: sprzęt (tylko VICE), NTSC (`TICK_DIV` 8949), nakładka nietrwała, brak IEC/1551, C16/C116 (16 KB RAM) nieobsługiwane.

## Napęd 1551 (TCBM)
Patrz [drives.md](../en/drives.md). Obraz BIOS w c1lo ma 5 KB (dysk ROM: 104 bloki od `$9400`, c1lo 44 bloki + c1hi 60), BIOS biegnie od `$E700`; napęd 8 z dyskiem MiniUnix ma pierwszeństwo przed dyskiem ROM.

### Note: character ROM and cartridge banks

TED fetches glyphs from `$D400` of the *high ROM bank*. If the cartridge's c1hi bank stays selected (`ROM_BANK` n=8), the
glyphs come from disk data and the screen is garbled. The BIOS therefore selects the internal ROMs (`sta ROM_BANK`) at reset
and after every ROM-disk block read.
