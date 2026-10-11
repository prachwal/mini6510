# 02 - Processor (6502)

## Registers
- A: accumulator, 8 bit
- X, Y: index registers, 8 bit
- S: stack pointer, 8 bit. The stack is on page $01 (addresses $0100-$01FF)
- PC: program counter, 16 bit
- P: status register (flags)

## Flags (P)
- N: negative (bit 7 of the result)
- V: overflow
- B: break (set only on the stack by BRK/PHP)
- D: decimal mode (on the NMOS 6502 it is not changed by reset)
- I: interrupt disable (IRQ mask)
- Z: zero
- C: carry

## Reset sequence (RES)
1. The RES line is held low for a few cycles, then released.
2. 7 reset cycles: 2 read cycles, 3 "dead" stack reads (S decreases by 3, writes suppressed), 2 reads of the reset vector.
3. PC is loaded from $FFFC (low byte) and $FFFD (high byte).
4. The I flag is set.
5. The instruction is fetched from the new PC.

Registers A, X, Y and the initial value of S have no defined value at power-on. The program must initialize them.

## 6510 variant (I/O port)
- `$0000` DDR: bit = 1 output, bit = 0 input.
- `$0001` port: port data.
- In the C64: bits 0-2 control the ROM/RAM mapping (LORAM, HIRAM, CHAREN), bit 3 is the tape output, bit 4 is the PLAY input, bit 5 is the motor. Bits 6-7 are not connected.
- A write to `$0001` changes the address space mapping, so the emulator must take it into account in the decoder.

## 6502 variants (from memory, to verify in the datasheet)
- 6502 (MOS, NMOS, 16 bit): JMP (indirect) bug at `$xxFF`, undocumented instructions, wrong N/V/Z in BCD.
- 6502A/B/C (NMOS, 16 bit): faster versions (typically 2 and 3 MHz).
- 6503/6504/6505/6507 (NMOS, 13 bit, 8 KB, 28-pin): the 6507 in the Atari 2600.
- 6509 (NMOS, 20 bit): internal bank register.
- 6510 (NMOS, 16 bit): I/O port `$0000`/`$0001`, C64.
- 65C02 (CMOS, 16 bit): new instructions, fixed JMP, no undocumented NMOS instructions, BRK clears D, correct BCD.
- 65816 (CMOS, 24 bit): native 16-bit mode, 6502 emulation mode, SNES.
- Key for the emulator: NMOS vs CMOS (BCD, JMP, undocumented) and the width of the address bus.

## NES variant (Ricoh 2A03 / 2A07)
- 6502 core without BCD mode (the D flag has no effect).
- Built-in APU (2 pulse, triangle, noise, DMC).
- Built-in DMA: a write to `$4014` copies 256 bytes to OAM, the CPU is halted for about 513-514 cycles.
- Controller ports `$4016`/`$4017`.
- Clock: about 1.79 MHz (NTSC), about 1.66 MHz (PAL). The 2A07 is the PAL version.

## C116 / Plus/4 / C128 variants (from memory, to verify)
- C116: 7501/8501, about 1.77 MHz, I/O port similar to the 6510, 16 KB RAM (the cheaper Plus/4).
- Plus/4: 7501/8501, about 1.77 MHz, I/O port similar to the 6510, TED chip (video, sound, timers).
- C128: 8502, 1 or 2 MHz, I/O port as in the 6510, Z80 in CP/M mode, bank switching through the 8722 MMU.
- For the emulator: the 8502 in 2 MHz mode and the MMU controlling the memory map in the C128.

## 8501 vs 8502 differences (from memory, to verify)
- 8501: CMOS, about 1.77 MHz, I/O port similar to the 6510, Plus/4 and C116 (later versions).
- 8502: CMOS, 1 or 2 MHz, I/O port as in the 6510, C128.
- Instructions compatible with the 6502. The clock and the memory mapping differ, so the CPU core can be shared.

## To confirm
- [ ] Does the emulator model exactly the 7 reset cycles and the "dead" stack reads (or is setting PC and I enough)?
- [ ] Initial values of A, X, Y, S: 0 or random?
- [ ] NMOS variant (classic 6502) or CMOS (65C02)? It affects decimal mode and a few instructions.
