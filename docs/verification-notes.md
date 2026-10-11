# Weryfikacja konwersacji i propozycje poprawek (2026-10-11)

Metoda: kod z plików `.s` zasemblowany `ca65` (zbudowany z cc65), fakty sprawdzone w źródłach (Wikipedia 8502 i 6507, datasheet MC6850), reszta przez ponowne przeczytanie kodu i dokumentów.
Znaczniki: [ASM] znalezione przez asembler, [DS] potwierdzone w źródle, [LEKTURA] wynik czytania kodu (nieuruchamiane), [PAMIĘĆ] nie udało się potwierdzić.

## A. Błędy w kodzie (kod nie zadziała lub zadziała źle)

| # | Plik | Problem | Poprawka |
|---|------|---------|----------|
| A1 | system-loader.s | [ASM] Zmienna `sec` ma nazwę rozkazu SEC, asembler zgłasza błąd. | Zmienić nazwę na `secnum` (zmienna, nie rozkaz). Po zmianie plik ma 194 B. |
| A2 | bios-post.s `CheckUart` | [DS] Po zapisie `$03` (master reset) UART jest wciąż w stanie reset, a w tym stanie TDRE jest blokowane. Odczyt statusu zaraz po resecie zwróci FAIL. | Kolejność: `$03`, potem konfiguracja (`$15` lub `$16`), dopiero potem odczyt statusu (oczekiwane TDRE=1, RDRF=0). |
| A3 | rtc.s | [LEKTURA] `I2cDelay` (`ldx #4`) i `SdaRead` (`ldx #0`) niszczą X, a `I2cWrite`/`I2cRead` używają X jako licznika 8 bitów. Pętle bitów nie działają. | Opóźnienie na Y (`ldy`/`dey`), w `SdaRead` zastąpić `ldx #0 / stx` przez `lda #0 / sta PIA_CRA`. Albo usunąć plik, jeśli zostaje kontroler I2C (patrz C3). |
| A4 | system-loader.s | [LEKTURA] Sprawdzenie zakresu: porównanie z `$F8` zamiast z dolnym końcem dziury I/O `$D8`. Obraz mógłby pisać po rejestrach `$D800–$DFFF`. Do tego `cmp` nadpisuje carry po `adc`, więc przepełnienie (hi+cnt > 255) nie jest wykrywane. | `adc cnt` / `bcs błąd` (przepełnienie) / `cmp #$D8` / `bcs błąd`. Adres ładowania nie niższy niż `$0200`. |
| A5 | oba loadery, `WaitFdc`, `ReadSectorPtr` | [LEKTURA] Wyścig po wydaniu komendy: BUSY ustawia się z opóźnieniem. Pierwszy odczyt statusu może zobaczyć BUSY=0 i DRQ=0, wtedy pętla kończy się „sukcesem" bez danych. 3 NOP w `WaitFdc` to za mało. | Po komendzie odczekać wymagany w datasheet czas (rząd kilkudziesięciu µs, potwierdzić dla użytego zegara FDC), albo czekać z limitem na BUSY=1, a potem na BUSY=0. |
| A6 | oba loadery, pętla odczytu | [LEKTURA] Pętla ma ok. 26 cykli na bajt. Przy 250 kb/s bajt przychodzi co 32 µs, więc przy 1 MHz zapas jest rzędu 6 µs (ryzyko LOST DATA), przy 2 MHz bezpiecznie. | Ustalić częstotliwość CPU (decyzja) i prędkość dysku. Przy 1 MHz skrócić pętlę lub użyć trybu niższej prędkości. |
| A7 | bios-post.s `WaitForSetup` | [LEKTURA] Komentarz „ok. 2 s", a pętle (20 × 256 × 13 cykli) dają ok. 67 ms przy 1 MHz. | Licznik 16-bitowy (ok. 600 obiegów zewnętrznych dla 2 s przy 1 MHz) albo użyć RTC. |
| A8 | `Delay` (loader) | [LEKTURA] Ok. 0,33 s przy 1 MHz. Może być za krótko na rozpęd silnika. | Sprawdzić w dokumentacji napędu albo czekać na impulsy indeksu. |
| A9 | bios-post.s / shadow.s | Zakres testu RAM niespójny z mapą: `bios-post.s` testuje `$0200–$7FFF` i drukuje „RAM 32KB"; opis w `shadow.s` i w sekwencji startu podaje `$0200–$DDFF`, co wchodzi w I/O (`$D800–$DFFF`). | Zakresy `$0200–$D7FF` i `$E000–$F7FF`, napis „RAM 64KB" liczony z wyniku testu. |
| A10 | wiele plików | [LEKTURA] Stałe (`ptr`, `ptr2`, `tmp`) zdefiniowane osobno w kilku plikach z różnym znaczeniem, nie eksportowane. Linkowanie da błędy nierozwiązanych symboli. | Jeden `bios.inc` z mapą zero page i adresami I/O (już planowany w `bios-api.md`). |
| A11 | API I2C (czat, bez pliku) | Kod nie był zapisany ani zasemblowany. `I2C_WRITE` do 24C02 nie robi ACK polling, a zapis trwa kilka ms, więc kolejne zapisy dostaną NACK. | Zapisać do `i2c-api.s`, dodać pętlę ponawiania adresu z limitem. |
| A12 | `shadow-test.s` | Zastąpiony przez `shadow-reloc.s`, ale nadal leży obok. | Usunąć. (`shadow-reloc.s` asembluje się: blok RELOC 117 B, mniejszy niż 256 B.) |

