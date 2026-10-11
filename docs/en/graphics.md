# Common graphics BIOS (design)

Status: **design only**. Goal (confirmed by the user, 2026-10-11): one graphics interface in the BIOS shared by all machines, not pretty,
only shared. Programs ask for the size and adapt. Anything beyond the contract (sprites, scrolling, effects) stays machine-specific.

## Contract (BIOS calls, all optional, C=1 = not supported)
| Call | In | Out / effect |
|---|---|---|
| `GfxCaps` | - | X/Y = width/height in pixels (16 bit each in `ptr`/`ptr2`), A = colors (1 = mono, 4, 16), flags: bit 0 bitmap, bit 1 tiles only |
| `GfxMode` | A = 1 enter graphics, 0 back to text | switches the video mode, remembers the text screen |
| `Clear` | A = color | fills the screen |
| `Plot` | X/Y = x, y (low bytes, high in `ptr`), A = color | sets one pixel; out of range is ignored |
| `Fill` | rectangle in `ptr`, A = color | filled rectangle (fast path, byte-aligned) |
| `Line` | two points in `ptr`, A = color | Bresenham on top of `Plot` (optional) |
Logical colors 0..n-1 are mapped by the platform to its palette (C64/Plus/4: per-block colors are approximated: foreground = logical color, background = 0).
Machines without a bitmap (PET, 16 KB XIP with no room for 8 KB) report `GfxCaps` C=1 or "tiles only"; the program falls back to the text console.

## Applications
Read `GfxCaps`, then lay out in **cells** (size / 8) instead of fixed pixels; scale with shifts and tables (no multiply/divide on 6502).

## Platform notes
- C64: VIC-II bitmap 320x200, 2 colors per 8x8 cell; bitmap and color memory placed outside text screen, BIOS and program slots (documented in the memory map).
- Plus/4: TED bitmap 320x200, same cell color rule.
- Later: Atari (ANTIC display list), Apple II (interleaved hi-res), PET (none).

## Size
Per platform about 300-600 B: split into packages (`gfxm` mode+clear, `gfxp` plot+fill+line) to respect the 1-block package limit,
or keep built into the BIOS where there is room.

## Test
VICE screenshot of a demo (border, diagonal, filled rectangle) on C64 and Plus/4, compared with a reference image.
