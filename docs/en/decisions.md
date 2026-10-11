# Decisions

Format: date, decision, status (confirmed / to confirm).

## 2026-10-11
- Interrupt vectors (NMI, RESET, IRQ/BRK) are in ROM at $FFFA-$FFFF. The CPU only reads them. Status: to confirm (default: yes).
- I/O devices: memory-mapped. No DMA in the CPU core, possibly a separate component later. Status: to confirm.
- Default mapping: RAM $0000-$7FFF, ROM $8000-$FFFF. Status: to confirm.
- A write to ROM is ignored. Status: to confirm.
- CP/M needs an 8080/Z80 CPU (not a 6502). Proposal: Z80. Status: to confirm.
- RS-232 needs a UART (6850, 8251, 6551 or Z80 SIO). The PIA 6520 is not serial. Status: to confirm.
- 128 KB RAM needs bank switching (the CPU sees 64 KB). Status: to confirm.
- EEPROM with BIOS settings (e.g. 24C02 through the PIA, a checksum). Status: to confirm.
- 64 KB RAM (2x 62256), shadow ROM through a 74HC273 latch at `$DE00` (bit0: 0 = ROM ON). A write always goes to RAM. Status: chosen by the user (2026-10-11).
- A latch instead of the PIA 6520 for the shadow (state after reset). Status: proposal.
- 6510 CPU instead of the 6502. The port at `$0000-$0001` (not RAM), BIOS variables outside this area, an external shadow latch. Status: to confirm.
- The processor is out of scope of these notes (the user has it separately). Status: indicated by the user (2026-10-11).
- Goal: a BIOS and OS for a faithful emulator. The notes describe only the communication boundary (the contract visible to software), without details of the implementation of devices and hardware. The contract is in `platform.md`. Status: indicated by the user (2026-10-11), replaces the earlier proposals about scope.
- A system clock with a periodic IRQ at `$DF30-$DF33` (100 Hz by default, the period in ms, acknowledged by a write). For preemption in a Unix-like OS. Status: indicated by the user (2026-10-11), register details to confirm.
- A console with a hardware receive FIFO of 64 B, register `$DF02` (RXCOUNT), an overflow bit in STATUS. Reason: a single receive register loses characters when polled at 100 Hz. Status: indicated by the user (2026-10-11), depth to confirm.
- Screen and keyboard: an ANSI/VT100 terminal over the serial console, without a separate video device. Size 80x24 as the default, to confirm. Status: indicated by the user (2026-10-11).
- Disk: a block interface (16-bit block number, 256 B block, transfer to a buffer in RAM, `$DF10-$DF18`), instead of an interface modeled on the WD179x. Status: indicated by the user (2026-10-11), register details to confirm.
- An alternative to CP/M: an own OS (bootloader, drivers, system calls, a simple FS, loader, shell). Proposal: an own OS on the 6502. Status: to confirm.

## 2026-10-11 - C64 port
Platforms split into `bios/` + `platforms/<name>/`; the kernel depends only on `bios.inc` and `platform.inc`. The C64 disk = REU. Approved by the user: refactoring for the C64 and a test in an emulator.

## 2026-10-11 - Magic Desk cartridge (branch feature/c64-cartridge)
Booting the whole system from a cartridge: bank 0 = boot + BIOS, banks 1-15 = a 480-block ROM disk. With a REU we copy the disk to the REU (writable), without a REU read-only. To confirm: merge to main.

## 2026-10-11 - Commodore Plus/4 port (branch feature/plus4)
The Plus/4 starts from a CART-1 cartridge (32 KB). A disk in ROM (108 blocks) + a writable overlay in RAM (24 blocks). Software time (no RTC). To confirm: merge to main.

## 2026-10-11 - Disk drives (branch feature/iec-drive)
A driver for drive 8 as a block device: IEC/1541 (C64) and TCBM/1551 (Plus/4, the native drive of that machine), a shared U1/U2 layer. A drive with a MiniUnix disk takes precedence over REU/ROM. The Plus/4 BIOS grew to 5 KB (ROM disk 104 blocks, BIOS from $E700, overlay 23 blocks). Description: `docs/en/drives.md`. To confirm: merge; next step: low-memory mode (C16/C116, execution from ROM).

## 2026-10-11 - Low-memory mode / XIP (branch feature/c16-xip)
Goal: a cartridge that copies nothing to RAM (C16/C116, 16 KB). Code executed from ROM, RAM only for variables. For now only a design: `docs/en/xip.md` (to confirm: minimum RAM 16 KB, an own character set in the cartridge ROM).

## 2026-10-11 - Candidates for further platforms (for later, to confirm)
- **PET / CBM 8032 (80 columns):** a new platform `platforms/pet`. To write: an 80x25 screen at `$8000`, keyboard (VIA/PIA), a 60 Hz timer, an IEEE-488 transport (PIA 6520 + VIA) under the existing block layer `bios/drive.s` (U1/U2 commands). Mind the sector table of the 2031/4040/8050 drives and the lack of a cartridge (a bootloader from disk or a ROM in the `$9000` socket). Test: VICE `xpet`.
- **C128:** C64 mode should run practically unchanged (test in `x128`). Native mode (`platforms/c128`): MMU `$FF00`, 128 KB RAM, VIC-IIe video 40 columns or VDC 8563 80 columns, the 1571 drive through the same IEC transport (1328 blocks, a different sector table).
Status: to confirm (priority and order).

