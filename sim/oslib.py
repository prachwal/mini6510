import harness, tempfile, os
from harness import Machine, Term
from sfs import Disk
class T2(Term):
    def __init__(s,*a,**k): super().__init__(*a,**k); s.sb=[]
    def lf(s):
        if s.r == s.R-1: s.sb.append(''.join(s.g[0]).rstrip())
        super().lf()
harness.Term = T2
rom = open('bios.rom','rb').read()
def session(img, script, wp=False, extra=600_000):
    img = bytearray(img)
    T0 = 12_500_000
    keys = [(T0 + i*2000, ord(c)) for i, c in enumerate(script)]
    m = Machine(rom, image=img, blocks=len(img)//256, keys=keys, wp=wp)
    mp = m.mpu
    while mp.processorCycles < T0 + 30_000 or m.keys or m.fifo: m.step()
    e = mp.processorCycles + extra
    while mp.processorCycles < e: m.step()
    t = m.term
    return img, '\n'.join(t.sb) + '\n' + t.dump()
def hostdisk(img):
    d = Disk(); d.d = bytearray(img); d.n = len(img)//256; return d
