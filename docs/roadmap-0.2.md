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
- [ ] C128: C64 mode first (test in `x128`); native mode later (MMU, VDC 80 columns, 1571).

## Housekeeping
- [ ] Re-test on real hardware (IEC/TCBM timing), 1541 on Plus/4 over IEC.
- [ ] Update `docs/` and screenshots; tag `v0.2`.
