# Roadmap 0.2 (to do)

Status of 0.1: C64 (cartridge, REU, 1541/IEC), Plus/4 (cartridge, ROM disk, 1551/TCBM), generic emulator. All items below are
**not started** and "to be confirmed" unless noted. Details: `docs/xip.md`, `docs/drivers.md`, `docs/decisions.md`.

## Core
- [ ] Low-RAM cartridge mode, execute in place (C16/C116, 16 KB): ROM stays mapped, RAM only for variables (`docs/xip.md`).
- [ ] Kernel size optimization (-10-20 %): size map per function, shared subroutines, tables, zero page, packed texts, rare commands to `/bin`, `.if FEATURE_X`.
- [ ] Monolithic minimal core per machine (boot + BIOS + kernel core); everything else a package or a program.

## Loadable drivers (`docs/drivers.md`)
- [ ] Driver packages in `/lib/drv`, loaded on demand, max 1 block (256 B), page relocation, `tools/mkdrv.py`.
- [ ] Driver table in the kernel (`DrvLoad`, `DrvFind`, `DrvUnload`), devices by name (`/dev/lp`).
- [ ] Printer (IEC unit 4, `/dev/lp`, ASCII to PETSCII).
- [ ] Tape (`/dev/tap`, sequential blocks, `tapr`/`tapw`, test on `.tap`).

## Volumes and disks
- [ ] Mount table, `mount`/`umount`, cartridge ROM disk as base volume `/` (read-only), `/ram`, `/disk`, `/tape`; PATH `/ram/bin`, `/disk/bin`, `/bin`.
- [ ] Two drives (8 and 9): unit number as a variable instead of `IEC_UNIT = 8`, per-volume state, `/d8` and `/d9`, VICE `-9` test. TCBM second interface to be checked.
- [ ] VFS layer in the kernel (open/read/write/close/readdir per filesystem driver).
- [ ] CBM DOS filesystem driver (`cbm`): directory `$`, PRG/SEQ, `@:` overwrite, status on channel 15, flat directory (subdirectories only on SD2IEC/1581/CMD).
- [ ] DOS layer in the BIOS (`DosOpen/Close/Read/Write/Cmd/Status`) and commands `dir`, `load`, `save`, `type`, `scratch`, `rename`, `copy`, `format`, `validate`, `dos`, `status`, `dev` (+ wedge aliases `@`, `/`, `^`).

## Compatibility and games
- [ ] `run`/`load` for PRG files: load at the header address, restore a reset-like machine state (ROM/KERNAL mapped, vectors, VIC/TED/CIA, IRQ), start. Exit = reset.
- [ ] `SYS` start: parse the `SYS` number from the BASIC stub at `$0801`/`$1001` and jump, without running BASIC.
- [ ] `RUN` for BASIC programs: map BASIC ROM, set program pointers, enter the interpreter (entry addresses from `docs/disasm/`).
- [ ] Tests with real `.prg`/`.d64` in VICE.

## New platforms
- [ ] PET / CBM 8032 (80 columns): screen at `$8000`, keyboard (VIA/PIA), 60 Hz timer, IEEE-488 transport under `bios/drive.s`, `xpet` tests.
- [ ] Atari 800/XL/XE: ANTIC text + POKEY, SIO disk (sector = block), 8/16 KB cartridge at `$A000` fits XIP; test in Atari800 emulator.
- [ ] Apple II/II+/IIe: boot from floppy or card ROM, 40 columns (interleaved screen memory), disk via ProDOS block calls (Disk II GCR driver later), no IRQ without a clock card.
- [ ] C128: C64 mode first (test in `x128`); native mode later (MMU, VDC 80 columns, 1571).

## Housekeeping
- [ ] Re-test on real hardware (IEC/TCBM timing), 1541 on Plus/4 over IEC.
- [ ] Update `docs/` and screenshots; tag `v0.2`.

## Candidate machines (6502 family)
| Machine | CPU | Disk / medium | Cartridge | Effort vs Plus/4 |
|---|---|---|---|---|
| C64 (done), Plus/4 (done) | 6510 / 7501 | IEC 1541, TCBM 1551, REU, ROM | yes | - |
| C16 / C116 | 7501 | tape, 1551 | yes | small (XIP) |
| VIC-20 | 6502 | IEC, 3.5-35 KB RAM | yes (`$A000`) | medium (tiny RAM, XIP) |
| C128 | 8502 | IEC 1571, MMU, VDC | yes | small (C64 mode) / large (native) |
| PET / CBM 8032 | 6502 | IEEE-488 | ROM socket | medium |
| Atari 800/XL/XE | 6502C | SIO | yes | medium |
| Apple II/IIe | 6502 | Disk II / ProDOS | no | large |
| BBC Micro | 6502 | DFS/ADFS (Acorn) | ROM sockets | large |
| Oric Atmos | 6502 | tape / Microdisc | no | medium |
| NES / SNES-class, others | 2A03 / 65816 | none | cartridge only | out of scope (no disk) |
Rule of thumb: the kernel stays the same; a machine needs only its monolithic core (video, keyboard, timer, first block device).

## Native applications
A program built for MiniUnix runs on **every** supported machine only if it uses the BIOS contract (`bios.inc`: console, keys, blocks, clock) and
not hardware directly. Rules: no direct video/IO access, no absolute addresses outside the program slot, 40-column safe output (or ask the console
for its width), no machine-specific features. Hardware-specific programs (graphics, sound, games) are built per machine
(`/bin` per platform, or a package with a machine tag). Games from the original machine are separate (`run`, see above).
