"""End-to-end test of the C64 port in VICE (x64sc): boots mini6510.prg from the stand-in KERNAL, types
commands through the emulated keyboard matrix (xdotool -> VICE -> CIA1) and checks the screen RAM.
Skipped (exit 0, 'SKIP') when x64sc / Xvfb / xdotool are missing."""
import shutil, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / 'tools'))
if not all(shutil.which(x) for x in ('x64sc', 'Xvfb', 'xdotool')):
    print('SKIP: x64sc, Xvfb and xdotool are required'); sys.exit(0)
if not (ROOT / 'build' / 'c64' / 'roms' / 'kernal.bin').exists():
    print('SKIP: build the c64 platform first (python scripts/build.py --platform c64)'); sys.exit(0)
import vice

res = []
def ok(name, cond): res.append((name, bool(cond))); print(('OK   ' if cond else 'FAIL ') + name)

with vice.Vice() as v:
    boot = v.wait_for('(6510)\n#', 120)
    ok('POST table: BIOS banner', 'BIOS C64 V0.1' in boot)
    ok('POST: all RAM ranges OK, VIDEO OK', boot.count(' OK') >= 8)
    ok('POST: REU detected, 512 KB', 'OK 512 KB' in boot)
    ok('POST: timer 100 Hz', 'OK 100 HZ' in boot)
    ok('kernel boots from REU to a prompt', 'MiniUnix 0.1' in boot)

    sc = v.cmd('echo hello c64', 'hello c64\n')
    ok('echo through the keyboard matrix', '# echo hello c64\nhello c64\n#' in sc)
    sc = v.cmd('ls', 'README.TXT')
    ok('ls shows directory /BIN/ and files', 'BIN/' in sc and 'README.TXT' in sc and 'BIG.TXT' in sc)
    sc = v.cmd('cat readme.txt | upper', 'DLA 6510.')
    ok('pipe (| via shifted key) cat | upper', 'MINIUNIX: PROSTY SYSTEM DLA 6510.' in sc)
    v.cmd('echo kv > t.txt', '')
    sc = v.cmd('cat t.txt', 'kv\n')
    ok('redirect > and read back', '# cat t.txt\nkv\n' in sc)
    v.cmd('mkdir d1', '')
    v.cmd('cd d1', '')
    sc = v.cmd('pwd', '/D1')
    ok('mkdir / cd / pwd', '/D1' in sc)
    v.cmd('cd ..', '')
    sc = v.cmd('date', '2026-10-11')
    ok('date from CIA TOD + fixed date', '2026-10-11 09:' in sc)
    sc = v.cmd('ls -l', 'BIG.TXT')
    ok('ls -l shows FAT timestamps', '2026-10-11 ' in sc)

    v.type('echx'); v.type('\b'); v.type('o ok\n')
    sc = v.cmd('echo 1', '1\n') if False else v.wait_for('\nok\n', 20)
    ok('backspace (DEL key) edits the line', '# echo ok\nok\n' in sc)

    sc = v.cmd('greet Ada', 'Hello, Ada!')
    ok('example program greet (/bin lookup, argv)', 'Hello, Ada!' in sc)
    sc = v.cmd('echo Hello | rot13', 'Uryyb')
    ok('example filter rot13 in a pipe', 'Uryyb' in sc)

    # multitasking with timer-IRQ pre-emption (CIA1 timer A): a CPU-bound loop must not starve the shell
    v.cmd('loop &', '[1]')
    sc = v.cmd('ps', 'R loop')
    ok('background task keeps running under pre-emption (ps)', '1 R loop' in sc)
    sc = v.cmd('kill 1', '')
    sc = v.cmd('uptime', 'ticks')
    ok('uptime counts CIA timer ticks', 'ticks' in sc)

    # scrolling: many lines must stay intact (no duplicated rows)
    for i in range(30):
        v.type(f'echo n{i}\n')
    sc = v.wait_for('n29', 30)
    lines = sc.splitlines()
    ok('scrolling keeps rows intact', all(sum(1 for l in lines if l.strip() == f'n{i}') <= 1 for i in range(10, 30))
       and '# echo n29' in sc)
    v.screenshot(ROOT / 'build' / 'c64' / 'screen.png')

print('WYNIK:', 'OK' if all(c for _, c in res) else 'BLAD')
sys.exit(0 if all(c for _, c in res) else 1)
