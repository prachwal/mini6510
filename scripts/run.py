#!/usr/bin/env python3
"""Boot the built disk in the Python machine model, type some keys and print the screen.

Usage: python scripts/run.py "ls\\rcat readme.txt\\r"        (\\r = Enter, \\b = Backspace)
       python scripts/run.py --file commands.txt [--cycles 5000000]
"""
import argparse, os, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
BUILD = ROOT / 'build' / 'generic'
for d in ('sim', 'tools'):
    sys.path.insert(0, str(ROOT / d))
os.chdir(BUILD)
from oslib import session  # noqa: E402

ap = argparse.ArgumentParser()
ap.add_argument('keys', nargs='?', default='ver\r')
ap.add_argument('--file', help='read keystrokes from a file (newline -> Enter)')
ap.add_argument('--cycles', type=int, default=3_000_000, help='extra CPU cycles to run after the last key')
ap.add_argument('--save', help='write the resulting disk image here')
a = ap.parse_args()
keys = open(a.file).read().replace('\n', '\r') if a.file else a.keys.encode().decode('unicode_escape')
img, screen = session(open('disk.img', 'rb').read(), keys, extra=a.cycles)
print(screen)
if a.save:
    open(a.save, 'wb').write(img)
