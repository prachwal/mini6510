# 00 - Overview

## Scope of these notes (2026-10-11)
- The processor is out of scope for these notes (the user has it separately).
- The notes cover the machine around the CPU: bus, memory (64 KB RAM, shadow ROM), memory-mapped devices (UART, FDC, I2C, RTC), BIOS and boot.
- Goal: build a BIOS and OS for a faithful emulator (the task convention). The notes describe only the boundary visible to software: memory map, device registers, behaviors that affect code, the boot contract and the BIOS API. The contract is in `platform.md`.
- Out of scope: BOM, decoding and gating in hardware, chip internals, timing models below register level.
- Rule: do not guess. Hardware facts only from primary sources (datasheets), with the URL and the decision recorded in the document. Describe simplifications explicitly.

## The user's existing repositories (reviewed 2026-10-11, shallow clone)
- `prachwal/emulator-001` (private): .NET 10 solution `Proteus`, so far a CLI skeleton (Generic Host, DI, calc/process/help commands, xUnit, StyleCop). No CPU core. Rules in `AGENTS.md` (CPM, free packages only, `TreatWarningsAsErrors`).
- `prachwal/cpu-vibe-011` (private): a collection of .NET 10 emulators (Intel 4004..8086, Z80, CHIP-8, CP/M, IBM PC 5150). `CpuVibe.Cpu.Abstractions` has ready contracts: `ICpu`, `IBus`, `IMemoryBus`, `IPortDevice`, `IBlockDevice`, `IClockable`, `ICycleCounting`, `IMotherboard`, `IComputerSystem`, `OpcodeTable`. Devices are separate projects (e.g. `Isa.Serial` with the 8250 UART, `Isa.Fdc`). No 6502/6510 core.
- `prachwal/CathodeRay` (public): an assembler and Mini-C compiler in C#, targets: 6502/65C02, Z80, 8080, 6800, stub. "MOS/ca65-style" dialect, linker with segments. Can assemble the BIOS without `ca65`.

## To verify in primary sources (so far from memory)
- 6503/6505 number of address lines, VIC-II `$D01E`/`$D01F`, 8501/7501 process, WD179x data bus (true/inverted), BUSY/DRQ timing in the WD1793, DS1307 and 24C02 details (ACK polling), PAL PPU timing.

## Conclusions
- The bus and device architecture already exists in `cpu-vibe-011`. It is worth using those contracts instead of designing new ones.
- The BIOS can be assembled with the own assembler (`cathode asm --cpu 6502`). To check whether the code from our `.s` files (ca65 syntax) passes in its dialect.
- No 6502/6510 core was found in these three repositories.

## Open questions
- [ ] In which repository is the processor (6502/6510)?
- [ ] Should the machine be built as new projects in `cpu-vibe-011` (the `Cpu.Abstractions` contracts), or in `emulator-001`?
- [ ] Assemble the BIOS with `cathode asm`, or with `ca65`?
