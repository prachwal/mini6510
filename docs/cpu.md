# 02 - Procesor (6502)

## Rejestry
- A: akumulator, 8 bit
- X, Y: rejestry indeksowe, 8 bit
- S: wskaźnik stosu, 8 bit. Stos znajduje się na stronie $01 (adresy $0100-$01FF)
- PC: licznik rozkazów, 16 bit
- P: rejestr stanu (flagi)

## Flagi (P)
- N: negative (bit 7 wyniku)
- V: overflow
- B: break (ustawiany tylko na stosie przez BRK/PHP)
- D: decimal mode (w NMOS 6502 nie jest zmieniana przy resecie)
- I: interrupt disable (blokada IRQ)
- Z: zero
- C: carry

## Sekwencja resetu (RES)
1. Linia RES trzymana nisko przez kilka cykli, potem zwolniona.
2. 7 cykli resetu: 2 cykle odczytu, 3 "martwe" odczyty stosu (S maleje o 3, zapisy wstrzymane), 2 odczyty wektora resetu.
3. PC ładowany z $FFFC (młodszy bajt) i $FFFD (starszy bajt).
4. Ustawiana flaga I.
5. Rozkaz pobierany spod nowego PC.

Rejestry A, X, Y oraz początkowa wartość S nie mają ustalonej wartości po włączeniu. Program musi je zainicjalizować.

## Wariant 6510 (port I/O)
- `$0000` DDR: bit = 1 wyjście, bit = 0 wejście.
- `$0001` port: dane portu.
- W C64: bity 0–2 sterują mapowaniem ROM/RAM (LORAM, HIRAM, CHAREN), bit 3 to wyjście magnetofonu, bit 4 to wejście PLAY, bit 5 to silnik. Bity 6–7 nie są podłączone.
- Zapis do `$0001` zmienia mapowanie przestrzeni adresowej, więc emulator musi to uwzględnić w dekoderze.

## Warianty 6502 (z pamięci, do weryfikacji w datasheet)
- 6502 (MOS, NMOS, 16 bit): błąd JMP (indirect) na `$xxFF`, niedokumentowane rozkazy, błędne N/V/Z w BCD.
- 6502A/B/C (NMOS, 16 bit): szybsze wersje (typowo 2 i 3 MHz).
- 6503/6504/6505/6507 (NMOS, 13 bit, 8 KB, 28-pin): 6507 w Atari 2600.
- 6509 (NMOS, 20 bit): wewnętrzny rejestr banku.
- 6510 (NMOS, 16 bit): port I/O `$0000`/`$0001`, C64.
- 65C02 (CMOS, 16 bit): nowe rozkazy, poprawiony JMP, brak niedokumentowanych rozkazów NMOS, BRK zeruje D, poprawne BCD.
- 65816 (CMOS, 24 bit): tryb natywny 16-bit, tryb emulacji 6502, SNES.
- Dla emulatora kluczowe: NMOS vs CMOS (BCD, JMP, undocumented) oraz szerokość szyny adresowej.

## Wariant NES (Ricoh 2A03 / 2A07)
- Rdzeń 6502 bez trybu BCD (flaga D nie działa).
- Wbudowane APU (2 pulsy, trójkąt, szum, DMC).
- Wbudowany DMA: zapis do `$4014` kopiuje 256 bajtów do OAM, CPU wstrzymane ok. 513–514 cykli.
- Porty kontrolerów `$4016`/`$4017`.
- Zegar: ok. 1,79 MHz (NTSC), ok. 1,66 MHz (PAL). 2A07 to wersja PAL.

## Warianty C116 / Plus/4 / C128 (z pamięci, do weryfikacji)
- C116: 7501/8501, ok. 1,77 MHz, port I/O podobny do 6510, 16 KB RAM (tańsza wersja Plus/4).
- Plus/4: 7501/8501, ok. 1,77 MHz, port I/O podobny do 6510, układ TED (wideo, dźwięk, timery).
- C128: 8502, 1 lub 2 MHz, port I/O jak w 6510, Z80 w trybie CP/M, bank switching przez MMU 8722.
- Dla emulatora: 8502 w trybie 2 MHz oraz MMU sterujący mapą pamięci w C128.

## Różnice 8501 vs 8502 (z pamięci, do weryfikacji)
- 8501: CMOS, ok. 1,77 MHz, port I/O podobny do 6510, Plus/4 i C116 (późniejsze wersje).
- 8502: CMOS, 1 lub 2 MHz, port I/O jak w 6510, C128.
- Rozkazy zgodne z 6502. Różni się zegar i mapowanie pamięci, więc rdzeń CPU może być wspólny.

## Do potwierdzenia
- [ ] Czy emulator modeluje dokładnie 7 cykli resetu i "martwe" odczyty stosu (czy wystarczy ustawienie PC i I)?
- [ ] Wartości początkowe A, X, Y, S: 0 czy wartość losowa?
- [ ] Wariant NMOS (klasyczny 6502) czy CMOS (65C02)? Wpływa na tryb dziesiętny i kilka rozkazów.