## 2026-10-11 - Kernel size optimization (for later, to confirm)
The kernel `os/kernel.s` is about 7.2 KB. Plan: (1) measure the size per function from the linker map, (2) shared subroutines, dispatch through tables, more variables in zero page, text compression, (3) rare commands (`uptime`, `date`, `ps`) to `/bin`, (4) `.if FEATURE_X` flags for a minimal version (C16/XIP mode). Goal: -10-20 % without losing functions; regression tests guard correctness.

## 2026-10-11 - Loadable drivers + printer (for later, to confirm)
Packages on disk (`/lib/drv`), loaded as needed, max 1 block (256 B), page relocation (only the high bytes of addresses). A driver loaded from disk into an area of RAM with automatic relocation (a table of address fixes in the module file) and registered in a driver table (name, entry table, address, size); the kernel uses devices through the table (`/dev/lp`). The startup transport stays in the BIOS/ROM. First candidate: an IEC printer (address 4). Description: `docs/en/drivers.md`.

## 2026-10-11 - Tape driver (for later, to confirm)
Another loadable driver: a cassette recorder (`/dev/tap`), sequential access, 256 B blocks with a header and a checksum, own pulse encoding (without the KERNAL), split into packages `tapr`/`tapw` (the 1-block limit). Test in VICE through a `.tap` image. Description: `docs/en/drivers.md`.

## 2026-10-11 - The per-machine core may be a monolith
The minimum per machine is the start (boot + BIOS + the kernel core), it may be a monolith. The rest (additional transports, printer, tape, clock, filters) as loadable packages or programs. Description: `docs/en/drivers.md`.

## 2026-10-11 - Mounting volumes, the cartridge as the base volume (for later, to confirm)
The cartridge ROM disk = the base volume `/` (read-only) with the base programs (`/bin`) and drivers (`/lib/drv`). RAM disk/REU under `/ram`, a drive under `/disk`, tape under `/tape`. Plain paths (no drive letters), the `mount`/`umount` command, PATH: `/ram/bin`, `/disk/bin`, `/bin` (a copy on a writable volume overrides the base one). Description: `docs/en/drivers.md`.

## 2026-10-11 - Backward compatibility and launching games (for later, to confirm)
Goal: running existing games/PRGs from CBM DOS disks. A game takes over the whole machine, exit = reset (games have no exit), so the system does not have to survive launching a game. The `run`/`load` command: loading the PRG at the address from the header, restoring a reset-like state (memory layout with the ROMs and the KERNAL, vectors, VIC/TED/CIA registers, interrupts), start through `SYS`/`RUN`. A resident in the cartridge ROM (XIP mode) does not use the game's RAM; returning to MiniUnix by reset (software or a button). Out of reach: copy protections, own disk formats, cartridge games. Test: VICE with real `.prg`/`.d64`.

## 2026-10-11 - Plan for version 0.2
The plan is split into versions: 0.2 (small and ROM-resident: optimization, XIP, volumes `/` and `/ram`, snake), 0.3 (loadable drivers, drives 8/9, printer, sound, tetris), 0.4 (VFS + CBM DOS, `run` for games, tape). The rest in "Ideas": new machines, pacman, tests on hardware. Description: `docs/en/roadmap-0.2.md`. Status: to confirm.

## 2026-10-11 - Common graphics BIOS
A user requirement: one common graphics interface in the BIOS for all machines (not pretty, only common). A narrow contract: `GfxCaps`, `GfxMode`, `Clear`, `Plot`, `Fill`, `Line`; applications read the size and adapt the layout (in 8x8 cells). Effects and sprites outside the contract. Version 0.3. Description: `docs/en/graphics.md`. Status: to confirm.

## 2026-10-11 - Memory budget
Memory is the main constraint: every part (kernel, BIOS, driver, graphics) has a ROM/RAM limit in the table in `docs/en/roadmap-0.2.md`, and `scripts/build.py` is to fail the build when it is exceeded (0.2). Code and constants in ROM (XIP), packages loaded on demand, the graphics bitmap, the disk buffer and the write overlay not at the same time on a small machine. Status: to confirm.

## 2026-10-11 - The boot medium in the monolith
The monolith contains exactly one transport of the boot medium, depending on the boot method: cartridge (the ROM disk reader), IEC/1541 drive, TCBM/1551 or REU. Other transports are packages loaded from the boot volume. A separate build per machine and boot method (`--boot cart|iec|tcbm|reu`), a smaller BIOS, without all transports at once. Applies to 0.2. Description: `docs/en/drivers.md`.

## 2026-10-11 - musicplay (Atari, SAP)
The tool `musicplay file.sap` on the Atari: loading SAP (type B first), loading the blocks, `INIT` with the song number, `PLAYER` from the timer every frame (`TickSet hz`). `.sid` on the Atari only through offline conversion. Needs an Atari platform (not started), hence in "Ideas". Description: `docs/en/musicplay.md`. Status: to confirm.

## 2026-10-11 - musicplay (C64, SID)
The tool `musicplay file.sid` on the C64: PSID first (RSID later through `run`), loading at the address from the header with a collision check against the kernel/BIOS, `init` with the song number, `play` from a 50/60 Hz timer (`TickSet`), keys, silencing the SID on exit. The first candidate after 0.2 (the C64 platform exists). Description: `docs/en/musicplay.md`. Status: to confirm.

## 2026-10-11 - Test coverage of the assembly code is required
Every routine needs tests, and the coverage of the assembly code is measured (executed addresses mapped to source lines with ca65/ld65 debug info, branch coverage, unit tests of routines, fault injection) with a threshold enforced in CI. Hardware-specific code (VIC/TED/SID, IEC/TCBM timing, self-modified code in RAM) is covered by VICE/hardware tests. Description: `docs/en/roadmap-0.2.md`. Status: to confirm.
