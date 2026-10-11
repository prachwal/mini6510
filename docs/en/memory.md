# 04 - Memory (6502)

## Address space
- 16 bit: 64 KB ($0000-$FFFF)
- Byte order: little-endian (low byte first)

## Important areas
- $0000-$00FF: zero page (fast access, zero-page addressing)
- $0100-$01FF: stack (page $01, pointer S)
- $FFFA-$FFFF: interrupt vectors

## Interrupt vectors
| Address | Name | Description |
|---------|------|-------------|
| $FFFA / $FFFB | NMI | non-maskable interrupt |
| $FFFC / $FFFD | RESET | start address after reset |
| $FFFE / $FFFF | IRQ/BRK | maskable interrupt and BRK |

The vectors are not written by the CPU. They are part of the ROM and are set by the program or the build tool. The CPU only reads them.

## 6510 variant (instead of the 6502)
- `$0000` (DDR) and `$0001` (port data) are not RAM. BIOS variables, the loader and the stack must not live there.
- The port has 6 lines (P0-P5), bits 6-7 not connected.
- After reset DDR = 0 (inputs with pull-up). The shadow stays on the external 74HC273 latch.

## 6502 memory map with 64 KB RAM and shadow (proposal)
- `$0000-$D7FF`: RAM. `$D800-$DFFF`: I/O (UART `$DF00`, FDC `$DF10`, I2C `$DF20`, shadow latch `$DE00`). I/O takes precedence over RAM.
- `$E000-$F7FF`: RAM.
- `$F800-$FFFF`: ROM at start (latch = 0), shadow RAM afterwards (latch = 1). Vectors included.
- A write always goes to RAM (WE). A read of `$F800-$FFFF` comes from ROM when ROM is ON.
- RAM: 2x 62256, selected by A15. 74HC273 latch, reset = 0 (ROM ON).

## NES memory map (CPU)
- `$0000-$07FF`: 2 KB RAM, mirrored up to `$1FFF`
- `$2000-$2007`: PPU registers, mirrored up to `$3FFF`
- `$4000-$4017`: APU and I/O (DMA at `$4014`, controllers at `$4016`/`$4017`)
- `$4018-$401F`: test (usually unused)
- `$4020-$FFFF`: cartridge (PRG-ROM/RAM, mapper)
- `$FFFA-$FFFF`: NMI, RESET, IRQ vectors, in the cartridge

## Address decoding
- Each component has a base and a size. It is selected (chip select) when the address falls in its range.
- Example, 32 KB RAM at `$0000`: selected when A15 = 0, and A0-A14 select the byte.
- Example, a device with 16 registers at `$D000`: selected in the range `$D000-$D00F`, A0-A3 select the register.
- Emulator: the bus looks for the component with `base <= addr < base + size` and passes the offset `addr - base`.
- When no chip is selected: a read returns open bus (the last bus value or `$FF`), a write is ignored.
- Partial decoding (omitted address bits) creates mirrors of the same RAM at several addresses. To confirm whether the emulator models this.

## Mapping (proposed, to confirm)
- Default: ROM covers the end of the address space (including $FFFA-$FFFF), RAM starts at $0000.
- Example: 32 KB ROM at $8000-$FFFF, the vectors are the last 6 bytes of the file.

## To confirm
- [ ] ROM/RAM size and layout (default: RAM $0000-$7FFF, ROM $8000-$FFFF).
- [ ] Should the emulator support memory-mapped I/O (e.g. $6000-$7FFF)?
- [ ] Should a write to ROM be ignored (default: yes)?
