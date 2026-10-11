"""C64 post-build (cwd = build/c64): bios.rom is the PRG; produce mini6510.prg and VICE test ROMs."""
import os, shutil, subprocess, sys
from pathlib import Path

root = Path(os.environ['ROOT']); here = root / 'platforms' / 'c64'
shutil.copy('bios.rom', 'mini6510.prg')
# 1541 disk (.d64, 683 blocks) with the same system, used when a drive on IEC unit 8 holds it
subprocess.run([sys.executable, str(root / 'tools' / 'mkdisk.py')], check=True,
               env=dict(os.environ, DISK_NAME='drive.d64', DISK_BLOCKS='683'), stdout=subprocess.DEVNULL)
rom = Path('roms'); rom.mkdir(exist_ok=True)
subprocess.run([os.environ['CA65'], '-I', '.', str(here / 'test' / 'testkernal.s'), '-o', 'testkernal.o'], check=True)
subprocess.run([os.environ['LD65'], '-C', str(here / 'test' / 'testkernal.cfg'), '-o', str(rom / 'kernal.bin'), 'testkernal.o'], check=True)
(rom / 'basic.bin').write_bytes(bytes(8192))

# character ROM in C64 screen-code layout (set 2: lower/upper case), codes 128..255 inverted
font = (here / 'test' / 'font8x8.bin').read_bytes()
def ascii_of(code):
    if code == 0: return ord('@')
    if 1 <= code <= 26: return ord('a') + code - 1
    if 27 <= code <= 31: return ord('[\\]^_'[code - 27])
    if 32 <= code <= 63: return code
    if 65 <= code <= 90: return code
    return {91: ord('{'), 93: ord('|'), 94: ord('}'), 95: ord('~')}.get(code)
half = bytearray()
for code in range(128):
    a = ascii_of(code)
    half += font[a * 8:a * 8 + 8] if a is not None else bytes(8)
half += bytes(b ^ 0xFF for b in half)          # reverse video (codes 128..255)
(rom / 'chargen.bin').write_bytes(bytes(half) * 2)
print('C64: mini6510.prg', os.path.getsize('mini6510.prg'), 'B; test ROMs in build/c64/roms')


# --- cartridge Magic Desk: bank 0 = boot + BIOS, banks 1..15 = disk image (480 blocks, read-only ROM) ---
inc = ['-I', str(root / 'bios'), '-I', str(here), '-I', str(root / 'os')]
objs = []
srcs = [here / 'bios.s', here / 'blk_reu.s', here / 'cart' / 'blk_cart.s', here / 'cart' / 'stub_cart.s',
        root / 'bios' / 'loader.s', root / 'bios' / 'common.s', root / 'bios' / 'iec.s', root / 'bios' / 'drive.s']
for src in srcs:
    o = f'cart_{src.stem}.o'
    subprocess.run([os.environ['CA65'], '-D', 'CART', *inc, str(src), '-o', o], check=True)
    objs.append(o)
subprocess.run([os.environ['LD65'], '-C', str(here / 'cart' / 'bios_cart.cfg'), '-o', 'cart_bank0.bin', *objs,
                '-m', 'cart.map'], check=True)
subprocess.run([sys.executable, str(root / 'tools' / 'mkdisk.py')], check=True,
               env=dict(os.environ, DISK_NAME='cart_disk.img', DISK_BLOCKS='480'), stdout=subprocess.DEVNULL)
subprocess.run([sys.executable, str(root / 'tools' / 'mkcart.py'), 'cart_bank0.bin', 'cart_disk.img', 'mini6510.crt'], check=True)
