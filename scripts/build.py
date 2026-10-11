#!/usr/bin/env python3
"""Build BIOS ROM, MiniUnix kernel, programs and a bootable disk image into ./build.

Requires the cc65 toolchain (ca65/ld65) in PATH or CC65_HOME pointing at its root.
Usage: python scripts/build.py [--platform generic|c64] [--clean]
"""
import glob, os, re, shutil, subprocess, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
PLATFORM = 'generic'
BUILD = ROOT / 'build' / PLATFORM


def tool(name):
    home = os.environ.get('CC65_HOME')
    if home and (Path(home) / 'bin' / name).exists():
        return str(Path(home) / 'bin' / name)
    p = shutil.which(name)
    if not p:
        sys.exit(f"error: '{name}' not found. Install cc65 (apt install cc65 / brew install cc65) "
                 "or set CC65_HOME.")
    return p


def run(*cmd, cwd=None):
    subprocess.run([str(c) for c in cmd], cwd=cwd or BUILD, check=True)


def consts(path):
    out = {}
    for line in Path(path).read_text().splitlines():
        m = re.match(r'^(\w+)\s*=\s*\$([0-9A-Fa-f]+)', line)
        if m:
            out[m.group(1)] = int(m.group(2), 16)
            continue
        m = re.match(r'^(\w+)\s*=\s*([0-9]+)\b', line)
        if m:
            out[m.group(1)] = int(m.group(2))
    return out


def main():
    global BUILD
    plat = 'generic'
    if '--platform' in sys.argv:
        plat = sys.argv[sys.argv.index('--platform') + 1]
    P = ROOT / 'platforms' / plat
    BUILD = ROOT / 'build' / plat
    if '--clean' in sys.argv and BUILD.exists():
        shutil.rmtree(BUILD)
    BUILD.mkdir(parents=True, exist_ok=True)
    ca65, ld65 = tool('ca65'), tool('ld65')
    py = sys.executable
    pc = consts(P / 'platform.inc')
    inc = ['-I', ROOT / 'bios', '-I', P, '-I', ROOT / 'os']

    # --- BIOS (platform code + shared loader) ---
    objs = []
    for src in sorted(P.glob('*.s')) + [ROOT / 'bios' / 'loader.s', ROOT / 'bios' / 'common.s']:
        o = f'bios_{src.stem}.o'
        run(ca65, *inc, src, '-o', o)
        objs.append(o)
    run(ld65, '-C', P / 'bios.cfg', '-o', 'bios.rom', *objs, '-m', 'bios.map')

    # --- kernel: loaded at KBASE, must end below its data area (DB + $1A0) ---
    size = pc['DB'] + 0x1A0 - pc['KBASE']
    (BUILD / 'kernel.cfg').write_text('MEMORY { KRN: start=$%04X, size=$%04X, file=%%O; }\n'
                                      'SEGMENTS { CODE: load=KRN, type=ro; }\n' % (pc['KBASE'], size))
    run(ca65, *inc, ROOT / 'os' / 'kernel.s', '-o', 'kernel.o')
    run(ld65, '-C', 'kernel.cfg', '-o', 'kernel.bin', 'kernel.o', '-Ln', 'k.lbl')
    for line in (BUILD / 'k.lbl').read_text().splitlines():
        if line.endswith('.Kstart'):
            (BUILD / 'entry.txt').write_text(line.split()[1][2:] + '\n')

    # --- programs: relocatable .COM built twice (bases $4008 / $7008), diff gives relocations ---
    sources = sorted(glob.glob(str(ROOT / 'os' / 'programs' / '*.s')) +
                     glob.glob(str(ROOT / 'examples' / 'programs' / '*.s')))
    for src in sources:
        n = Path(src).stem
        run(ca65, *inc, src, '-o', f'{n}.o')
        run(ld65, '-C', ROOT / 'os' / 'prog.cfg', '-o', f'{n}.a', f'{n}.o', '-Ln', f'{n}.lbl')
        run(ld65, '-C', ROOT / 'os' / 'prog2.cfg', '-o', f'{n}.b', f'{n}.o')
        run(py, ROOT / 'tools' / 'mkcom.py', f'{n}.a', f'{n}.b', f'{n}.lbl', f'{n}.com')

    # --- disk image ---
    env = dict(os.environ, PYTHONPATH=str(ROOT / 'tools'), KBASE=str(pc['KBASE']))
    if 'DISK_BLOCKS' in pc:
        env['DISK_BLOCKS'] = str(pc['DISK_BLOCKS'])
    subprocess.run([py, str(ROOT / 'tools' / 'mkdisk.py')], cwd=BUILD, check=True, env=env)
    if (P / 'post_build.py').exists():
        subprocess.run([py, str(P / 'post_build.py')], cwd=BUILD, check=True,
                       env=dict(env, ROOT=str(ROOT), CA65=ca65, LD65=ld65))
    print(f"\nOK [{plat}]: {BUILD}/bios.rom ({(BUILD/'bios.rom').stat().st_size} B), "
          f"kernel.bin ({(BUILD/'kernel.bin').stat().st_size} B), disk.img")


if __name__ == '__main__':
    main()
