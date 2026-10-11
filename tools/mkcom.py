"""Składa relokowalny .COM z dwóch wersji binarnych (baza $4008 i $7008).
Nagłówek: [0,1] długość kodu, [2,3] BSS, [4,5] liczba reloc, [6,7] offset tabeli; potem kod; potem offsety bajtów starszych."""
import sys, struct, re
b1 = open(sys.argv[1], 'rb').read(); b2 = open(sys.argv[2], 'rb').read()
bss = int(re.search(r'al ([0-9A-Fa-f]+) \.__BSS_SIZE__', open(sys.argv[3]).read()).group(1), 16) if '__BSS_SIZE__' in open(sys.argv[3]).read() else 0
assert len(b1) == len(b2)
rel = []
for i, (x, y) in enumerate(zip(b1, b2)):
    if x != y:
        assert y - x == 0x30, (i, x, y)
        rel.append(8 + i)
hdr = struct.pack('<HHHH', len(b1), bss, len(rel), 8 + len(b1))
open(sys.argv[4], 'wb').write(hdr + b1 + b''.join(struct.pack('<H', r) for r in rel))
print(f"{sys.argv[4]}: kod {len(b1)} B, bss {bss}, reloc {len(rel)}")
