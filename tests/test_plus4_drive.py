"""Commodore Plus/4 + true 1551 drive (TCBM) in VICE xplus4: the cartridge BIOS finds the drive, boots MiniUnix from a
.d64 (build/plus4/drive.d64, 683 blocks) and writes go to the disk image (U2). Needs PLUS4_ROMS=<dir with kernal.bin,
basic.bin, 3plus1.bin (or functionlo/functionhi) and dos1551.bin>; otherwise SKIP (exit 0)."""
import os, shutil, sys, tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / 'tools'))
CART = ROOT / 'build' / 'plus4' / 'mini6510-plus4.bin'
D64 = ROOT / 'build' / 'plus4' / 'drive.d64'
roms = os.environ.get('PLUS4_ROMS')
if not all(shutil.which(x) for x in ('xplus4', 'Xvfb', 'xdotool')):
    print('SKIP: xplus4, Xvfb and xdotool are required'); sys.exit(0)
if not roms or not (Path(roms) / 'dos1551.bin').exists():
    print('SKIP: set PLUS4_ROMS to a directory with kernal.bin, basic.bin, 3plus1.bin and dos1551.bin'); sys.exit(0)
if not CART.exists() or not D64.exists():
    print('SKIP: build the plus4 platform first (python scripts/build.py --platform plus4)'); sys.exit(0)
import vice
from sfs import Disk

res = []
def ok(name, cond): res.append((name, bool(cond))); print(('OK   ' if cond else 'FAIL ') + name)

work = Path(tempfile.mkdtemp()) / 'work.d64'
shutil.copy(D64, work)                       # never mutate the committed/built image
with vice.Vice(roms=roms, machine='plus4', cart=CART, d64=work) as v:
    boot = v.wait_for('(6510)\n#', 300)
    ok('POST: drive found on TCBM (1551)', 'OK 1551 TCBM 8' in boot)
    ok('MiniUnix booted from the disk in the drive', 'MiniUnix 0.1 (6510)' in boot)
    sc = v.cmd('ls -l', 'BIG.TXT', 120)
    ok('ls: files read from the .d64 (U1)', 'README.TXT' in sc and 'BIN/' in sc)
    sc = v.cmd('wc big.txt', '4700', 120)
    ok('multi-block file read intact (wc)', '100 4700' in sc)
    v.cmd('echo from-1551 > drv.txt', '', 120)
    sc = v.cmd('cat drv.txt', 'from-1551', 120)
    ok('write and read back through the drive (U2/U1)', '# cat drv.txt\nfrom-1551' in sc)
d = Disk(str(work))
ok('data really landed in the .d64 image', b'from-1551' in bytes(d.d))
print('WYNIK:', 'OK' if all(c for _, c in res) else 'BLAD')
sys.exit(0 if all(c for _, c in res) else 1)
