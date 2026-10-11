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
def session(img, script, wp=False):
    img = bytearray(img)
    T0 = 12_500_000
    keys = [(T0 + i*2000, ord(c)) for i, c in enumerate(script)]
    m = Machine(rom, image=img, blocks=len(img)//256, keys=keys, wp=wp)
    mp = m.mpu
    while mp.processorCycles < T0 + 30_000 or m.keys or m.fifo: m.step()
    e = mp.processorCycles + 600_000
    while mp.processorCycles < e: m.step()
    t = m.term
    return img, '\n'.join(t.sb) + '\n' + t.dump()
def hostdisk(img):
    d = Disk(); d.d = bytearray(img); d.n = len(img)//256; return d
orig = open('disk.img','rb').read()
script = ("df\r" "echo new file > a.txt\r" "cat a.txt\r" "cp readme.txt copy.txt\r" "cat copy.txt\r"
          "mv copy.txt moved.txt\r" "touch empty\r" "cp big.txt big2.txt\r" "ls\r" "rm a.txt\r" "rm nofile\r"
          "touch moved.txt\r" "ls\r" "df\r")
img, scr = session(orig, script)
open('screen_mgmt.txt','w').write(scr); print(scr)
d = hostdisk(img); names = [e[1] for e in d.entries()]
checks = [
 ('echo > plik', False),  # uzupełniane niżej
]
res = []
res.append(('MOVED.TXT == README.TXT (host)', d.get('MOVED.TXT') == d.get('README.TXT')))
res.append(('BIG2.TXT == BIG.TXT (host, 19 bloków)', d.get('BIG2.TXT') == d.get('BIG.TXT')))
res.append(('EMPTY istnieje, 0 B', ('EMPTY' in names) and d.get('EMPTY') == b''))
res.append(('A.TXT usunięty', 'A.TXT' not in names and 'COPY.TXT' not in names))
res.append(('cat a.txt zwrócił treść', 'new file\n' in scr))
res.append(('rm nofile -> komunikat', 'no such file' in scr))
res.append(('touch na istniejący -> błąd', 'touch: file exists' in scr))
res.append(('jądro nietknięte (blok 0..sys)', bytes(img[:0xB00]) == orig[:0xB00]))
# pełny dysk: 64 bloki
from mkdisk import *  # noqa (odtwarza disk.img)
d2 = Disk(blocks=80); k = open('kernel.bin','rb').read(); d2.format(k, 0x0400, int(open('entry.txt').read(),16))
d2.put('BIG.TXT', d.get('BIG.TXT'))
img2, scr2 = session(bytes(d2.d), "cp big.txt c1\rcp big.txt c2\rcp big.txt c3\rls\rdf\r")
open('screen_full.txt','w').write(scr2); print(scr2)
h2 = hostdisk(img2)
res.append(('pełny dysk: write error + sprzątanie', 'cp: no space' in scr2))
res.append(('pełny dysk: BIG.TXT cały', h2.get('BIG.TXT') == d.get('BIG.TXT')))
res.append(('pełny dysk: nieudane kopie usunięte (tylko BIG.TXT, C1)', sorted(e[1] for e in h2.entries()) == ['BIG.TXT','C1']))
# zapis na dysk chroniony
img3, scr3 = session(orig, "touch x\r", wp=True)
res.append(('wp: dysk bez zmian', bytes(img3) == orig)); print(scr3[-200:])
for n, ok in res: print(('OK   ' if ok else 'FAIL ') + n)
print('WYNIK:', 'OK' if all(ok for _, ok in res) else 'BLAD')
