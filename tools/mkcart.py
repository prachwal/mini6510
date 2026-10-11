#!/usr/bin/env python3
"""mkcart.py BANK0.bin DISK.img OUT.crt - Magic Desk (CRT type 19) from boot bank + ROM disk image.

Bank 0 (8 KB) = boot + BIOS, banks 1.. = disk blocks (32 blocks of 256 B per bank).
The total must be a power of two number of banks (Magic Desk: 8 KB .. 512 KB); the image is padded with $FF.
Needs `cartconv` (VICE).
"""
import shutil, subprocess, sys, tempfile
from pathlib import Path

bank0, disk, out = (Path(a) for a in sys.argv[1:4])
b0 = bank0.read_bytes(); d = disk.read_bytes()
assert len(b0) == 8192, 'bank 0 must be exactly 8 KB'
d += bytes(-len(d) % 8192)
img = b0 + d
banks = len(img) // 8192
assert banks & (banks - 1) == 0 and banks <= 64, f'{banks} banks: need a power of two <= 64'
cc = shutil.which('cartconv')
if not cc: sys.exit('error: cartconv (VICE) not found')
with tempfile.TemporaryDirectory() as t:
    raw = Path(t) / 'cart.bin'; raw.write_bytes(img)
    subprocess.run([cc, '-q', '-t', 'md', '-i', str(raw), '-o', str(out), '-n', 'MiniUnix 6510'], check=True)
print(f'{out}: Magic Desk, {banks} banks ({len(img)//1024} KB)')
