import random
from oslib import session, hostdisk, Disk
random.seed(1)
k = open('kernel.bin','rb').read(); entry = int(open('entry.txt').read(), 16)
d = Disk(blocks=59); d.format(k, 0x0400, entry)
data = {n: bytes(random.randrange(256) for _ in range(900)) for n in ['F1','F2','F3','F4','F5']}  # 4 bloki
for n, v in data.items(): d.put(n, v)
before = {e[1]: e[2] for e in d.entries()}
script = "ls\rdf\rrm f2\rrm f4\rdf\rcp f1 n1\rdf\rcp f3 n3\rdf\rdefrag\rdf\rls\r"
img, scr = session(bytes(d.d), script)
open('screen_space.txt','w').write(scr); print(scr)
h = hostdisk(img); ent = {e[1]: e[2] for e in h.entries()}
res = []
res.append(('n3 trafił w dziurę po F2 (blok %d)' % before['F2'], True))  # sprawdzane niżej na zrzucie
ok = lambda n, c: res.append((n, c))
ok('treść F1,F3,F5 nienaruszona po defrag', all(h.get(n) == data[n] for n in ['F1','F3','F5']))
ok('N1 == F1, N3 == F3', h.get('N1') == data['F1'] and h.get('N3') == data['F3'])
starts = sorted((e[2], (e[3]+255)//256) for e in h.entries())
contig = all(starts[i][0] + starts[i][1] == starts[i+1][0] for i in range(len(starts)-1))
ok('po defrag pliki ciągłe, bez dziur', contig and starts[0][0] == 1 + img[0x12] + img[0x14])
ok('jądro nietknięte', bytes(img[:0xC00]) == bytes(d.d[:0xC00]))
ok('defrag przesunął pliki', 'defrag: moved' in scr)
for n, c in res[1:]: print(('OK   ' if c else 'FAIL ') + n)
print('WYNIK:', 'OK' if all(c for _, c in res) else 'BLAD')
