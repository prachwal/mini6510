# 04 - Pamięć (6502)

## Przestrzeń adresowa
- 16 bit: 64 KB ($0000-$FFFF)
- Porządek bajtów: little-endian (najpierw młodszy bajt)

## Ważne obszary
- $0000-$00FF: strona zerowa (szybki dostęp, adresowanie zerowo-stronicowe)
- $0100-$01FF: stos (strona $01, wskaźnik S)
- $FFFA-$FFFF: wektory przerwań

## Wektory przerwań
| Adres | Nazwa | Opis |
|-------|-------|------|
| $FFFA / $FFFB | NMI | przerwanie niemaskowalne |
| $FFFC / $FFFD | RESET | adres startowy po resecie |
| $FFFE / $FFFF | IRQ/BRK | przerwanie maskowalne i BRK |

Wektory nie są zapisywane przez CPU. Są częścią ROM i ustawiane przez program lub narzędzie kompilacji. CPU tylko je odczytuje.

## Wariant 6510 (zamiast 6502)
- `$0000` (DDR) i `$0001` (dane portu) nie są RAM. Zmienne BIOS, loader i stos nie mogą tam leżeć.
- Port ma 6 linii (P0–P5), bity 6–7 niepodłączone.
- Po resecie DDR = 0 (wejścia z podciągnięciem). Shadow zostaje na zewnętrznym zatrzasku 74HC273.

## Mapa pamięci 6502 z 64 KB RAM i shadow (propozycja)
- `$0000–$D7FF`: RAM. `$D800–$DFFF`: I/O (UART `$DF00`, FDC `$DF10`, I2C `$DF20`, latch shadow `$DE00`). I/O ma pierwszeństwo przed RAM.
- `$E000–$F7FF`: RAM.
- `$F800–$FFFF`: ROM przy starcie (latch = 0), po shadow RAM (latch = 1). Wektory włącznie.
- Zapis zawsze trafia do RAM (WE). Odczyt `$F800–$FFFF` z ROM, gdy ROM ON.
- RAM: 2× 62256, wybór przez A15. Zatrzask 74HC273, reset = 0 (ROM ON).

## Mapa pamięci NES (CPU)
- `$0000–$07FF`: 2 KB RAM, lustrzane do `$1FFF`
- `$2000–$2007`: rejestry PPU, lustrzane do `$3FFF`
- `$4000–$4017`: APU i I/O (DMA w `$4014`, kontrolery w `$4016`/`$4017`)
- `$4018–$401F`: test (zwykle nieużywane)
- `$4020–$FFFF`: cartridge (PRG-ROM/RAM, mapper)
- `$FFFA–$FFFF`: wektory NMI, RESET, IRQ, w cartridge

## Dekodowanie adresów
- Każdy komponent ma bazę i rozmiar. Wybór (chip select) następuje, gdy adres mieści się w zakresie.
- Przykład RAM 32 KB pod `$0000`: wybór, gdy A15 = 0, a A0–A14 wybierają bajt.
- Przykład urządzenia z 16 rejestrami pod `$D000`: wybór w zakresie `$D000–$D00F`, A0–A3 wybierają rejestr.
- Emulator: magistrala szuka komponentu z `base ≤ addr < base + size` i przekazuje offset `addr - base`.
- Gdy żaden układ nie jest wybrany: odczyt zwraca open bus (ostatnia wartość magistrali lub `$FF`), zapis jest ignorowany.
- Częściowe dekodowanie (pominięte bity adresu) tworzy lustrzane odbicia tego samego RAM pod kilkoma adresami. Do potwierdzenia, czy emulator to modeluje.

## Mapowanie (proponowane, do potwierdzenia)
- Domyślnie: ROM obejmuje koniec przestrzeni adresowej (w tym $FFFA-$FFFF), RAM zaczyna się od $0000.
- Przykład: ROM 32 KB pod $8000-$FFFF, wektory to ostatnie 6 bajtów pliku.

## Do potwierdzenia
- [ ] Rozmiar i układ ROM/RAM (domyślnie: RAM $0000-$7FFF, ROM $8000-$FFFF).
- [ ] Czy emulator ma obsługiwać I/O mapowane w pamięci (np. $6000-$7FFF)?
- [ ] Czy zapis do ROM ma być ignorowany (domyślnie tak)?
