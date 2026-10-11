#!/usr/bin/env python3
"""Build BIOS ROM, MiniUnix kernel, programs and a bootable disk image into ./build.

Requires the cc65 toolchain (ca65/ld65) in PATH or CC65_HOME pointing at its root.
Usage: python scripts/build.py [--clean]
"""
import glob, os, shutil, subprocess, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
BUILD = ROOT / 'build'


def tool(name):
    home = os.environ.get('CC65_HOME')
    if home and (Path(home) / 'bin' / name).exists():
        return str(Path(home) / 'bin' / name)
    p = shutil.which(name)
    if not p:
        sys.exit(f"error: '{name}' not found. Install cc65 (apt install cc65 / brew install cc65) "
                 "or set CC65_HOME.")
    return p


def run(*cmd, cwd=BUILD):
    subprocess.run([str(c) for c in cmd], cwd=cwd, check=True)


def main():
    if '--clean' in sys.argv and BUILD.exists():
        shutil.rmtree(BUILD)
    BUILD.mkdir(exist_ok=True)
    ca65, ld65 = tool('ca65'), tool('ld65')
    py = sys.executable

    # --- BIOS (POST + loader) ---
    for s in ('bios', 'loader'):
        run(ca65, '-I', ROOT / 'bios', ROOT / 'bios' / f'{s}.s', '-o', f'{s}.o')
    run(ld65, '-C', ROOT / 'bios' / 'bios.cfg', '-o', 'bios.rom', 'bios.o', 'loader.o', '-m', 'bios.map')

    # --- kernel ---
    run(ca65, '-I', ROOT / 'os', '-I', ROOT / 'bios', ROOT / 'os' / 'kernel.s', '-o', 'kernel.o')
    run(ld65, '-C', ROOT / 'os' / 'kernel.cfg', '-o', 'kernel.bin', 'kernel.o', '-Ln', 'k.lbl')
    for line in (BUILD / 'k.lbl').read_text().splitlines():
        if line.endswith('.Kstart'):
            (BUILD / 'entry.txt').write_text(line.split()[1][2:] + '\n')

    # --- programs: relocatable .COM built twice (bases $4008 / $7008), diff gives relocations ---
    sources = sorted(glob.glob(str(ROOT / 'os' / 'programs' / '*.s')) +
                     glob.glob(str(ROOT / 'examples' / 'programs' / '*.s')))
    for src in sources:
        n = Path(src).stem
        run(ca65, '-I', ROOT / 'os', src, '-o', f'{n}.o')
        run(ld65, '-C', ROOT / 'os' / 'prog.cfg', '-o', f'{n}.a', f'{n}.o', '-Ln', f'{n}.lbl')
        run(ld65, '-C', ROOT / 'os' / 'prog2.cfg', '-o', f'{n}.b', f'{n}.o')
        run(py, ROOT / 'tools' / 'mkcom.py', f'{n}.a', f'{n}.b', f'{n}.lbl', f'{n}.com')

    # --- disk image ---
    env = dict(os.environ, PYTHONPATH=str(ROOT / 'tools'))
    subprocess.run([py, str(ROOT / 'tools' / 'mkdisk.py')], cwd=BUILD, check=True, env=env)
    print(f"\nOK: {BUILD}/bios.rom ({(BUILD/'bios.rom').stat().st_size} B), "
          f"kernel.bin ({(BUILD/'kernel.bin').stat().st_size} B), disk.img")


if __name__ == '__main__':
    main()
