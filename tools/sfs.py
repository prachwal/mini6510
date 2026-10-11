"""Symulacja dysku blokowego + prosty FS (SFS). Bloki 256 B.
Blok 0: nagłówek bootu (+0,1 adres, +2 bloki, +3,4 wejście) oraz od +$10 superblok:
  +$10 'SF', +$12 sys_blocks, +$13 dir_start, +$14 dir_blocks, +$15,16 total (lo,hi)
Katalog: 32 B/wpis (8/blok): nazwa 11 B (8.3), +11,12 start, +13,14 dług., +15 flagi (0 wolny,1 plik,2 kat.), +16 rodzic ($FF=root),\n  +17,18 data FAT, +19,20 czas FAT
Pliki ciągłe (kontigualne), alokacja za ostatnim plikiem."""
import sys
BS = 256
class Disk:
    ERR = {1: 'range', 2: 'rw', 3: 'nomedia', 4: 'wp', 5: 'bad addr'}
    def __init__(s, path=None, blocks=2048, wp=False):
        s.path, s.wp, s.n = path, wp, blocks
        s.d = bytearray(blocks * BS)
        if path:
            try: s.d[:] = open(path, 'rb').read()
            except FileNotFoundError: pass
            s.n = len(s.d) // BS
    # --- interfejs kontrolera: (kod_błędu, dane) ---
    def info(s): return 0, s.n & 0xFFFF
    def read(s, b):
        if b >= s.n: return 1, None
        return 0, bytes(s.d[b*BS:(b+1)*BS])
    def write(s, b, data):
        if s.wp: return 4
        if b >= s.n: return 1
        s.d[b*BS:(b+1)*BS] = data.ljust(BS, b'\0')[:BS]; return 0
    def save(s):
        if s.path: open(s.path, 'wb').write(s.d)
    # --- FS ---
    def format(s, kernel, load, entry, dir_blocks=6):
        sysb = (len(kernel) + BS - 1) // BS
        s.d[:] = bytes(len(s.d))
        s.d[0:5] = bytes([load & 255, load >> 8, sysb, entry & 255, entry >> 8])
        s.d[0x10:0x12] = b'SF'
        s.d[0x12], s.d[0x13], s.d[0x14] = sysb, 1 + sysb, dir_blocks
        s.d[0x15], s.d[0x16] = s.n & 255, s.n >> 8
        s.d[BS:BS+len(kernel)] = kernel
    def _sb(s): return s.d[0x12], s.d[0x13], s.d[0x14]
    @staticmethod
    def _fmt(e):
        nm = e[:11].decode('latin1'); return nm[:8].strip() + ('.' + nm[8:].strip() if nm[8:].strip() else '')
    def raw(s):
        _, ds, dn = s._sb(); out = []
        for i in range(dn * 8):
            o = ds * BS + i * 32; e = bytes(s.d[o:o+32])
            if e[15]: out.append((i, e))
        return out
    def entries(s):
        """(idx, name, start, len, flags, parent)"""
        return [(i, s._fmt(e), e[11] | e[12] << 8, e[13] | e[14] << 8, e[15], e[16]) for i, e in s.raw()]
    @staticmethod
    def _raw(name):
        nm, _, ex = name.upper().partition('.')
        return (nm.ljust(8)[:8] + ex.ljust(3)[:3]).encode('latin1')
    def _find(s, path, create_parent=False):
        parts = [p for p in path.strip('/').split('/') if p]
        par = 0xFF
        for p in parts[:-1]:
            hit = [i for i, nm, st, ln, fl, pa in s.entries() if nm == p.upper() and pa == par and fl == 2]
            if not hit: raise FileNotFoundError(path)
            par = hit[0]
        return par, parts[-1]
    def _slot(s):
        _, ds, dn = s._sb()
        used = {i for i, _ in s.raw()}
        return next(i for i in range(dn*8) if i not in used)
    def _stamp(s):
        return bytes([0x4B, 0x5D, 0x00, 0x00])  # 2026-10-11 00:00 (FAT)
    def mkdir(s, path):
        par, name = s._find(path)
        _, ds, dn = s._sb(); slot = s._slot(); o = ds*BS + slot*32
        s.d[o:o+32] = s._raw(name) + bytes([0, 0, 0, 0, 2, par]) + s._stamp() + bytes(32 - 21)
    def put(s, path, data):
        _, ds, dn = s._sb()
        par, name = s._find(path)
        ents = s.entries()
        nxt = max([ds + dn] + [st + (ln + BS - 1)//BS for _, _, st, ln, fl, _p in ents if fl == 1 and ln])
        need = (len(data) + BS - 1) // BS
        if nxt + need > s.n: raise IOError('disk full')
        slot = s._slot(); o = ds*BS + slot*32
        s.d[o:o+32] = s._raw(name) + bytes([nxt & 255, nxt >> 8, len(data) & 255, len(data) >> 8, 1, par]) + s._stamp() + bytes(32 - 21)
        s.d[nxt*BS:nxt*BS+len(data)] = data
    def get(s, path):
        par, name = s._find(path)
        for _, nm, st, ln, fl, pa in s.entries():
            if nm == name.upper() and pa == par and fl == 1: return bytes(s.d[st*BS:st*BS+ln])
        raise FileNotFoundError(path)
    def ls(s):
        names = {}
        def full(i, nm, pa):
            return nm if pa == 0xFF else full(pa, names[pa][0], names[pa][1]) + '/' + nm
        for i, nm, st, ln, fl, pa in s.entries(): names[i] = (nm, pa)
        ents = s.entries()
        lines = [f"{full(i, nm, pa) + ('/' if fl == 2 else ''):<20}{('dir' if fl == 2 else str(ln)):>6}  blok {st}" for i, nm, st, ln, fl, pa in ents]
        sysd = s._sb()[1] + s._sb()[2]
        free = s.n - max([sysd] + [st + (ln+BS-1)//BS for _, _, st, ln, fl, _p in ents if fl == 1 and ln])
        return '\n'.join(lines + [f"{len(lines)} wpisów, wolne bloki: {free}"])

if __name__ == '__main__':
    cmd = sys.argv[1]; d = Disk(sys.argv[2])
    if cmd == 'ls': print(d.ls())
    elif cmd == 'cat': sys.stdout.buffer.write(d.get(sys.argv[3]))
    elif cmd == 'put': d.put(sys.argv[3], open(sys.argv[4], 'rb').read()); d.save()
