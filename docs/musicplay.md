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
