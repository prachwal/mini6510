"""Magic Desk cartridge (build/c64/mini6510.crt) in VICE x64sc with the ORIGINAL C64 ROMs.
Checks full boot from the cartridge: with a REU (ROM disk copied to REU, writable) and without (read-only ROM disk).
Needs C64_ROMS=<dir with kernal.bin, basic.bin, chargen.bin> (not in the repo); otherwise SKIP (exit 0)."""
import os, shutil, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / 'tools'))
CRT = ROOT / 'build' / 'c64' / 'mini6510.crt'
roms = os.environ.get('C64_ROMS')
if not all(shutil.which(x) for x in ('x64sc', 'Xvfb', 'xdotool')):
    print('SKIP: x64sc, Xvfb and xdotool are required'); sys.exit(0)
if not roms or not (Path(roms) / 'kernal.bin').exists():
    print('SKIP: set C64_ROMS to a directory with kernal.bin, basic.bin, chargen.bin'); sys.exit(0)
if not CRT.exists():
    print('SKIP: build the c64 platform first (python scripts/build.py --platform c64)'); sys.exit(0)
import vice

res = []
def ok(name, cond): res.append((name, bool(cond))); print(('OK   ' if cond else 'FAIL ') + name)

# 1) cartridge + REU: the 120 KB ROM disk is copied to the REU, the disk is writable
with vice.Vice(roms=roms, cart=CRT, reu=True) as v:
    boot = v.wait_for('(6510)\n#', 120)
    ok('cart+REU: POST shows ROM copied to REU', 'OK 512 KB +ROM' in boot)
    ok('cart+REU: system booted from the cartridge', 'MiniUnix 0.1 (6510)' in boot)
    sc = v.cmd('ls -l', 'BIG.TXT')
    ok('cart+REU: ls shows files from the ROM disk', 'README.TXT' in sc and 'BIN/' in sc)
    sc = v.cmd('echo kv > t.txt', '')
    sc = v.cmd('cat t.txt', 'kv')
    ok('cart+REU: write and read back (writable via REU)', '# cat t.txt\nkv' in sc)
    sc = v.cmd('echo Hello | rot13', 'Uryyb')
    ok('cart+REU: program from the ROM disk in a pipe', 'Uryyb' in sc)
    sc = v.cmd('df', 'total 480')
    ok('cart+REU: df reports 480 blocks', 'total 480' in sc)
    v.screenshot(ROOT / 'build' / 'c64' / 'screen-cart.png')

# 2) cartridge without REU: read-only ROM disk
with vice.Vice(roms=roms, cart=CRT, reu=False) as v:
    boot = v.wait_for('(6510)\n#', 120)
    ok('cart only: POST shows read-only ROM disk', 'OK RO 120 KB ROM' in boot)
    sc = v.cmd('cat readme.txt', 'MiniUnix')
    ok('cart only: cat reads a file from ROM banks', 'MiniUnix' in sc or 'MINIUNIX' in sc.upper())
    sc = v.cmd('greet Ada', 'Hello, Ada!')
    ok('cart only: runs /bin program from ROM', 'Hello, Ada!' in sc)
    sc = v.cmd('echo x > w.txt', 'error')
    ok('cart only: write is refused (I/O error)', 'I/O error' in sc)
    v.cmd('loop &', '[1]')
    sc = v.cmd('ps', 'R loop')
    ok('cart only: pre-emptive multitasking works while the cartridge is banked', '1 R loop' in sc)
    v.cmd('kill 1', '')
    v.screenshot(ROOT / 'build' / 'c64' / 'screen-cart-ro.png')

print('WYNIK:', 'OK' if all(c for _, c in res) else 'BLAD')
sys.exit(0 if all(c for _, c in res) else 1)
