#!/usr/bin/env python3
"""Run the C64 build in VICE (x64sc).

  python scripts/run_vice.py                       # open VICE window (needs a display) with the stand-in test ROMs
  python scripts/run_vice.py --roms ~/c64roms      # use real ROMs (kernal.bin, basic.bin, chargen.bin) + normal autostart
  python scripts/run_vice.py --headless "ls -l\\n" # headless: type keys, print the screen, save build/c64/screen.png

Disk: build/c64/disk.img is attached as a 512 KB REU image (write-protected; changes are lost on exit).
"""
import argparse, os, subprocess, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / 'tools'))
B = ROOT / 'build' / 'c64'
ap = argparse.ArgumentParser()
ap.add_argument('keys', nargs='?', help='keys to type in --headless mode (\\n = Enter)')
ap.add_argument('--roms', help='directory with real kernal.bin, basic.bin, chargen.bin')
ap.add_argument('--headless', action='store_true')
a = ap.parse_args()

if a.headless:
    import vice
    keys = (a.keys or '').encode().decode('unicode_escape')
    with vice.Vice(roms=a.roms) as v:
        v.wait_for('(6510)\n#', 120)
        v.type(keys)
        print(v.screen())
        v.screenshot(B / 'screen.png')
    sys.exit(0)

roms = Path(a.roms) if a.roms else B / 'roms'
cmd = ['x64sc', '-default', '-reu', '-reusize', '512', '-reuimage', str(B / 'disk.img'), '+reuimagerw',
       '-kernal', str(roms / 'kernal.bin'), '-basic', str(roms / 'basic.bin'), '-chargen', str(roms / 'chargen.bin')]
if a.roms:
    cmd += ['-autostart', str(B / 'mini6510.prg')]   # real KERNAL: LOAD + RUN
print(' '.join(cmd)); subprocess.run(cmd)
