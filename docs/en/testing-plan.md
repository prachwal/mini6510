# 05 - Tests (POST and RAM)

## How other systems do it (from memory, to verify)
- IBM PC: writing and reading patterns in blocks, a counter on screen. Some boards have hardware parity checking.
- Commodore (KERNAL RAMTAS, BASIC): writing and reading pages, finding the top of RAM. Not a full test.
- Amiga (Kickstart): memory in a list, expansions detected by write and read.
- Apple II, Atari, CP/M: no test, the BIOS assumes the RAM works.

## RAM test techniques
- Patterns: `$55`/`$AA` (alternating bits), `$00`/`$FF`. Detects shorts and stuck bits.
- Address line test: a unique value at an address and at addresses a power of two away. Reading from a different address means a short or a missing line in the decoder.
- Walking ones/zeros: a single bit walks through the range. Detects a stuck data line.
- Mirroring: write at an address, read at the address one RAM size away. Finds the real size.

## For our project (2x 62256, A15 decoder)
- Pattern test over the full range (excluding I/O and BIOS).
- Test of lines A0-A15, especially A15 (selecting between the two chips).
- Mirror detection, to find RAM wired wrongly to the decoder.
- Not tested in the current code: the stack `$0100-$01FF`, the port `$00-$01`.

## To confirm
- [ ] Whether to include the address line test in POST (time cost vs value).
- [ ] Whether to show the RAM size from the test in the table.
