# musicplay (Atari, SAP files) - design

Status: **idea** (needs the Atari platform first, which is not started). Command: `musicplay file.sap [song]`.

## SAP format (to confirm against the format description)
Text header (lines ending CR LF): `SAP`, `AUTHOR`, `NAME`, `DATE`, `SONGS`, `DEFSONG`, `TYPE` (B, C, ...), `INIT` (hex), `PLAYER` (hex),
`MUSIC` (hex, type C), `FASTPLAY` (scanlines per call), `STEREO`. Then binary blocks: marker `$FFFF`, then blocks of `start end data` (little endian).
Type B (first target): `INIT` called with A = song number, `PLAYER` called once per frame (default 312 lines = 50 Hz PAL, `FASTPLAY` changes the rate).
Other types (C = CMC player, D = digi, S) are later.

## Player
1. Read the file through the VFS to a buffer; parse the header (text lines, hex fields).
2. Load every binary block at its own address; check that no block overlaps the kernel, BIOS or the player. Out of range = error.
3. `TickSet` to the frame rate (50/60 Hz or `FASTPLAY`), install the tick callback: it calls `PLAYER` each tick.
4. Call `INIT` with A = song, start the tick, read the keyboard (`KeyGet`): space pause, `+`/`-` song, `q` quit.
5. On quit: stop the tick, silence POKEY (`AUDCx = 0`), restore memory state.

## BIOS requirements
`TickSet hz` and a tick callback; `KeyGet`; file read; load addresses must be free of system memory (memory map of the Atari port, tunes often use `$0600` and `$3000+`);
POKEY and music code run on the same interrupt, so the tick must not collide with the tune's own interrupt use (RSID-like tunes are out).

## Open
Which SAP types to support first (default B), memory conflict handling (default: refuse), conversion `.sid` to `.sap` offline (separate tool, not in the OS).

# musicplay (C64, SID files) - design

Status: **idea**, the first candidate after 0.2 because the C64 platform already exists. Command: `musicplay file.sid [song]`.

## PSID format (to confirm against the format description)
Header (big endian): magic `PSID`/`RSID`, version, data offset (`$76` for v2), load address (0 = first two data bytes, little endian), `init`, `play`
(0 = `init` installs its own interrupt), songs, start song, speed (bit per song: 0 = frame rate 50/60 Hz, 1 = CIA timer 60 Hz), name/author/released (32 B each),
v2+: flags (clock PAL/NTSC, SID model), start page, page length. Then the data: the 6502 code and music.
PSID tunes run in a prepared environment (ROMs/IO mapped by a known scheme); RSID needs a real C64 environment (CIA IRQ, KERNAL).

## Player
1. Read the file via the VFS, check the header and that `load..load+length` does not overlap the kernel, BIOS or the player. Overlap = error.
2. Copy the music to its load address; set the interrupt rate (`TickSet 50/60 Hz`, or the CIA value for speed bit 1).
3. `init` with A = song number; each tick calls `play` (or leaves the tune's own interrupt, `play = 0`).
4. Keys (`KeyGet`): space pause, `+`/`-` song, `q` quit: stop the tick, clear SID (`$D404/$D40B/$D412 = 0`, volume 0), return to the shell.
5. Show name, author and song number (header fields).

## Limits
- RSID/CIA-dependent tunes: start with PSID only, RSID later through `run` (a reset-like environment, reset = exit).
- Tunes loading over the system area (`$A000+` slots, BIOS `$F800+`): refused; common `$1000` loads must be checked against the C64 memory map first.
- The tick must support 50/60 Hz (PAL/NTSC from the header flags) and a CIA-timed mode.
- Test in VICE: record the SID register writes (monitor trace) or the sound output to a file and compare with a reference.
