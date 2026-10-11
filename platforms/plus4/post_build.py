"""Plus/4 post-build (cwd = build/plus4): bios.rom (4 KB) + disk.img (108 blocks) -> 32 KB cartridge image CART-1 (c1lo + c1hi)."""
import sys
from pathlib import Path

bios = Path('bios.rom').read_bytes()
disk = Path('disk.img').read_bytes()
assert len(bios) == 0x1000, f'BIOS image must be 4096 B, is {len(bios)}'
SPLIT, BLOCKS = 48, 108
assert len(disk) == BLOCKS * 256, f'disk image must be {BLOCKS} blocks'
lo = bios + disk[:SPLIT * 256]                      # $8000-$8FFF BIOS, $9000-$BFFF blocks 0..47
hi = disk[SPLIT * 256:]                             # $C000-$FBFF blocks 48..107
lo = lo.ljust(0x4000, b'\xFF'); hi = hi.ljust(0x4000, b'\xFF')
Path('c1lo.bin').write_bytes(lo); Path('c1hi.bin').write_bytes(hi)
Path('mini6510-plus4.bin').write_bytes(lo + hi)
print('Plus/4: mini6510-plus4.bin', len(lo + hi), 'B (c1lo + c1hi), disk', BLOCKS, 'blocks')
