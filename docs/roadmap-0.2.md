# Roadmap

0.1 (done): C64 (cartridge, REU, 1541/IEC), Plus/4 (cartridge, ROM disk, 1551/TCBM), generic emulator.
Rule: a new idea goes to "Ideas" first; it enters a version only when something else leaves it. Each version has one theme and
is released when its tests pass. Everything is **to be confirmed**; details in `docs/xip.md`, `docs/drivers.md`, `docs/decisions.md`.

## 0.2 - Small and ROM-resident (theme: cartridge without copying to RAM)
- [ ] Kernel size optimization (-10-20 %): size map per function, shared subroutines, tables, zero page, packed texts, rare commands to `/bin`, `.if FEATURE_X`.
- [ ] Memory budget per machine (table below) checked at build time: `scripts/build.py` fails when a part exceeds its limit and prints the size map per part.
- [ ] Boot-medium builds: one monolith per machine and boot method (`cart`, `iec`, `tcbm`, `reu`) containing only its own block transport; other transports become packages (`docs/drivers.md`).
- [ ] Low-RAM cartridge mode, execute in place (C16/C116, 16 KB): ROM stays mapped, RAM only for variables (`docs/xip.md`).
- [ ] Mount table with the cartridge ROM disk as the base volume `/` (read-only) and `/ram` (RAM disk/REU), `mount`/`umount`, PATH `/ram/bin`, `/bin`.
- [ ] Snake as a portable program in `/bin` (console + `KeyGet` + tick only), run on C64, Plus/4 and C16 as the contract test.
Done when: Plus/4 16 KB and C64 boot from ROM with no code copied to RAM, regression green, snake runs on all targets.

## 0.3 - Drivers and disks (theme: more storage, same kernel)
- [ ] Loadable driver packages in `/lib/drv`: max 1 block (256 B), page relocation, `tools/mkdrv.py`, driver table (`DrvLoad/Find/Unload`), devices by name.
- [ ] Two drives (8 and 9): unit number as a variable instead of `IEC_UNIT = 8`, per-volume state, `/d8`, `/d9`, VICE `-9` test.
- [ ] Printer package (IEC unit 4, `/dev/lp`, ASCII to PETSCII).
- [ ] Common graphics BIOS (`docs/graphics.md`): `GfxCaps`, `GfxMode`, `Plot`, `Clear`, `Fill`, `Line`, implemented per platform (C64, Plus/4 first); a demo program that adapts to the reported size.
- [ ] Sound contract (`Tone`, `Quiet`, `SoundCaps`) as package `snd`; Tetris as the second portable program.
Done when: a package loads, relocates and registers on both platforms; 8+9 test passes; `cat x > /dev/lp` lands in the VICE printer file.

## 0.4 - Compatibility with CBM DOS and games (theme: run what already exists)
- [ ] VFS layer in the kernel and CBM DOS filesystem driver (`cbm`): directory, PRG/SEQ, overwrite, channel 15 status, flat directory.
- [ ] DOS layer in the BIOS (`DosOpen/Close/Read/Write/Cmd/Status`) and commands `dir`, `load`, `save`, `type`, `scratch`, `rename`, `copy`, `format`, `validate`, `dos`, `status`, `dev`.
- [ ] `run`/`load` for PRG: load at the header address, reset-like machine state, start (reset = exit); `SYS` parsed from the BASIC stub; `RUN` through the BASIC ROM.
- [ ] Tape package (`/dev/tap`) if still wanted.
Done when: real `.prg`/`.d64` games load and start in VICE, `ls`/`cat`/`cp` work on a CBM DOS disk.

## Ideas (not scheduled; at most one new machine after 0.2)
- Machines: PET / CBM 8032 (IEEE-488), C128 (C64 mode first, native later), Atari 800/XL/XE (SIO, cartridge fits XIP), Apple II (ProDOS blocks), VIC-20, BBC Micro, Oric.
- Pac-Man (text mode), more portable games and tools.
- Real-hardware tests (IEC/TCBM timing), 1541 on Plus/4 over IEC.
- Tag and release notes per version; update `docs/` and screenshots each time.

## Candidate machines (6502 family), effort vs Plus/4
| Machine | CPU | Disk / medium | Cartridge | Effort |
|---|---|---|---|---|
| C64, Plus/4 (done) | 6510 / 7501 | IEC, TCBM, REU, ROM | yes | - |
| C16 / C116 | 7501 | tape, 1551 | yes | small (XIP) |
| VIC-20 | 6502 | IEC | yes | medium (tiny RAM) |
| C128 | 8502 | IEC 1571 | yes | small (C64 mode) / large (native) |
| PET / CBM 8032 | 6502 | IEEE-488 | ROM socket | medium |
| Atari 800/XL/XE | 6502C | SIO | yes | medium |
| Apple II/IIe | 6502 | Disk II / ProDOS | no | large |
| BBC Micro, Oric | 6502 | DFS / Microdisc | ROM sockets / no | large / medium |

## Portable programs
A program runs on every supported machine only if it uses the BIOS contract (`bios.inc`: console, keys, blocks, clock, later sound) and not
hardware directly: no direct video/IO, no absolute addresses outside the slot, fixed 40x24 layout (or ask the console for its width).
Machine-specific programs are built per platform.

## Memory budget (memory is the main constraint)
Measured in 0.1 (bytes) and proposed limits. A limit is a build error, not a hint. RAM = what the part needs at run time.
| Part | 0.1 now (ROM/image) | 0.2 limit | RAM at run time |
|---|---|---|---|
| Kernel (`kernel.bin`) | 7202 | 6000 (XIP: in ROM) | variables + process table, no code |
| BIOS C64 (`bios.rom`) | 4196 | 4000 | I/O vars `$03xx`; in XIP mode no code in RAM |
| BIOS Plus/4 | 5120 | 4800 | as above; today BIOS is copied to `$E700` (to remove in XIP) |
| BIOS generic | 2048 | 2048 | - |
| Driver package | - | 256 (1 block) | 256 + its variables |
| Graphics (`gfx`) | - | 600 per platform | bitmap 8000 (only if free RAM) |
| ROM disk (data) | C64 480 blocks, Plus/4 104 blocks | - | write overlay 23 blocks (Plus/4) |
Machine RAM classes and what must hold:
| Machine | RAM | Reserved (screen, stack, ZP, system) | Left for programs (target) |
|---|---|---|---|
| C16 / C116 | 16 KB | about 2 KB | 10-12 KB (XIP; no graphics bitmap) |
| VIC-20 (+16 KB) | 21 KB | about 2 KB | 12-16 KB (XIP) |
| Plus/4, C64 | 64 KB | about 4 KB | up to `$D000` (slots), graphics bitmap fits |
Rules: code and constants stay in ROM (XIP); packages are loaded on demand and freed; the graphics bitmap, the disk buffer and the write overlay
never exist at the same time on a small machine (graphics reports "no" or the overlay shrinks); hot variables go to zero page; texts are packed; every new
feature states its ROM and RAM cost in this table before it is accepted.