## B. Błędy faktograficzne

| # | Gdzie | Było | Powinno być |
|---|-------|------|-------------|
| B1 | 02-procesor.md, tabela 8501/8502 | „CMOS" | [DS] 8502 jest w HMOS (NMOS). Dla 8501 źródło nie podaje procesu, więc oznaczyć „HMOS, do weryfikacji". Rdzeń nadal bez zmian CMOS (BCD, JMP). |
| B2 | 02-procesor.md, 8502 | port „jak w 6510" | [DS] port 7-bitowy (6510: 6-bitowy), brak pinu φ2. 2 MHz pełne tylko z VDC (C128), przy VIC ok. 1 MHz. |
| B3 | 01-architektura.md i `bios-post.s`, UART | `$15` = „8N1, /64" | [DS] `$15` = 8N1, **÷16**. ÷64 to `$16`. Baud = zegar/16 (np. 1,8432 MHz daje 115200). |
| B4 | czat, 6503–6507 | „13 bit, 8 KB" dla całej grupy | [DS] potwierdzone tylko dla 6507 (A0–A12, 8 KB). 6503/6505 [PAMIĘĆ]: mniej linii, oznaczyć do weryfikacji. |
| B5 | czat, rejestry VIC-II | „`$D01E`, `$D01F`: sprite–tło i sprite–sprite" | [PAMIĘĆ, pewne] `$D01E` = sprite–sprite, `$D01F` = sprite–tło. |
| B6 | 01-architektura.md, zegar NES | „PPU 3×" | 3× tylko dla NTSC (PAL ok. 3,2×). |
| B7 | czat, DMA w 6502 | „CPU pozwoli", „przejmuje magistralę" | NMOS 6502 nie ma wejścia BE. DMA robi się przez podkradanie cykli φ1, albo linię RDY (wstrzymuje tylko na odczytach). 65C02/65816 (WDC) mają BE. |
| B8 | BOM | „kwarc 2 MHz z podziałem na φ1/φ2" | 6502/6510 generują fazy z wejścia φ0, dzielenie niepotrzebne. Wystarczy oscylator 1–2 MHz. |
| B9 | BOM, FDC | „przetwornik danych" | Poprawna nazwa: data separator (np. WD1691/FDC9216). WD1770/1772 mają go wbudowanego. Magistrala danych 179x/279x bywa prosta lub odwrócona zależnie od wariantu (sprawdzić w datasheet wybranego układu). |
| B10 | repozytoria, 01-architektura.md | „plnelson/nes: niewiele do wykorzystania"; „Fami: PPU co 3 cykle" | Oba sądy oparte na szybkim przeglądzie (3 pliki .cs; wzorzec `% 3`). Oznaczyć „niezweryfikowane". Licencji nie sprawdzono. |

