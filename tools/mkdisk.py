import glob, os
from sfs import Disk
k = open('kernel.bin', 'rb').read()
d = Disk('disk.img', blocks=2048)
d.format(k, load=0x0400, entry=int(open("entry.txt").read(), 16))
d.mkdir('/bin')
d.put('README.TXT', b'MiniUnix: prosty system dla 6510.\nPliki ciagle, bloki 256 B.\n')
d.put('NOTES.TXT', b'ls, cat, echo, clear, ver, help\nProgramy: /bin/NAME.COM\n')
CORE = ['HELLO','WC','UPPER','CAT','SKIP','TICK','LOOP','COUNT']
EXTRA = sorted(os.path.basename(p)[:-4].upper() for p in glob.glob('*.com'))
for n in CORE + [e for e in EXTRA if e not in CORE]: d.put('/bin/' + n + '.COM', open(n.lower() + '.com', 'rb').read())
d.put("BIG.TXT", "".join(f"line {i:04d} abcdefghijklmnopqrstuvwxyz0123456789\n" for i in range(100)).encode())
d.save(); print(d.ls())
