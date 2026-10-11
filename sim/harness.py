import sys
from py65.devices.mpu6502 import MPU as NMOS_BASE
from py65.devices.mpu65c02 import MPU as CMOS

class NMOS(NMOS_BASE):
    # py65 nie zna $64; na NMOS to 2-bajtowy NOP zp
    instruct = list(NMOS_BASE.instruct)
    cycletime = list(NMOS_BASE.cycletime)
    instruct[0x64] = lambda s: setattr(s, 'pc', (s.pc + 1) & 0xFFFF)
    cycletime[0x64] = 3

class Term:
    def __init__(s, rows=24, cols=80):
        s.R, s.C = rows, cols
        s.g = [[' '] * cols for _ in range(rows)]
        s.r = s.c = 0
        s.st = 0; s.buf = ''
    def put(s, ch):
        ch = chr(ch)
        if s.st == 0:
            if ch == '\x1b': s.st = 1
            elif ch == '\r': s.c = 0
            elif ch == '\n': s.lf()
            elif ch == '\b': s.c = max(0, s.c - 1)
            elif ch >= ' ': 
                if s.c >= s.C: s.c = 0; s.lf()
                s.g[s.r][s.c] = ch; s.c += 1
        elif s.st == 1:
            if ch == '[': s.st = 2; s.buf = ''
            else: s.st = 0
        else:
            if ch.isdigit() or ch in ';?': s.buf += ch
            else: s.csi(ch); s.st = 0
    def lf(s):
        if s.r == s.R - 1:
            s.g.pop(0); s.g.append([' '] * s.C)
        else: s.r += 1
    def csi(s, f):
        p = [int(x) if x.isdigit() else 0 for x in s.buf.lstrip('?').split(';')] if s.buf else []
        n = p[0] if p and p[0] else 1
        if f in 'Hf':
            s.r = min(s.R-1, (p[0] if len(p)>0 and p[0] else 1) - 1)
            s.c = min(s.C-1, (p[1] if len(p)>1 and p[1] else 1) - 1)
        elif f == 'J':
            if (p[0] if p else 0) == 2: s.g = [[' '] * s.C for _ in range(s.R)]
        elif f == 'K':
            for i in range(s.c, s.C): s.g[s.r][i] = ' '
        elif f == 'A': s.r = max(0, s.r - n)
        elif f == 'B': s.r = min(s.R-1, s.r + n)
        elif f == 'C': s.c = min(s.C-1, s.c + n)
        elif f == 'D': s.c = max(0, s.c - n)
    def dump(s):
        lines = [''.join(r).rstrip() for r in s.g]
        while lines and not lines[-1]: lines.pop()
        return '\n'.join(lines) + '\n'

