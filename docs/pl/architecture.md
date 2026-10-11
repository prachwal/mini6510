# 01 - Architektura (6502)

## Magistrala
- Jedna magistrala adresowa (16 bit) i jedna danych (8 bit).
- CPU nie rozróżnia RAM, ROM i urządzeń: każdy dostęp to odczyt lub zapis pod adres.

## Urządzenia I/O
- Model: memory-mapped I/O. Każde urządzenie ma zakres adresów, a jego rejestry są dostępne jak pamięć.
- Przykład: układ wyjściowy pod `$D000`. `STA $D000` wysyła bajt, `LDA $D001` odczytuje status.
- DMA: sam 6502 go nie ma. Możliwe tylko przez zewnętrzny kontroler DMA, który przejmuje magistralę.

## Dekodowanie adresów
- Dekoder adresów wybiera komponent, gdy adres mieści się w jego zakresie (chip select).
- Dalsze bity adresu wybierają rejestr lub bajt wewnątrz komponentu.
- Sprzętowo: górne bity adresu (np. A15–A13) trafiają do bramek lub dekodera (np. 74138). Wyjście CS jest aktywne, gdy wzór pasuje.
- W emulatorze: lista zakresów (`base`, `size`, komponent). Dla dostępu szukany jest pasujący zakres, a komponentowi przekazywany jest offset. Nakładające się zakresy trzeba zakazać lub ustalić priorytet.
- Szczegóły przykładów: `04-pamiec.md`.

## Mapowanie w emulatorze (propozycja)
- Magistrala trzyma tabelę: zakres adresów → komponent.
- Każdy komponent (RAM, ROM, urządzenie) implementuje wspólny interfejs odczytu i zapisu.
- CPU korzysta tylko z magistrali, nie zna konkretnych komponentów.

## Realizacja DMA i dźwięku (NES, propozycja)
- OAM DMA (`$4014`): kopiowanie 256 bajtów od razu w zapisie, plus 513/514 cykli CPU. Wersja dokładna rozkłada kopiowanie na cykle.
- DMC DMA: kradzież 1–4 cykli CPU przy odczycie próbki.
- APU: zegar co drugi cykl CPU, frame counter ok. 240 Hz lub 120 Hz, miksowanie nieliniowe, resampling do 44,1/48 kHz.
- Bufor kołowy; synchronizacja tempa CPU z odtwarzaniem audio.

## Zegar i synchronizacja (propozycja)
- Każdy krok CPU zwraca liczbę cykli. Pozostałe komponenty są taktowane ze stałym stosunkiem (NES: PPU 3x, APU 1x na cykl CPU).
- Tempo rzeczywiste: `Stopwatch.GetTimestamp()` z akumulatorem zamiast `Thread.Sleep`.
- Najlepsza synchronizacja: sterowanie przez poziom bufora audio.
- W pętli bez alokacji, `Step()` zwraca `int`.

## Framebuffer (propozycja)
- PPU zapisuje indeksy palety (`byte`, NES 0–63). Konwersja na ARGB przez tablicę `uint[64]`.
- Bufor stały, alokowany raz; podwójne buforowanie przez zamianę referencji.
- Wysyłanie na ekran raz na klatkę, z uwzględnieniem `stride`.
- Rendering po liniach, bez wywołań na piksel.

## Wyświetlanie w UI (propozycja)
- WPF: `WriteableBitmap` (Bgra32), `Lock`/`Buffer.MemoryCopy`/`AddDirtyRect`/`Unlock`, `Image` z `NearestNeighbor`, odświeżanie przez `CompositionTarget.Rendering`.
- Avalonia: `WriteableBitmap.Lock()` zwraca `ILockedFramebuffer` (`Address`, `RowBytes`), `Image` z `BitmapInterpolationMode="None"`, `InvalidateVisual()`. Dla shaderów: `OpenGlControlBase`.
- Emulacja w osobnym wątku, UI tylko kopiuje i odświeża.

## Sprite'y NES (propozycja)
- OAM: 64 sprite'y po 4 bajty: Y (pozycja minus 1), tile, atrybuty (paleta 0–1, bit 5 priorytet, bit 6 H-flip, bit 7 V-flip), X.
- Rozmiar 8×8 lub 8×16 (PPUCTRL), w 8×16 bit 0 tile wybiera tablicę wzorów.
- Ewaluacja na początku linii, limit 8 sprite'ów na linię (flaga przepełnienia).
- Kolor 0 jest przezroczysty. Mieszanie z tłem według priorytetu.
- Sprite 0 hit do synchronizacji przewijania.

