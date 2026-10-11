# 00 - Przegląd

## Zakres tych notatek (2026-10-11)
- Procesor jest poza zakresem tych notatek (użytkownik ma go osobno).
- Notatki dotyczą maszyny wokół CPU: magistrala, pamięć (64 KB RAM, shadow ROM), urządzenia mapowane w pamięci (UART, FDC, I2C, RTC), BIOS i boot.
- Cel: zbudować BIOS i OS dla wiernego emulatora (konwencja zadania). Notatki opisują tylko granicę komunikacji widoczną dla oprogramowania: mapa pamięci, rejestry urządzeń, zachowania wpływające na kod, kontrakt startu i API BIOS. Kontrakt jest w `platforma.md`.
- Poza zakresem: BOM, dekodowanie i bramkowanie w sprzęcie, wnętrze układów, modele czasowe poniżej poziomu rejestrów.
- Zasada: nie zgadywać. Fakty sprzętowe tylko z źródeł pierwotnych (datasheet), z zapisanym URL i decyzją w dokumencie. Uproszczenia opisywać jawnie.

## Istniejące repozytoria użytkownika (przejrzane 2026-10-11, shallow clone)
- `prachwal/emulator-001` (prywatne): rozwiązanie .NET 10 `Proteus`, na razie szkielet CLI (Generic Host, DI, komendy calc/process/help, xUnit, StyleCop). Brak rdzenia CPU. Reguły w `AGENTS.md` (CPM, tylko wolne pakiety, `TreatWarningsAsErrors`).
- `prachwal/cpu-vibe-011` (prywatne): kolekcja emulatorów .NET 10 (Intel 4004..8086, Z80, CHIP-8, CP/M, IBM PC 5150). `CpuVibe.Cpu.Abstractions` ma gotowe kontrakty: `ICpu`, `IBus`, `IMemoryBus`, `IPortDevice`, `IBlockDevice`, `IClockable`, `ICycleCounting`, `IMotherboard`, `IComputerSystem`, `OpcodeTable`. Urządzenia jako osobne projekty (np. `Isa.Serial` z UART 8250, `Isa.Fdc`). Brak rdzenia 6502/6510.
- `prachwal/CathodeRay` (publiczne): asembler i kompilator Mini-C w C#, cele: 6502/65C02, Z80, 8080, 6800, stub. Dialekt „MOS/ca65-style", linker z segmentami. Nadaje się do złożenia BIOS bez `ca65`.

## Do zweryfikowania w źródłach pierwotnych (dotąd z pamięci)
- 6503/6505 liczba linii adresowych, VIC-II `$D01E`/`$D01F`, proces 8501/7501, magistrala danych WD179x (prosta/odwrócona), czasy BUSY/DRQ w WD1793, szczegóły DS1307 i 24C02 (ACK polling), taktowanie PPU PAL.

## Wnioski
- Architektura magistrali i urządzeń już istnieje w `cpu-vibe-011`. Warto użyć tych kontraktów, zamiast projektować nowe.
- BIOS można składać własnym asemblerem (`cathode asm --cpu 6502`). Do sprawdzenia, czy kod z naszych plików `.s` (składnia ca65) przejdzie w jego dialekcie.
- Nie znaleziono rdzenia 6502/6510 w tych trzech repozytoriach.

## Otwarte pytania
- [ ] W którym repozytorium jest procesor (6502/6510)?
- [ ] Czy maszyna ma powstać jako nowe projekty w `cpu-vibe-011` (kontrakty `Cpu.Abstractions`), czy w `emulator-001`?
- [ ] Czy BIOS składać `cathode asm`, czy `ca65`?