class Machine:
    def __init__(s, rom, cpu=NMOS, blocks=2048, media=True, image=None,
                 keys=(), stuck=None, console_dead=False, wp=False):
        s.rom = rom; s.ram = bytearray(65536); s.latch = 0
        s.stuck = stuck or {}           # addr -> (and_mask, or_mask) na odczycie RAM
        s.term = Term(); s.keys = sorted(keys); s.fifo = []
        s.in_reset = True; s.dead = console_dead
        s.wp = wp; s.media = media; s.blocks = blocks; s.image = image if image is not None else b''
        s.blk = [0]*9; s.busy = 0; s.err = 0; s.tmr_en = None; s.tmr_div = 10
        s.tmr_ctrl = 0; s.tmr_k = 1; s.tmr_pend = False
        s.cmd_log = []
        s.i2c_data = 0; s.i2c_nack = 0; s.i2c_busy = 0; s.i2c_st = 0; s.i2c_ptr = 0
        s.rtc_base = (2026, 10, 11, 14, 45, 0)
        s.mpu = cpu(memory=s)
        s.mpu.pc = rom[0x7FC] | (rom[0x7FD] << 8)
    # --- magistrala ---
    def __getitem__(s, a):
        if 0xD800 <= a < 0xE000: return s.io_r(a)
        if a >= 0xF800 and s.latch == 0: return s.rom[a - 0xF800]
        v = s.ram[a]
        f = s.stuck.get(a)
        if f: v = (v & f[0]) | f[1]
        return v
    def __setitem__(s, a, v):
        v &= 0xFF
        if 0xD800 <= a < 0xE000: s.io_w(a, v)
        else: s.ram[a] = v
    def now(s): return s.mpu.processorCycles
    def io_r(s, a):
        if a == 0xDF00:
            while s.keys and s.keys[0][0] <= s.now():
                s.fifo.append(s.keys.pop(0)[1])
            st = 1 if s.fifo else 0
            if not s.in_reset and not s.dead: st |= 2
            return st
        if a == 0xDF01: return s.fifo.pop(0) if s.fifo else 0
        if a == 0xDF02: return len(s.fifo)
        if a == 0xDF10:
            st = 0
            if s.busy > 0: st |= 1; s.busy -= 1
            elif s.cmd_st: st |= s.cmd_st
            return st
        if a == 0xDF17: return s.err
        if 0xDF11 <= a <= 0xDF18: return s.blk[a - 0xDF10]
        if a == 0xDF21: return s.i2c_data
        if a == 0xDF22:
            st = s.i2c_nack << 1
            if s.i2c_busy > 0: st |= 1; s.i2c_busy -= 1
            return st
        if a == 0xDF31: return 1 if s.tmr_pend else 0
        if a == 0xDF32: return s.tmr_div
        if a == 0xDF33:
            if s.tmr_en is None: return 0
            return ((s.now() - s.tmr_en) // (s.tmr_div * 1000)) & 0xFF
        return 0xFF
    cmd_st = 0
    def io_w(s, a, v):
        if a == 0xDE00: s.latch = v & 1
        elif a == 0xDF00: s.in_reset = (v & 3) == 3
        elif a == 0xDF01:
            if not s.in_reset: s.term.put(v)
        elif a == 0xDF10:
            s.cmd_log.append(v); s.err = 0; s.cmd_st = 0
            s.busy = 3
            if not s.media: s.cmd_st = 4
            elif v == 3:
                s.blk[5] = s.blocks & 0xFF; s.blk[6] = (s.blocks >> 8) & 0xFF
            elif v == 2:
                n = s.blk[1] | (s.blk[2] << 8); ad = s.blk[3] | (s.blk[4] << 8)
                if s.wp: s.err = 4; s.cmd_st = 2
                elif n >= s.blocks: s.err = 1; s.cmd_st = 2
                else: s.image[n*256:n*256+256] = bytes(s.ram[ad:ad+256])
            elif v == 1:
                n = s.blk[1] | (s.blk[2] << 8); ad = s.blk[3] | (s.blk[4] << 8)
                if n >= s.blocks: s.err = 1; s.cmd_st = 2
                else:
                    d = s.image[n*256:n*256+256].ljust(256, b'\0')
                    for i in range(256): s.ram[ad+i] = d[i]
        elif a == 0xDF21: s.i2c_data = v
        elif a == 0xDF20: s.i2c_ctrl(v)
        elif a == 0xDF30:
            s.tmr_ctrl = v
            if v & 1 and s.tmr_en is None: s.tmr_en = s.now()
        elif a == 0xDF31: s.tmr_pend = False          # zapis = potwierdzenie IRQ
        elif 0xDF11 <= a <= 0xDF18: s.blk[a - 0xDF10] = v
    def rtc_regs(s):
        import datetime
        y, mo, d, h, mi, se = s.rtc_base
        t = datetime.datetime(y, mo, d, h, mi, se) + datetime.timedelta(seconds=s.now() // 1_000_000)
        b = lambda n: ((n // 10) << 4) | (n % 10)
        return [b(t.second), b(t.minute), b(t.hour), b(t.isoweekday()), b(t.day), b(t.month), b(t.year % 100)]
    def i2c_ctrl(s, v):
        s.i2c_busy = 2; s.i2c_nack = 0
        if v & 1: s.i2c_state = 'addr'
        if v & 4:
            if s.i2c_state == 'addr':
                if s.i2c_data in (0xD0, 0xD1): s.i2c_state = 'reg' if s.i2c_data == 0xD0 else 'read'
                else: s.i2c_nack = 1; s.i2c_state = 'idle'
            elif s.i2c_state == 'reg': s.i2c_ptr = s.i2c_data; s.i2c_state = 'wr'
        if v & 8:
            r = s.rtc_regs(); s.i2c_data = r[s.i2c_ptr % 7] if s.i2c_ptr < 7 else 0; s.i2c_ptr += 1
    i2c_state = 'idle'
    def step(s):
        m = s.mpu
        if s.tmr_en is not None:
            if not s.tmr_pend and m.processorCycles >= s.tmr_en + s.tmr_k * s.tmr_div * 1000:
                s.tmr_pend = True; s.tmr_k += 1
            if s.tmr_pend and (s.tmr_ctrl & 2): m.irq()
        m.step()
    def run(s, max_steps=30_000_000, stop_pc=None):
        m = s.mpu; n = 0
        while n < max_steps:
            pc = m.pc
            m.step(); n += 1
            if m.pc == pc: return 'HALT', n          # skok do siebie
            if stop_pc is not None and m.pc == stop_pc: return 'BOOT', n
        return 'LIMIT', n

def boot_image():
    code = bytes([0x4C, 0x00, 0x03])              # jmp $0300
    hdr = bytes([0x00, 0x03, 1, 0x00, 0x03]) + bytes(251)
    return hdr + code.ljust(256, b'\0')

def check(name, cond, extra=''):
    print(('OK   ' if cond else 'FAIL ') + name + (' ' + extra if extra else ''))
    return cond

if __name__ == '__main__':
    rom = open('bios.rom', 'rb').read()
    ok = True
    def scr(name, m): open(f'screen_{name}.txt', 'w').write(m.term.dump())
    img = boot_image()

    m = Machine(rom, image=img); r, n = m.run(stop_pc=0x0300); scr('ok', m)
    t = m.term.dump()
    ok &= check('ok: dochodzi do systemu', r == 'BOOT', f'{r} kroków={n} cykli={m.now()}')
    ok &= check('ok: RAM F800-FFFF = ROM, shadow=1', bytes(m.ram[0xF800:]) == rom and m.latch == 1)
    ok &= check('ok: tabela', all(x in t for x in ['CPU', 'OK NMOS', '0002-01FF', 'SHADOW', 'OK 2048 KB'.replace('2048', '512'), 'OK 100 HZ', 'LOADING SYSTEM']))
    w = m.now() - m.tmr_en
    ok &= check('ok: okno SETUP ~2 s (od startu zegara do loadera)', 1_990_000 < w < 2_100_000, f'{w} cykli')

    m = Machine(rom, image=img, keys=[(1_000_000, ord('s'))]); r, n = m.run(stop_pc=0x0300); scr('setup', m)
    ok &= check('setup: klawisz S', 'SETUP: NOT IMPLEMENTED' in m.term.dump() and r == 'BOOT')

    m = Machine(rom, cpu=CMOS, image=img); r, n = m.run(stop_pc=0x0300); scr('cmos', m)
    ok &= check('cmos: wykryty', 'OK CMOS' in m.term.dump() and r == 'BOOT')

    m = Machine(rom, media=False); r, n = m.run(); scr('nomedia', m)
    t = m.term.dump()
    ok &= check('nomedia', r == 'HALT' and 'NO MEDIA' in t and 'NO BOOT MEDIA' in t)

    m = Machine(rom, image=img, blocks=0); r, n = m.run(stop_pc=0x0300); scr('size0', m)
    ok &= check('size0 = 16384 KB', '16384 KB' in m.term.dump())

    m = Machine(rom, image=img, stuck={0x4321: (0xFF, 0x08)}); r, n = m.run(); scr('ram_fail', m)
    t = m.term.dump()
    ok &= check('ram fail 4321', r == 'HALT' and 'FAIL 43XX' in t and 'POST FAILED' in t)

    m = Machine(rom, image=img, stuck={0x0123: (0xFF, 0x01)}); r, n = m.run(); scr('zp_fail', m)
    ok &= check('zp/stack fail', r == 'HALT' and 'ZP/STACK RAM FAIL' in m.term.dump())

    m = Machine(rom, image=img, stuck={0xFA10: (0xFE, 0x00)}); r, n = m.run(); scr('hi_fail', m)
    t = m.term.dump()
    ok &= check('ram fail FAxx, shadow=0', r == 'HALT' and 'FAIL FAXX' in t and m.latch == 0 and 'POST FAILED' in t)

    m = Machine(rom, image=img, stuck={0xE123: (0xF7, 0x00)}); r, n = m.run(); scr('ram2_fail', m)
    ok &= check('ram fail E1xx', 'FAIL E1XX' in m.term.dump())

    m = Machine(rom, image=img, console_dead=True); r, n = m.run(); 
    ok &= check('konsola martwa: cisza, stop', r == 'HALT' and m.term.dump().strip() == '')

    print('WYNIK:', 'WSZYSTKO OK' if ok else 'BŁĘDY'); sys.exit(0 if ok else 1)