## Sprite'y w Commodore (VIC-II, C64)
- 8 sprite'ów sprzętowych, 24×21 piksel, 63 bajty danych (blok 64 B).
- Wskaźnik w pamięci ekranu (domyślnie `$07F8–$07FF`), adres = wskaźnik × 64 w banku VIC.
- Tryby: hi-res (2 kolory) lub multicolor (4 kolory, piksele szersze).
- Rejestry: `$D000–$D00F` pozycje (bit 9 X w `$D010`), `$D015` enable, `$D017`/`$D01D` powiększenie, `$D01B` priorytet, `$D01C` multicolor, `$D027–$D02E` kolory, `$D01E`/`$D01F` kolizje (czyszczone przy odczycie).
- VIC widzi 16 KB wybrane przez CIA2 (`$DD00`).
- Plus/4 (TED): brak sprzętowych sprite'ów. C128 w trybie 80 kolumn: VDC, bez sprite'ów.

## Specjalizowane układy Commodore (z pamięci, do weryfikacji)
- VIC-II (6567/6569): wideo, 8 sprite'ów. C64, C128.
- VIC-I (6561): wideo. VIC-20.
- TED (7360/8360): wideo, dźwięk, timery, klawiatura. Plus/4, C16, C116.
- SID (6581/8580): dźwięk, 3 głosy, filtry. C64, C128.
- CIA 6526 (×2): timery, I/O, klawiatura, przerwania. C64, C128.
- VIA 6522 (×2): I/O, timery. VIC-20, PET, dysk 1541.
- PIA 6520: I/O. PET.
- CRTC 6545: kontroler wideo. PET.
- VDC 8563/8568: wideo 80 kolumn. C128.
- MMU 8722: banki pamięci. C128.
- PLA 82S100: dekodowanie adresów. C64.
- Każdy układ to osobny komponent na magistrali z własnym zakresem adresów.

