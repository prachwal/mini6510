"""C64 + true 1541-II (IEC, bit-banged by the BIOS, no KERNAL) in VICE x64sc with the ORIGINAL ROMs: MiniUnix boots from a
.d64 (build/c64/drive.d64, 683 blocks) started as a PRG (no REU) or from the Magic Desk cartridge; writes land in the image.
Needs C64_ROMS=<dir with kernal.bin, basic.bin, chargen.bin, dos1541.bin>; otherwise SKIP (exit 0)."""
import os, shutil, sys, tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / 'tools'))
D64 = ROOT / 'build' / 'c64' / 'drive.d64'
CRT = ROOT / 'build' / 'c64' / 'mini6510.crt'
roms = os.environ.get('C64_ROMS')
if not all(shutil.which(x) for x in ('x64sc', 'Xvfb', 'xdotool')):
    print('SKIP: x64sc, Xvfb and xdotool are required'); sys.exit(0)
if not roms or not (Path(roms) / 'dos1541.bin').exists():
    print('SKIP: set C64_ROMS to a directory with kernal.bin, basic.bin, chargen.bin and dos1541.bin'); sys.exit(0)
if not D64.exists() or not CRT.exists():
    print('SKIP: build the c64 platform first (python scripts/build.py --platform c64)'); sys.exit(0)
import vice
from sfs import Disk

res = []
def ok(name, cond): res.append((name, bool(cond))); print(('OK   ' if cond else 'FAIL ') + name)

for label, cart in (("cartridge", CRT),):
    work = Path(tempfile.mkdtemp()) / 'work.d64'
    shutil.copy(D64, work)                       # never mutate the built image
    with vice.Vice(roms=roms, cart=cart, reu=False, d64=work) as v:
        boot = v.wait_for('(6510)\n#', 300)
        ok(f'{label}: POST finds the drive (IEC unit 8)', 'OK IEC 8' in boot)
        ok(f'{label}: MiniUnix booted from the 1541 disk', 'MiniUnix 0.1 (6510)' in boot)
        sc = v.cmd('ls -l', 'BIG.TXT', 120)
        ok(f'{label}: ls reads the .d64 (U1)', 'README.TXT' in sc and 'BIN/' in sc)
        sc = v.cmd('wc big.txt', '4700', 120)
        ok(f'{label}: multi-block file intact (wc)', '100 4700' in sc)
        v.cmd('echo from-1541 > drv.txt', '', 120)
        sc = v.cmd('cat drv.txt', 'from-1541', 120)
        ok(f'{label}: write and read back (U2/U1)', '# cat drv.txt\nfrom-1541' in sc)
    d = Disk(str(work))
    ok(f'{label}: data really landed in the .d64 image', b'from-1541' in bytes(d.d))
print('WYNIK:', 'OK' if all(c for _, c in res) else 'BLAD')
sys.exit(0 if all(c for _, c in res) else 1)
