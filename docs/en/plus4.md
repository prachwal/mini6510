# Commodore Plus/4 port

- Hardware: 7501 (NMOS), TED 7360/8360, 64 KB RAM. BIOS working map: RAM everywhere (`$FF3F`), I/O and TED at `$FD00-$FF3F`, KERNAL/BASIC not used.
- Memory: `$0200-$03FF` BIOS variables and the cartridge reader, `$0800-$0FFF` TED screen (attributes at `$0800`, characters at `$0C00`), kernel from `$1000` (KBASE),
  kernel data DB=`$2C00`, program slots `$4000/$7000/$A000`, write overlay `$D000-$E6FF`, BIOS + drive driver `$E700-$F8xx`.
- Console: 40x25 text, lower/upper case set from the character ROM (`$FF13=$D4`), attribute `$71` (white), cursor = inverted character; the TED hardware cursor is moved off screen (`$FF0C/$FF0D` = 1023).
- Keyboard: row select by a write to `$FD30` (0 = active), latch `$FF08=$FF`, columns read from `$FF08` (0 = pressed). Matrix from VICE (`gtk3_pos.vkm`):
  Shift (1,7), CTRL (7,2), C= (7,5). `|` = Shift+`-`, `_ { } ~` = C= + `@ W Q =`, RUN/STOP = ^C.
- Timer: TED timer 1, counting from 886724 Hz (PAL), reload 8867 -> 100 Hz; IRQ through flag `$FF09` bit 3 (cleared by writing 1), mask `$FF0A=$08`.
- Time: the TED has no TOD or RTC, so `TickAck` keeps a software clock (starts at 09:00:00, fixed date 2026-10-11).
- CART-1 cartridge (`-cart`, 32 KB = c1lo + c1hi): after reset the KERNAL (POLL routine, `$FC1E`) selects the ROMs in turn (`$FDD0+n`, n = 15, 10, 5, 0), checks `CBM` at `$8007` and the byte `1` at `$8006`,
  then does `JSR $8000` before initialization. The boot code copies the BIOS to RAM, a trampoline at `$0334` switches to RAM (`$FF3F`) and jumps to `Reset`.
- ROM disk: 104 blocks = 44 in c1lo (`$9400-$BFFF`) + 60 in c1hi (`$C000-$FBFF`); source page = block number + `$94`. Bank select by a write to `$FDD0+n`
  (n=2 low CART-1, n=8 high CART-1), then `$FF3E` (ROM visible). The reader runs in RAM (`$0340`) with interrupts masked.
- Writes: a 23-block overlay in RAM (`$D000-$E6FF`, block number table at `$03A1`); a read checks the overlay before the ROM. A full overlay -> error 5. It disappears at reset.
- Test: VICE xplus4 with the original ROMs (`PLUS4_ROMS`: `kernal.bin` 318004-05, `basic.bin` 318006-01, `3plus1.bin` 32 KB or `functionlo/hi.bin`).
- To confirm: hardware (VICE only), NTSC (`TICK_DIV` 8949), the overlay is not persistent, no IEC/1551 (see below for 1551), C16/C116 (16 KB RAM) not supported.

## 1551 drive (TCBM)
See [drives.md](drives.md). The BIOS image in c1lo is 5 KB (ROM disk: 104 blocks from `$9400`, 44 blocks in c1lo + 60 in c1hi), the BIOS runs from `$E700`; drive 8 with a MiniUnix disk takes precedence over the ROM disk.

### Note: character ROM and cartridge banks

TED fetches glyphs from `$D400` of the *high ROM bank*. If the cartridge's c1hi bank stays selected (`ROM_BANK` n=8), the
glyphs come from disk data and the screen is garbled. The BIOS therefore selects the internal ROMs (`sta ROM_BANK`) at reset
and after every ROM-disk block read.
