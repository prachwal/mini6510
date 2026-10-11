# Loadable drivers (design)

Status: **design only** (branch `feature/c16-xip`). Idea: load a driver from disk into free RAM, fix its addresses
automatically and register it in a driver table that the kernel uses instead of fixed BIOS jumps.

## Module file (`/lib/drv/*.drv`)
Header: signature `DRV`, contract version, code size, data (BSS) size, entry offsets (`Init`, `Open`, `Read`, `Write`,
`Close`, `Unload`), device name (e.g. `lp`, `drv`), required resources (ports, IRQ). Then code, then the **relocation table**.

## Relocation
The 6502 has no position-independent code, so the module is linked at base `$0000` and carries a list of fix-up offsets:
each entry points at a 16-bit absolute address (`jsr`/`jmp`/`lda abs`) or at a `lo`/`hi` byte pair. The loader adds the load
address to every fix-up (about 200-300 B of loader code). Zero-page variables are not relocated, they are allocated from a pool.
Tool: `tools/mkdrv.py` takes the ld65 output linked at `$0000` and a second link at `$0100` and diffs them to produce the table.

## Driver table (kernel)
Fixed-size array in RAM: name (4 B), flags, address of the entry table, load address and size. Operations: `DrvLoad name`
(find `/lib/drv/name.drv`, allocate RAM, read, relocate, call `Init`, register), `DrvFind name`, `DrvUnload name`
(call `Unload`, free). Kernel and programs use devices by name (`/dev/lp`) and call through the entry table.

## Bootstrap
The first block transport (ROM disk / REU / IEC / TCBM) stays in the BIOS or cartridge ROM: a driver cannot be loaded from
a disk that has no driver yet. Everything after that (printer, clock, extra transports) can be a module.

## First candidates
Printer (IEC unit 4, `/dev/lp`), TCBM/IEC transports, later PET IEEE-488. Open: memory pool size, unload order
(default: LIFO), contract version check (default: refuse on mismatch).

## Decision: packages on disk, loaded on demand, max 1 block (256 B)
Confirmed by the user (2026-10-11). Each driver is a separate file in `/lib/drv`, loaded only when needed (first `open` of `/dev/<name>`
or an explicit `DrvLoad`), never bundled into the PRG.
- **One block = one read:** the whole module (header + code + data + relocation table) fits in 256 B, so loading is a single
  `ReadBlock` into a RAM buffer, then relocation in place. No file-system walk beyond finding the file.
- **Compact format:** header about 12 B (signature 1 B, version 1 B, code size 1 B, BSS size 1 B, fix-up count 1 B, entry offsets as 1-byte
  offsets), then code, then fix-ups as 1-byte offsets (modules are linked in one 256 B page, so every fix-up is an offset below 256 and
  only the high byte of each address needs patching: add `base_hi`). Net: about 200 B of code per driver.
- **Page-aligned load:** the driver is loaded at the start of a free page, so relocation is "add the page number to every high byte
  listed in the table" (no 16-bit carry). Smaller loader (about 60 B) and simple allocation: the pool is a bitmap of free pages.
- **Bigger drivers:** split into a core (one block) plus optional parts loaded the same way, or keep them built into the BIOS/ROM.
  Transports (IEC/TCBM) stay built in, they are larger than a block and are needed before any disk can be read.
- **Good fits:** printer (`lp`), clock, small device filters. Open: unload policy (default: LIFO, or free on last close).

## Candidate: tape (Datasette, `/dev/tap`)
Platforms: C64 (port `$01`: motor bit 5, sense bit 4, write bit 3, read via CIA1 FLAG `$DC0D`), Plus/4 (port `$01`: motor bit 3, sense bit 2, write bit 1, read bit 4 via TED/port). PET has its own cassette ports (VIA/PIA).
- **Block device over tape:** 256 B blocks, sequential access only, so `ReadBlock`/`WriteBlock` work as "next block" with a header per block (block number, checksum), no random access. A tape is a poor system disk, good for backup (`tar`-like `cat dir > /dev/tap`) and loading single programs.
- **Format:** own pulse encoding timed by a CIA/TED timer (short/medium/long pulses as in the KERNAL, but without it), data block + repeat block + checksum, a lead-in tone to sync the speed. Compatible with KERNAL files is optional (default: no).
- **Package size:** the 1-block limit (256 B) is tight for read + write + timing: split into `tapr` (read) and `tapw` (write), loaded on demand. Timing-critical loops run with interrupts off and the screen blanked (C64 `$D011` bit 4, Plus/4 `$FF06` bit 4).
- **Testing:** VICE can attach a `.tap`/`.t64` image (`-attach`), so write then read-back can be tested by comparing the image. Open: pulse timing for 1.0 vs PAL/NTSC (default: PAL).

## Decision: minimal per-machine core may be a monolith
Confirmed by the user (2026-10-11). Per machine only the **start** is required and it may be one monolith: boot code, BIOS (video,
keyboard, interrupts, first block transport) and the kernel core. Everything beyond that (extra transports, printer, tape, clock,
filters, utilities) is a loadable package or a program. A new port therefore needs: the monolithic core for the machine
plus the packages that apply to it; shared packages stay identical across machines where the hardware is the same (e.g. IEC printer).

## Volumes and paths (design)
The cartridge ROM disk is the read-only **base volume** mounted at `/`: base programs in `/bin`, base drivers in `/lib/drv`
(they are found there first). Other volumes are mounted in directories and addressed by path, no drive letters:
| Volume | Medium | Mount point | Access |
|---|---|---|---|
| `rom` | cartridge ROM disk | `/` | read-only |
| `ram` | RAM disk / REU | `/ram` (or `/tmp`) | read-write, lost at reset |
| `drv` | disk drive (1541/1551) | `/disk` | read-write, persistent |
| `tap` | tape | `/tape` | sequential |
Examples: `ls /bin`, `cp /bin/greet /ram/g`, `cat /disk/notes.txt`, `cat big.txt > /ram/b.txt`, `mount drv /disk`.
Lookup order for commands and drivers (`PATH`): `/ram/bin`, `/disk/bin`, then `/bin`, so a copy on disk or in RAM overrides the base version (an update
without a new cartridge). Driver packages follow the same rule for `/lib/drv`.
Mount table in the kernel: name, medium, first block, size, flags (read-only), mount directory; the BIOS call gets the volume number
(today `A=drive` is ignored and must start being used).
