import sys
import harness
from harness import Machine, Term
# przewijane linie zachowaj w transkrypcie
class T2(Term):
    def __init__(s,*a,**k): super().__init__(*a,**k); s.sb=[]
    def lf(s):
        if s.r == s.R-1: s.sb.append(''.join(s.g[0]).rstrip())
        super().lf()
harness.Term = T2
rom = open('bios.rom','rb').read(); img = open('disk.img','rb').read()
script = "help\rls\rcat readme.txt\recx\bho hello world\rhello a b c\rcat nofile\rfoo\rver\r"
T0 = 12_500_000
keys = [(T0 + i*2000, ord(c)) for i, c in enumerate(script)]
m = Machine(rom, image=img, blocks=2048, keys=keys)
mp = m.mpu; end = T0 + len(script)*2000 + 3_000_000
while mp.processorCycles < end: m.step()
t = m.term
full = '\n'.join(t.sb) + '\n' + t.dump()
open('screen_unix.txt','w').write(full)
print(full)
ok = all(x in full for x in ['MiniUnix 0.1','README.TXT','BIN/','hello\na\nb\nc','hello world','foo: command not found','cat: no such file','Pliki ciagle'])
print('WYNIK:', 'OK' if ok else 'BLAD')
