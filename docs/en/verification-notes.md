# Conversation verification and proposed fixes (2026-10-11)

Method: the code from the `.s` files assembled with `ca65` (built from cc65), facts checked in sources (Wikipedia 8502 and 6507, MC6850 datasheet), the rest by re-reading the code and documents.
Markers: [ASM] found by the assembler, [DS] confirmed in a source, [READ] result of reading the code (not run), [MEMORY] could not be confirmed.

## A. Errors in the code (the code will not work or will work wrongly)

| # | File | Problem | Fix |
|---|------|---------|-----|
| A1 | system-loader.s | [ASM] The variable `sec` has the name of the SEC instruction, the assembler reports an error. | Rename it to `secnum` (a variable, not an instruction). After the change the file is 194 B. |
| A2 | bios-post.s `CheckUart` | [DS] After writing `$03` (master reset) the UART is still in reset, and in that state TDRE is blocked. Reading the status right after the reset returns FAIL. | Order: `$03`, then configuration (`$15` or `$16`), only then read the status (expected TDRE=1, RDRF=0). |
| A3 | rtc.s | [READ] `I2cDelay` (`ldx #4`) and `SdaRead` (`ldx #0`) destroy X, while `I2cWrite`/`I2cRead` use X as an 8-bit counter. The bit loops do not work. | Delay on Y (`ldy`/`dey`), in `SdaRead` replace `ldx #0 / stx` with `lda #0 / sta PIA_CRA`. Or remove the file if the I2C controller stays (see C3). |
| A4 | system-loader.s | [READ] Range check: comparison with `$F8` instead of the lower end of the I/O hole `$D8`. The image could write over the registers `$D800-$DFFF`. Also `cmp` overwrites the carry after `adc`, so overflow (hi+cnt > 255) is not detected. | `adc cnt` / `bcs error` (overflow) / `cmp #$D8` / `bcs error`. Load address not lower than `$0200`. |
| A5 | both loaders, `WaitFdc`, `ReadSectorPtr` | [READ] Race after issuing a command: BUSY is set with a delay. The first status read may see BUSY=0 and DRQ=0, and then the loop ends "successfully" without data. 3 NOPs in `WaitFdc` are too few. | After the command wait the time required by the datasheet (tens of microseconds, to confirm for the FDC clock used), or wait with a limit for BUSY=1, then for BUSY=0. |
| A6 | both loaders, the read loop | [READ] The loop takes about 26 cycles per byte. At 250 kb/s a byte arrives every 32 us, so at 1 MHz the margin is about 6 us (LOST DATA risk), at 2 MHz it is safe. | Decide the CPU frequency and the disk speed. At 1 MHz shorten the loop or use a lower speed mode. |
| A7 | bios-post.s `WaitForSetup` | [READ] The comment says "about 2 s", while the loops (20 x 256 x 13 cycles) give about 67 ms at 1 MHz. | A 16-bit counter (about 600 outer iterations for 2 s at 1 MHz) or use the RTC. |
| A8 | `Delay` (loader) | [READ] About 0.33 s at 1 MHz. It may be too short for motor spin-up. | Check the drive documentation or wait for index pulses. |
| A9 | bios-post.s / shadow.s | The RAM test range is inconsistent with the map: `bios-post.s` tests `$0200-$7FFF` and prints "RAM 32KB"; the description in `shadow.s` and in the startup sequence gives `$0200-$DDFF`, which runs into I/O (`$D800-$DFFF`). | Ranges `$0200-$D7FF` and `$E000-$F7FF`, the text "RAM 64KB" computed from the test result. |
| A10 | many files | [READ] Constants (`ptr`, `ptr2`, `tmp`) defined separately in several files with different meanings, not exported. Linking gives unresolved symbol errors. | One `bios.inc` with the zero-page map and I/O addresses (already planned in `bios-api.md`). |
| A11 | I2C API (chat, no file) | The code was neither saved nor assembled. `I2C_WRITE` to the 24C02 does no ACK polling, and a write takes several ms, so the following writes get NACK. | Save to `i2c-api.s`, add an address retry loop with a limit. |
| A12 | `shadow-test.s` | Replaced by `shadow-reloc.s`, but still lying next to it. | Remove. (`shadow-reloc.s` assembles: the RELOC block is 117 B, smaller than 256 B.) |

## B. Factual errors

