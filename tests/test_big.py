import harness
from harness import Machine
from sfs import Disk
rom=open('bios.rom','rb').read()
d=Disk('disk.img',blocks=2048)
big=''.join(f"line {i:04d} abcdefghijklmnopqrstuvwxyz0123456789\n" for i in range(100)).encode()  # ~4.9 KB, 20 bloków
exact=(b'x'*255+b'\n')*3   # dokładnie 768 B = 3 bloki
d.put('BIG.TXT',big); d.put('EXACT.TXT',exact)
out=bytearray(); 
script="cat big.txt\r"+"cat exact.txt\r"
T0=12_500_000
keys=[(T0+i*2000,ord(c)) for i,c in enumerate(script)]
m=Machine(rom,image=bytes(d.d),blocks=2048,keys=keys)
orig=m.term.put
m.term.put=lambda ch:(out.append(ch),orig(ch))
mp=m.mpu
while mp.processorCycles<T0+len(script)*2000+25_000_000: m.step()
o=bytes(out).replace(b'\r\n',b'\n')
i=o.index(b'cat big.txt\n')+12
body=o[i:]
print('rozmiar BIG',len(big),'bloków',(len(big)+255)//256)
print('BIG zgodny:',body.startswith(big))
j=o.index(b'cat exact.txt\n')+14
print('EXACT zgodny:',o[j:].startswith(exact))
