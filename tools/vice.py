"""Drive VICE (x64sc) headless: Xvfb + xdotool for keystrokes, VICE remote monitor for screen text/screenshots.

Used by tests/c64_vice.py and scripts/run_vice.py. Needs: x64sc, Xvfb, xdotool.
"""
import os, shutil, socket, subprocess, time
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
BUILD = ROOT / 'build' / 'c64'


def screen_char(code):
    """C64 screen code (lower/upper set) -> ASCII, matching the BIOS AsciiToScr table."""
    code &= 0x7F
    if code == 0: return '@'
    if code <= 26: return chr(ord('a') + code - 1)
    if code <= 31: return '[\\]^_'[code - 27]
    if 32 <= code <= 63 or 65 <= code <= 90: return chr(code)
    return {91: '{', 93: '|', 94: '}', 95: '~'}.get(code, ' ')


class Vice:
    def __init__(self, roms=None, disk=None, display=':77', port=6510, warp=True, cart=None, reu=True, extra=(), machine='c64'):
        self.display, self.port, self.machine = display, port, machine
        self.scr_base = 0x0C00 if machine == 'plus4' else 0x0400
        self.roms = Path(roms or os.environ.get('PLUS4_ROMS' if machine == 'plus4' else 'C64_ROMS') or BUILD / 'roms')
        self.disk = Path(disk) if disk else BUILD / 'disk.img'
        self.env = dict(os.environ, DISPLAY=display)
        self.xvfb = subprocess.Popen(['Xvfb', display, '-screen', '0', '800x600x24'],
                                     stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        time.sleep(0.5)
        real = (self.roms / 'kernal.bin').exists()
        if machine == 'plus4' and real and not (self.roms / 'functionlo.bin').exists():
            # a combined 32 KB 3-plus-1 image is split into the function ROM halves VICE wants
            src = (self.roms / '3plus1.bin').read_bytes()
            tmp = ROOT / 'build' / 'plus4' / 'vice-roms'; tmp.mkdir(parents=True, exist_ok=True)
            for n in ('kernal.bin', 'basic.bin'): shutil.copy(self.roms / n, tmp / n)
            (tmp / 'functionlo.bin').write_bytes(src[:16384]); (tmp / 'functionhi.bin').write_bytes(src[16384:])
            self.roms = tmp
        args = ['xplus4' if machine == 'plus4' else 'x64sc', '-default', '+sound', '-sounddev', 'dummy', '-remotemonitor',
                '-remotemonitoraddress', f'ip4://127.0.0.1:{port}',
                ]
        if machine == 'plus4':
            reu = False
        if reu:
            args += ['-reu', '-reusize', '512']
            if not cart: args += ['-reuimage', str(self.disk), '+reuimagerw']   # cartridge boot: REU starts empty
        if real and machine == 'plus4':
            args += ['-kernal', str(self.roms / 'kernal.bin'), '-basic', str(self.roms / 'basic.bin'),
                     '-functionlo', str(self.roms / 'functionlo.bin'), '-functionhi', str(self.roms / 'functionhi.bin')]
            if cart:
                args += ['-cart', str(cart)]      # 32 KB raw image = CART-1 lo + hi (smart attach)
        elif real:
            args += ['-kernal', str(self.roms / 'kernal.bin'), '-basic', str(self.roms / 'basic.bin'),
                     '-chargen', str(self.roms / 'chargen.bin'),
                     ]
            args += ['-cartcrt', str(cart)] if cart else ['-autostart', str(BUILD / 'mini6510.prg'), '-autostartprgmode', '1']
        args += list(extra)
        if warp: args.append('-warp')
        self.proc = subprocess.Popen(args, env=self.env, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        self.sock = None
        for _ in range(100):
            try:
                self.sock = socket.create_connection(('127.0.0.1', port), timeout=2); break
            except OSError:
                time.sleep(0.2)
        if not self.sock: raise RuntimeError('VICE remote monitor did not come up')
        time.sleep(0.5)
        subprocess.run(['xdotool', 'mousemove', '100', '100'], env=self.env)

    def _read(self):
        self.sock.settimeout(0.4); out = b''
        try:
            while True:
                d = self.sock.recv(1 << 16)
                if not d: break
                out += d
        except Exception:
            pass
        return out.decode(errors='replace')

    def mon(self, command, wait=0.6, resume=True):
        """Run a monitor command (the machine stops while the monitor is active, so resume with 'x')."""
        self.sock.sendall((command + '\n').encode()); time.sleep(wait)
        out = self._read()
        if resume and command != 'quit':
            self.sock.sendall(b'x\n'); time.sleep(0.1); self._read()
        return out

    def screen(self):
        """Text on the 40x25 screen read from screen RAM ($0400)."""
        out = self.mon('m %04x %04x' % (self.scr_base, self.scr_base + 0x3e7), 1.0)
        mem = bytearray()
        for ln in out.splitlines():
            i = ln.find('>C:')
            if i >= 0:
                mem += bytes(int(x, 16) for x in ln[i + 9:i + 59].split())
        mem = mem[:1000].ljust(1000, b'\x20')
        return '\n'.join(''.join(screen_char(b) for b in mem[r * 40:(r + 1) * 40]).rstrip() for r in range(25))

    def wait_for(self, text, timeout=60):
        t = time.time()
        while time.time() - t < timeout:
            s = self.screen()
            if text in s: return s
            time.sleep(0.5)
        raise TimeoutError(f'{text!r} not seen; screen:\n{self.screen()}')

    KEYSYM = {' ': 'space', '!': 'exclam', '"': 'quotedbl', '#': 'numbersign', '$': 'dollar', '%': 'percent',
              '&': 'ampersand', "'": 'apostrophe', '(': 'parenleft', ')': 'parenright', '*': 'asterisk', '+': 'plus',
              ',': 'comma', '-': 'minus', '.': 'period', '/': 'slash', ':': 'colon', ';': 'semicolon', '<': 'less',
              '=': 'equal', '>': 'greater', '?': 'question', '@': 'at', '[': 'bracketleft', '\\': 'backslash',
              ']': 'bracketright', '^': 'asciicircum', '_': 'underscore', '`': 'grave', '{': 'braceleft',
              '|': 'bar', '}': 'braceright', '~': 'asciitilde', '\n': 'Return', '\b': 'BackSpace'}

    def type(self, text, delay=0.12, hold=0.06):
        """Type through the host keyboard; each key is held `hold` s so that VICE (which polls the host keys once per frame)
        never misses it, also without warp mode."""
        for ch in text:
            k = self.KEYSYM.get(ch, ch)
            subprocess.run(['xdotool', 'keydown', k], env=self.env)
            time.sleep(hold)
            subprocess.run(['xdotool', 'keyup', k], env=self.env)
            time.sleep(delay)

    def cmd(self, line, expect, timeout=30):
        """Type a shell command, wait until `expect` (substring) shows up after it, return the screen."""
        self.type(line + '\n')
        t = time.time()
        while True:
            sc = self.screen()
            tail = sc[sc.rfind('# ' + line):] if ('# ' + line) in sc else ''
            if expect in tail and tail.rstrip().endswith('#'):
                return sc
            if time.time() - t > timeout:
                raise TimeoutError(f'{line!r}: {expect!r} not seen; screen:\n{sc}')
            time.sleep(0.4)

    def key(self, *keys):
        subprocess.run(['xdotool', 'key', *keys], env=self.env); time.sleep(0.2)

    def screenshot(self, path):
        self.mon(f'screenshot "{Path(path).resolve()}" 2', 1.0)  # format 2 = PNG

    def close(self):
        try: self.mon('quit', 0.3)
        except Exception: pass
        for p in (self.proc, self.xvfb):
            try: p.kill(); p.wait(5)
            except Exception: pass

    def __enter__(self): return self
    def __exit__(self, *a): self.close()
