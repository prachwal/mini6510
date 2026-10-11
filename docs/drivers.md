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