| # | Where | Was | Should be |
|---|-------|-----|-----------|
| B1 | 02-cpu.md, 8501/8502 table | "CMOS" | [DS] the 8502 is HMOS (NMOS). For the 8501 the source gives no process, so mark "HMOS, to verify". The core is still without CMOS changes (BCD, JMP). |
| B2 | 02-cpu.md, 8502 | port "as in the 6510" | [DS] a 7-bit port (6510: 6-bit), no phi2 pin. Full 2 MHz only with the VDC (C128), with the VIC about 1 MHz. |
| B3 | 01-architecture.md and `bios-post.s`, UART | `$15` = "8N1, /64" | [DS] `$15` = 8N1, **/16**. /64 is `$16`. Baud = clock/16 (e.g. 1.8432 MHz gives 115200). |
| B4 | chat, 6503-6507 | "13 bit, 8 KB" for the whole group | [DS] confirmed only for the 6507 (A0-A12, 8 KB). 6503/6505 [MEMORY]: fewer lines, mark to verify. |
| B5 | chat, VIC-II registers | "`$D01E`, `$D01F`: sprite-background and sprite-sprite" | [MEMORY, certain] `$D01E` = sprite-sprite, `$D01F` = sprite-background. |
| B6 | 01-architecture.md, NES clock | "PPU 3x" | 3x only for NTSC (PAL about 3.2x). |
| B7 | chat, DMA in the 6502 | "the CPU will allow", "takes over the bus" | The NMOS 6502 has no BE input. DMA is done by stealing phi1 cycles, or with the RDY line (it halts only on reads). The 65C02/65816 (WDC) have BE. |
| B8 | BOM | "2 MHz crystal with a divider into phi1/phi2" | The 6502/6510 generate the phases from the phi0 input, no divider needed. A 1-2 MHz oscillator is enough. |
| B9 | BOM, FDC | "data converter" | The correct name: data separator (e.g. WD1691/FDC9216). The WD1770/1772 have it built in. The 179x/279x data bus is true or inverted depending on the variant (check in the datasheet of the chosen chip). |
| B10 | repositories, 01-architecture.md | "plnelson/nes: little to use"; "Fami: PPU every 3 cycles" | Both judgments are based on a quick review (3 .cs files; the pattern `% 3`). Mark "unverified". The license was not checked. |

## C. Gaps and inconsistencies in the design

1. **Incomplete BOM:** no baud clock generator for the 6850 (e.g. 1.8432 MHz), /CTS and /DCD tied to ground (with /CTS=1 TDRE is blocked, so `PutChar` will hang in an infinite loop [DS]), 12 V supply for the floppy drive, 1/2 MHz clock for the WD1793, I2C line pull-ups.
2. **Shadow logic not designed:** RAM /OE must be gated in `$F800-$FFFF` with latch=0 (otherwise a bus conflict with the ROM), ROM /OE only on reads, RAM /CS disabled in the I/O hole, the 74HC273 with /MR from /RESET and clocked by a write to `$DE00`.
3. **Address collision at `$DE00`:** the shadow latch (`shadow.s`) and the PIA 6520 (`rtc.s`, `bios-api.md`). Proposal: remove the PIA, I2C only through the controller at `$DF20`, `rtc.s` to the archive (see A3).
4. **ROM layout undefined:** the API jump table at `$F800` collides with the Reset code. A `rom.cfg` is needed: the JMP table (7 x 3 B) at `$F800`, code, vectors at `$FFFA`.
5. **Sizes:** the earlier estimate "900-1000 B" is too low. After assembly: POST 420 B, RTC bit-bang 373 B, loader 194 B, ShadowInit 29 B, RELOC 117 B + RelocAndTest 22 B, about 1155 B in total, plus the I2C API and the table, so realistically about 1.3-1.5 KB. It fits in 2 KB, but with no room for a SETUP menu. Decision: enlarge the shadow area (e.g. `$E000-$FFFF`, 8 KB).
6. **Outdated documents:** `04-memory.md` has three maps (the old RAM `$0000-$7FFF`/ROM `$8000-$FFFF`, 64 KB with shadow, NES). `decisions.md` contains the old default map next to the new one. `01-architecture.md` has a BOM and a diagram with 32 KB RAM, two "Startup sequence" sections, mentions the PIA. `bios-api.md` describes `LoadSystem` with the old loader (sector 1 -> `$0800`), not with the header. `bios-api.md` lets programs use `$00-$EF`, while with the 6510 `$00-$01` is the port (it should be `$02-$EF`).
7. **Decision status:** "6510 instead of 6502" is a user instruction, yet it is marked "to confirm". The other `.md` files are not saved in the project (only `bios-api.md`).
8. **Diagram:** it contains neither the shadow latch nor the baud generator, shows a 6502 CPU and 32 KB RAM. To redraw after the fixes.

## Proposed order of fixes
1. Facts (B1-B10) and the decision status, quick.
2. `bios.inc` (A10) and the memory map as the single source of truth.
3. Code: A1, A2, A4, A5, A7, A9, then A3/A11 (after the PIA decision).
4. Documents (C6), diagram (C8), synchronization with the design (C7).
5. Hardware: BOM and shadow logic (C1, C2).
