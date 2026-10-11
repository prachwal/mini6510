"""Commodore Plus/4 cartridge (build/plus4/mini6510-plus4.bin, CART-1 c1lo+c1hi, 32 KB) in VICE xplus4 with the ORIGINAL ROMs.
The KERNAL finds "CBM" at $8007 and calls the cartridge at reset; the BIOS takes over (RAM only, no KERNAL), MiniUnix boots
from the ROM disk. Needs PLUS4_ROMS=<dir with kernal.bin, basic.bin and 3plus1.bin (32 KB) or functionlo.bin + functionhi.bin>
(not in the repo); otherwise SKIP (exit 0)."""
import os, shutil, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / 'tools'))
CART = ROOT / 'build' / 'plus4' / 'mini6510-plus4.bin'
roms = os.environ.get('PLUS4_ROMS')
if not all(shutil.which(x) for x in ('xplus4', 'Xvfb', 'xdotool')):
    print('SKIP: xplus4, Xvfb and xdotool are required'); sys.exit(0)
if not roms or not (Path(roms) / 'kernal.bin').exists():
    print('SKIP: set PLUS4_ROMS to a directory with kernal.bin, basic.bin, 3plus1.bin'); sys.exit(0)
if not CART.exists():
    print('SKIP: build the plus4 platform first (python scripts/build.py --platform plus4)'); sys.exit(0)
import vice

res = []
def ok(name, cond): res.append((name, bool(cond))); print(('OK   ' if cond else 'FAIL ') + name)

with vice.Vice(roms=roms, machine='plus4', cart=CART) as v:
    boot = v.wait_for('(6510)\n#', 120)
    ok('POST: BIOS PLUS4 banner, TED video, timer 100 Hz', 'BIOS PLUS4 V0.1' in boot and 'OK 100 HZ' in boot and 'VIDEO   FF00            OK' in boot)
    rows = [l for l in boot.splitlines() if l.startswith('RAM ')]
    ok('POST: all RAM ranges OK', len(rows) == 3 and all(l.rstrip().endswith('OK') for l in rows))
    ok('POST: ROM disk + RAM overlay', 'OK 26KB ROM+RAM' in boot)
    ok('autostart from the cartridge (KERNAL CBM signature)', 'MiniUnix 0.1 (6510)' in boot)
    v.screenshot(ROOT / 'build' / 'plus4' / 'screen-start.png')
    sc = v.cmd('ls -l', 'BIG.TXT')
    ok('ls -l: directory and files from the ROM disk', 'BIN/' in sc and 'README.TXT' in sc)
    sc = v.cmd('cat readme.txt | upper', 'BLOKI')
    ok('pipe (| = shift + minus) cat | upper', 'MINIUNIX: PROSTY SYSTEM DLA 6510.' in sc)
    sc = v.cmd('wc big.txt', '4700')
    ok('file spanning c1lo/c1hi windows read intact (wc)', '100 4700' in sc)
    sc = v.cmd('echo kv > t.txt', '')
    sc = v.cmd('cat t.txt', 'kv')
    ok('write through the RAM overlay and read back', '# cat t.txt\nkv' in sc)
    v.cmd('mkdir d1', ''); v.cmd('cd d1', '')
    sc = v.cmd('pwd', '/D1')
    ok('mkdir / cd / pwd', '/D1' in sc)
    v.cmd('cd ..', '')
    sc = v.cmd('date', '2026-10-11')
    ok('software clock (TED timer 1) starts at 09:', '2026-10-11 09:' in sc)
    sc = v.cmd('greet Ada', 'Hello, Ada!')
    ok('/bin program from the ROM disk (argv)', 'Hello, Ada!' in sc)
    sc = v.cmd('echo Hello | rot13', 'Uryyb')
    ok('rot13 filter in a pipe', 'Uryyb' in sc)
    v.cmd('loop &', '[1]')
    sc = v.cmd('ps', 'R loop')
    ok('background task keeps running under pre-emption (TED IRQ)', '1 R loop' in sc)
    v.cmd('kill 1', '')
    sc = v.cmd('uptime', 'ticks')
    ok('uptime counts TED timer ticks', 'ticks' in sc)
    for i in range(30):
        v.type(f'echo n{i}\n')
    sc = v.wait_for('n29', 30)
    lines = sc.splitlines()
    ok('scrolling keeps rows intact', all(sum(1 for l in lines if l.strip() == f'n{i}') <= 1 for i in range(10, 30)) and '# echo n29' in sc)
    v.screenshot(ROOT / 'build' / 'plus4' / 'screen.png')

print('WYNIK:', 'OK' if all(c for _, c in res) else 'BLAD')
sys.exit(0 if all(c for _, c in res) else 1)