## C. Braki i niespójności projektu

1. **BOM niekompletny:** brak generatora zegara baudów dla 6850 (np. 1,8432 MHz), zwarcia /CTS i /DCD do masy (przy /CTS=1 TDRE jest blokowane, więc `PutChar` zawiesi się w nieskończonej pętli [DS]), zasilania 12 V dla napędu dyskietek, zegara 1/2 MHz dla WD1793, podciągnięć linii I2C.
2. **Logika shadow niezaprojektowana:** trzeba bramkować RAM /OE w `$F800–$FFFF` przy latch=0 (inaczej konflikt na magistrali z ROM), ROM /OE tylko przy odczycie, RAM /CS wyłączone w dziurze I/O, 74HC273 z /MR od /RESET i taktowany zapisem pod `$DE00`.
3. **Kolizja adresów `$DE00`:** zatrzask shadow (`shadow.s`) i PIA 6520 (`rtc.s`, `bios-api.md`). Propozycja: usunąć PIA, I2C tylko przez kontroler `$DF20`, `rtc.s` do archiwum (patrz A3).
4. **Układ ROM niezdefiniowany:** tabela skoków API na `$F800` koliduje z kodem Reset. Potrzebny `rom.cfg`: tabela JMP (7 × 3 B) na `$F800`, kod, wektory `$FFFA`.
5. **Rozmiary:** wcześniejszy szacunek „900–1000 B" jest za niski. Po asemblacji: POST 420 B, RTC bit-bang 373 B, loader 194 B, ShadowInit 29 B, RELOC 117 B + RelocAndTest 22 B, razem ok. 1155 B, plus API I2C i tabela, więc realnie ok. 1,3–1,5 KB. Mieści się w 2 KB, ale bez zapasu na menu SETUP. Decyzja: powiększyć obszar shadow (np. `$E000–$FFFF`, 8 KB).
6. **Dokumenty nieaktualne:** `04-pamiec.md` ma trzy mapy (stara RAM `$0000–$7FFF`/ROM `$8000–$FFFF`, 64 KB z shadow, NES). `decyzje.md` zawiera starą mapę domyślną obok nowej. `01-architektura.md` ma BOM i schemat z RAM 32 KB, dwie sekcje „Sekwencja startu", wspomina PIA. `bios-api.md` opisuje `LoadSystem` ze starym loaderem (sektor 1 → `$0800`), nie z nagłówkiem. `bios-api.md` pozwala programom używać `$00–$EF`, a przy 6510 `$00–$01` to port (powinno być `$02–$EF`).
7. **Status decyzji:** „6510 zamiast 6502" to polecenie użytkownika, a oznaczone jest „do potwierdzenia". Pozostałe pliki `.md` nie są zapisane w projekcie (tylko `bios-api.md`).
8. **Schemat:** nie zawiera zatrzasku shadow ani generatora baudów, pokazuje CPU 6502 i RAM 32 KB. Do przerysowania po poprawkach.

## Proponowana kolejność poprawek
1. Fakty (B1–B10) i status decyzji, szybkie.
2. `bios.inc` (A10) i mapa pamięci jako jedno źródło prawdy.
3. Kod: A1, A2, A4, A5, A7, A9, potem A3/A11 (po decyzji o PIA).
4. Dokumenty (C6), schemat (C8), synchronizacja z projektem (C7).
5. Sprzęt: BOM i logika shadow (C1, C2).