## Referencje (sprawdzone lokalnie, shallow clone w /home/claude/<owner>/<repo>)
Repozytoria 6502/NES w C#:
- barryw/e6502 (https://github.com/barryw/e6502): pełna platforma 6502 z RealTimeCycleScheduler (Stopwatch), CPU.cs z NMOS/CMOS i liczeniem cykli (ClocksForNext), OpCodeTable.cs, BusDevice.cs, IBusDevice.cs, VirtualDmaController.cs, SidChip.cs, Rendering/SpriteRenderer.cs, testy w e6502UnitTests.
- DualBrain/EMU6502 (https://github.com/DualBrain/EMU6502): mały interpreter 6502 w MOS6502.cs, zdarzenie Cycle wywoływane co cykl, pełne BCD, emulacja błędów z symbolem BUG, RAM64K.cs.
- Xyene/Emulator.NES (https://github.com/Xyene/Emulator.NES): pełny NES w dotNES/. CPU.Core.cs (ExecuteSingleInstruction, Cycle), CPU.IORegisters.cs (case 0x4014: OAM DMA), PPU.Memory.cs (PerformDMA), Addressable.cs (mapa odczytu delegatami), mappery (MMC1, MMC3 itd.).
- RupertAvery/Fami (https://github.com/RupertAvery/Fami): NES w Fami.Core/. CPU/CpuExecution.cs (PPU co 3 cykle, odliczanie cykli instrukcji), Bizhawk/APU.cs (DMC DMA z licznikiem dmc_dma_countdown), Audio/ (Oscillator, Sweeper, Envelope, BlipBuffer), Video/Ppu.cs, SpriteScanline.cs, LoopyRegister.cs.
- McNeight/6502Net i farell/6502net: symulator 6502 w WPF z testami funkcjonalnymi (Processor/Processor.cs, Processor.UnitTests/FunctionalProcessorTests.cs).
- plnelson/nes: tylko kod UWP, niewiele do wykorzystania.

Uwagi: nie sprawdzałem licencji ani pełnej poprawności. Pierwsze w kolejności do czytania: DualBrain (mały, czytelny CPU) oraz Fami (APU, PPU, DMA).

## Terminal tekstowy przez UART (propozycja)
- Klawiatura i ekran po stronie PC (terminal VT100/ANSI).
- UART 6850 (ACIA), np. `$DF00` status/control, `$DF01` dane.
- Status: bit 0 RDRF (dane do odczytu), bit 1 TDRE (można wysłać).
- Ustawienia 9600 lub 19200 bodów, 8N1.
- Polling: getchar czeka na RDRF, putchar czeka na TDRE. IRQ opcjonalnie.
- Emulator: kolejka wejściowa (klawisze hosta), wyjście do `Console.Out`.

## Stacja dysków zgodna z CP/M (propozycja)
- Kontroler FDC: WD1793/1770, Intel 8272 lub NEC µPD765.
- Rejestry: komenda/status, track, sector, data. Sterowanie: drive select, silnik, side. Przerwanie lub flaga końca.
- BIOS: SELDSK, SETTRK, SETSEC, SETDMA, READ, WRITE. Układ sektorów z Disk Parameter Block (DPB).
- Emulator: komponent na magistrali, dane z pliku `.img` (sektory po kolei). Bez modelowania fizycznych obrotów.
- Własny OS: własny format i API dysku, bez DPB.

## Boot z dysku (propozycja)
- ROM (wektor RESET) inicjalizuje UART, FDC i pamięć.
- RESTORE na ścieżkę 0, READ sektora 1 do ustalonego adresu w RAM (np. `$0800`), skok pod ten adres.
- ROM zwykle 1–2 KB, więc loader jest krótki. Jeśli system jest większy, pierwszy sektor ładuje resztę (pętla po sektorach).
- Emulator: pierwszy sektor `.img` to dane do załadowania, odczytywane przez komponent FDC.

## EEPROM z ustawieniami (propozycja)
- Przechowuje ustawienia BIOS: domyślny napęd, prędkość UART, rozmiar RAM, datę.
- Układy: 24C02 (I2C, 256 B, bit-banging przez PIA), 93C46 (Microwire, 128×16 bit), X2212 (NVSRAM z podtrzymaniem).
- Zapis wolny (ms na bajt albo stronę), ograniczona liczba zapisów. Zapis tylko przy zmianie.
- Suma kontrolna. Po błędzie ustawienia domyślne. Ochrona przed zapisem podczas startu.
- Emulator: komponent z zapisem do pliku (np. `settings.bin`) przy zmianie. Czas zapisu opcjonalny.

## Shadow ROM (propozycja)
- BIOS w ROM/EPROM/Flash jest kopiowany do RAM przy starcie. Przełącznik (np. rejestr I/O) odłącza ROM, a RAM przejmuje ten zakres.
- Korzyści: szybszy kod, możliwość patchowania. Koszt: czas kopiowania, zajęty RAM.
- EEPROM z ustawieniami nie nadaje się do wykonywania kodu (za mała, za wolna).
- Emulator: kopia ROM w tablicy RAM, rejestr przełącznika zmienia mapowanie zakresu.
- Kopiowanie robi CPU w pętli. PIA 6520 nie kopiuje pamięci, tylko daje bit przełącznika mapowania (jak bity `$0001` w C64).
- Kopiowanie bez CPU wymaga kontrolera DMA (np. Intel 8237) z arbitrażem magistrali. Na start niepotrzebne.

## Minimalny bootloader (przykład, ca65)
- UART 6850: reset `$03`, konfiguracja 8N1 `/64` = `$15`. TDRE = bit 1 statusu.
- Komunikat i halt, wektory NMI/RESET/IRQ w `$FFFA–$FFFF`.
- Rozmiar: ok. 90–100 B kodu i komunikatu + 6 B wektorów. Shadow ROM dodaje kilkanaście B.
- Kość 2 KB wystarczy z zapasem. Przy pełnym loaderze z dysku (FDC) rozmiar rośnie.

## Lista układów (BOM, propozycja)
- CPU: 6502 (albo 6510/8502). Zegar: kwarc 2 MHz z podziałem na φ1/φ2, albo 1 MHz.
- Reset: RC + bramka Schmitt (74HC14).
- ROM: 2716/27C16 albo 28C64. RAM: 62256 (32 KB), dla 128 KB dwa układy lub bank switching.
- Dekoder: 74HC138. Rejestr banków: 74HC373/574.
- UART: 6850 (ACIA). Poziomy RS-232: MAX232/MAX3232. Złącze DE-9.
- Opcjonalnie: PIA 6520 (shadow ROM, I2C), EEPROM 24C02 (ustawienia), FDC WD1793/8272 + złącze napędu.
- Zasilanie: 7805, kondensatory. Logika: 74HC00, 74HC02, 74HC32. Pull-up dla IRQ/NMI/RDY.
- Z80 zamiast 6502 (CP/M): zmienia się zegar, wektory i dekoder.

## Loader z FDC (przykład, ca65)
- Wypisuje `LOADING SYSTEM` przez UART, włącza napęd 0 i silnik (`$DF18`), czeka na rozpędzenie.
- RESTORE (`$00`), sprawdzenie TR00 (bit 2). Sektor 1 odczytywany komendą `$80` pętlą DRQ do `$0800`.
- Błędy: LOST (bit 2), CRC (bit 3), RNF (bit 4). Przy błędzie `DISK ERROR` i halt. Sukces: skok do `$0800`.
- Rejestry FDC: `$DF10` cmd/status, `$DF11` track, `$DF12` sector, `$DF13` data. Opóźnienia zależą od taktowania.

## Build i uruchomienie (propozycja)
- ROM: `ca65 boot.s -o boot.o`, `ld65 -C rom.cfg boot.o -o boot.bin` (MEMORY ROM: start `$F800`, size `$0800`). Wynik 2048 B.
- Program na dysku: `ca65 sys.s -o sys.o`, `ld65 -C sys.cfg` z `.org $0800`, potem `dd ... bs=256 count=1` do `disk.img` (track 0, sektor 1).
- Emulator: `boot.bin` pod `$F800`, `disk.img` jako napęd 0, RESET.
- Sprzęt: wypal `boot.bin` w EPROM/EEPROM, obraz dysku na nośnik, włącz zasilanie.

## POST (sprawdzenie przy starcie, propozycja)
- Kolejność: CPU (NMOS/CMOS), RAM (wzorce $55/$AA w $0200–$7FFF), UART (status po resecie), FDC (FORCE INTERRUPT, `$FF` = brak układu), potem tabela wyników.
- Wejście do SETUP: ok. 2 s na klawisz `s` (RDRF). Setup to podprogram w tej samej kości BIOS.
- Kod: `bios-post.s` (ca65). Test RAM niszczy `$0200–$7FFF`, więc zmienne BIOS w ZP lub stosie.
- Do dopracowania: ROM checksum, sprawdzenie EEPROM, rozmiar RAM z testu, menu SETUP.

## RTC (propozycja)
- DS1307 (I2C, `$68`, 32,768 kHz, bateria). Na tej samej magistrali co EEPROM 24C02 (`$50`).
- Alternatywy: DS1302 (3-wire), MC146818 (równoległy, więcej linii).
- I2C programowo na PIA: PA0 = SCL, PA1 = SDA, linie open-drain (DDR=1 ciągnie do 0, DDR=0 zwalnia). Rezystory podciągające 4,7 kΩ.
- Odczyt czasu: pointer `$00`, repeated start, 7 bajtów BCD. Bit 7 sekund to CH (zatrzymany oscylator).
- Kod: `rtc.s` (ca65). Opóźnienia I2C dopasuj do zegara (min. ok. 4,7 µs).
- Emulator: model DS1307 z zegarem hosta albo czasem symulowanym, I2C jako stan.

## Kontroler I2C z rejestrami (propozycja)
- Baza `$DF20`: CTRL (zapis: bit0 START, bit1 STOP, bit2 WRITE, bit3 READ, bit4 NACK), DATA (bajt do wysłania / ostatnio odebrany), STATUS (bit0 BUSY, bit1 NACK).
- Kontroler sam odmierza bity i ACK. CPU tylko wpisuje dane i czeka na BUSY=0. BIOS bez pętli opóźniających.
- Emulator: komponent z maszyną stanów; na szynie modele DS1307 i 24C02 (wskaźnik rejestru, ACK). Czasy bitów można pominąć.
- Gotowy odpowiednik: Philips PCF8584 (przestarzały, ale zaprojektowany pod 8-bit).
- Bit-banging z `rtc.s` zostaje jako fallback, gdy nie ma kontrolera.

## API I2C w BIOS (propozycja)
- Tabela skoków na początku BIOS: `I2C_READ` = `$F800`, `I2C_WRITE` = `$F803`. Stały adres dla programów.
- `I2C_READ`: A = adres 7-bit, X = rejestr → A = wartość, C=1 błąd. `I2C_WRITE`: A = adres, X = rejestr, Y = wartość, C=1 błąd.
- Sekwencja START/ACK/STOP w BIOS, na kontrolerze z `$DF20`. Program używa `bios.inc` z adresami i konwencją.
- Zajęte zmienne ZP: `$F9`–`$FB`.

## Komponenty z Arduino (zakres)
- Bezpośrednio przez API: I2C (znany adres i rejestry), UART (moduły GPS, BT, sterowniki tekstowe).
- Wymaga dodatkowej logiki: SPI (kontroler lub bit-banging), analogowe czujniki (ADC), timing (1-Wire, DHT22, WS2812, HC-SR04).
- Nie działa: USB, biblioteki Arduino C++ (trzeba przepisać).
- Rozwiązanie: mikrokontroler-most (Arduino). Obsługuje protokoły, 6502 wysyła polecenia przez UART albo wspólny rejestr.
- Napięcia: 5 V vs 3,3 V, sprawdzić przy każdym module.

## Schemat obecnej architektury (stan na 2026-10-11)
- CPU 6502 (reset, IRQ, NMI) → magistrala 16 bit adresów + 8 bit danych.
- Pod magistralą: ROM 2 KB (`$F800`, start), RAM 32 KB (`$0000–$7FFF`), dekoder 74HC138.
- Dekoder wybiera: UART 6850 (`$DF00–$DF01`), FDC WD1793 (`$DF10–$DF13`), kontroler I2C (`$DF20–$DF22`).
- Na I2C: EEPROM 24C02 (`$50`, ustawienia BIOS) i RTC DS1307 (`$68`, czas).
- Nie na schemacie, do dodania: PIA 6520 (`$DE00`, shadow ROM, opcjonalnie I2C), mapa ROM/RAM w `04-pamiec.md`.

## Sekwencja startu (stan na 2026-10-11)
1. Reset: CPU 6510 czyta wektor z `$FFFC`. Zatrzask shadow = 0, odczyt z ROM. Port `$0000–$0001` po resecie (DDR = 0).
2. ShadowInit: kopia `$F800–$FFFF` ROM → RAM (ten sam adres), zatrzask = 1, odczyt z RAM.
3. Inicjalizacja: UART (`$03`, `$15`), RtcInit (uruchomienie oscylatora, jeśli CH = 1).
4. POST: CPU, RAM (bez `$F800–$FFFF` i I/O), UART, FDC, tabela wyników.
5. Okno SETUP ok. 2 s (klawisz `s`), opcjonalnie `SetupMenu` z EEPROM.
6. LoadSystem: napęd 0, RESTORE, sektor 1 do `$0800`, błędy LOST/CRC/RNF → `DISK ERROR`.
7. Skok do `$0800`.

## Sekwencja startu z testem RAM (2026-10-11)
1. Reset, zatrzask 0, wektor z ROM.
2. ShadowInit: kopia `$F800–$FFFF` ROM → RAM, zatrzask 1.
3. Test niskiego RAM (`$0200–$DDFF`, `$E000–$F7FF`) z kodu w RAM.
4. RelocAndTest: kopia `RELOC` do `$0200`, TestHiRam testuje `$F800–$FFFF` i przywraca z ROM.
5. Reszta POST, tabela wyników.
6. Okno SETUP (2 s).
7. LoadSystem, sprawdzenie zakresu, skok przez `jmp (entry)`.
- Rozmiary (szacunek): test ok. 180 B, cały BIOS ok. 900–1000 B. Potwierdzić listingiem `ca65 -l`.
- Nietestowane: `$0100–$01FF` (stos) i `$00–$01` (port 6510).

## Do potwierdzenia
- [ ] Czy magistrala ma obsługiwać DMA (symulowany osobny komponent) na późniejszym etapie?
- [ ] Czy urządzenia mają wspólny interfejs `Read(ushort)` / `Write(ushort, byte)`?
