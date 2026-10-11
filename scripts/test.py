#!/usr/bin/env python3
"""Build (unless --no-build) and run all test suites against the Python machine model.

Usage: python scripts/test.py [--no-build] [name ...]     e.g.  python scripts/test.py dir mt
Each suite runs with ./build/generic as the working directory (they read bios.rom, kernel.bin, disk.img).
"""
import os, re, subprocess, sys, time
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
BUILD = ROOT / 'build' / 'generic'
# (label, script, success marker regex)
SUITES = [
    ('post',    ROOT / 'sim' / 'harness.py',    r'WYNIK: WSZYSTKO OK'),
    ('os',      ROOT / 'tests' / 'test_os.py',      r'WYNIK: OK'),
    ('min',     ROOT / 'tests' / 'test_min.py',     r'WYNIK: OK'),
    ('mgmt',    ROOT / 'tests' / 'test_mgmt.py',    r'WYNIK: OK'),
    ('space',   ROOT / 'tests' / 'test_space.py',   r'WYNIK: OK'),
    ('redir',   ROOT / 'tests' / 'test_redir.py',   r'WYNIK: OK'),
    ('mt',      ROOT / 'tests' / 'test_mt.py',      r'WYNIK: OK'),
    ('preempt', ROOT / 'tests' / 'test_preempt.py', r'WYNIK: OK'),
    ('big',     ROOT / 'tests' / 'test_big.py',     r'BIG zgodny: True[\s\S]*EXACT zgodny: True'),
    ('dir',     ROOT / 'tests' / 'test_dir.py',     r'WYNIK: OK'),
    ('examples', ROOT / 'tests' / 'test_examples.py', r'WYNIK: OK'),
    ('c64-vice', ROOT / 'tests' / 'test_c64_vice.py', r'WYNIK: OK|SKIP'),   # needs x64sc + Xvfb + xdotool
    ('c64-cart', ROOT / 'tests' / 'test_c64_cart.py', r'WYNIK: OK|SKIP'),   # needs C64_ROMS (original ROMs)
]


def main():
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    if '--no-build' not in sys.argv:
        for plat in ('generic', 'c64'):
            subprocess.run([sys.executable, str(ROOT / 'scripts' / 'build.py'), '--platform', plat],
                           check=True, stdout=subprocess.DEVNULL)
    env = dict(os.environ, PYTHONPATH=os.pathsep.join(str(ROOT / d) for d in ('sim', 'tools', 'tests')))
    failed = []
    for name, script, marker in SUITES:
        if args and name not in args:
            continue
        t = time.time()
        r = subprocess.run([sys.executable, str(script)], cwd=BUILD, env=env, capture_output=True, text=True)
        out = r.stdout + r.stderr
        ok = r.returncode == 0 and re.search(marker, out) and not re.search(r'^FAIL', out, re.M)
        print(f"{'PASS' if ok else 'FAIL'}  {name:<9} {time.time() - t:5.1f}s")
        if not ok:
            failed.append(name)
            print('\n'.join('    ' + l for l in out.splitlines()[-25:]))
    print('\nALL PASSED' if not failed else f"\nFAILED: {', '.join(failed)}")
    sys.exit(1 if failed else 0)


if __name__ == '__main__':
    main()
