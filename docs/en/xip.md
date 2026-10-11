# Low-RAM cartridge mode (execute in place, C16/C116 class) - design

Status: **design only** (branch `feature/c16-xip`), implementation not started. Target: cartridge, not loading code into RAM.

## Goal
On a machine with little RAM (Plus/4 family: C16/C116 = 16 KB) the cartridge must not copy BIOS, kernel or programs to RAM.
Code runs from ROM (CART-1 stays mapped); RAM holds only variables, stack, screen and per-process data.

## Decisions (proposed, to be confirmed)
- ROM stays visible permanently (`TED_ROMON`); cart banks c1lo/c1hi selected by `ROM_BANK`, internal high ROM is not used.
- BIOS jump table lives at a fixed address in the cartridge ROM (no copy to $F800); per-platform base in `platform.inc`.
- IRQ/NMI/RESET: the KERNAL ROM vectors at $FFFE are not ours, so the IRQ path goes through the RAM vector ($0314) with a ROM handler.
- Narrow RAM window for BIOS/kernel variables ($0300-$03FF + zero page); screen and attributes at the standard TED locations.
- RAM size probe at POST (16/32/64 KB); program slots are sized from the probe result.
- ROM disk is read directly (no RAMCODE copy), because the ROM is always mapped; writes still go to a RAM overlay, whose size depends on free RAM.
- TED character fetch must keep reading the internal ROM glyphs ($D400): do not map the cart over the high bank, copy a glyph set into the cart image instead (see docs/en/plus4.md, ROM bank note).

## Work plan
1. POST: RAM probe, memory map by size. 2. Cart layout: kernel + BIOS in c1lo, disk in c1hi, jump table in ROM.
3. Kernel: relocatable data area, no self-modifying code in ROM. 4. IRQ via RAM vector. 5. ROM disk reader without RAMCODE.
6. VICE test with `-ramsize 16` (xplus4 C16 model), screenshots, docs update.

## Open questions
- Glyph source in XIP mode (own character set in cart ROM vs internal ROM bank). Default: own set in cart ROM.
- Minimum supported RAM (default 16 KB).
