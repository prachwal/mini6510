from oslib import session, hostdisk, Disk
orig = open('disk.img','rb').read()
script = ('echo "a > b | c"\r' 'echo x >\r' 'echo   many    spaces   here\r'
 'cat readme.txt | upper | upper\r' 'echo abc | upper | cat | cat\r'
 'cp readme.txt x.txt | cat\r' 'wc nofile > out.txt\r' 'ls\r'
 'cat big.txt | cat > big3.txt\r' 'cat big.txt > big4.txt\r' 'cat readme.txt | upper > up.txt\r'
 'cat < nofile\r' 'echo end\r')
img, scr = session(orig, script)
open('screen_redir.txt','w').write(scr); print(scr)
h = hostdisk(img); names = [e[1] for e in h.entries()]
ent = {e[1]: e for e in h.entries()}
res = []; ok = lambda n, c: res.append((n, c))
ok('cudzysłów chroni > i |', '\na > b | c\n' in scr)
ok('brak nazwy po > -> bad argument, brak pliku', 'redirect: bad argument' in scr and '' not in [n for n in names] and all(n.strip() for n in names))
ok('echo normalizuje spacje', '\nmany spaces here\n' in scr)
ok('2 etapy: upper|upper', 'MINIUNIX: PROSTY SYSTEM DLA 6510.' in scr)
ok('4 etapy: echo|upper|cat|cat', '\nABC\n' in scr)
ok('cp | cat: kopia powstała', h.get('X.TXT') == h.get('README.TXT'))
ok('stderr na konsolę, stdout do pliku (wc nofile > out.txt)', 'no such file' in scr.split('# wc nofile > out.txt')[1].split('#')[0] and 'OUT.TXT' in names and h.get('OUT.TXT') == b'')
ok('brak PIPE.TMP / śmieci w katalogu', not any('PIPE' in n for n in names))
ok('potok strumieniowy: brak obcinania', 'pipe full' not in scr)
ok('cat big.txt | cat > big3.txt: 4700 B w całości', ent['BIG3.TXT'][3] == 4700 and h.get('BIG3.TXT') == h.get('BIG.TXT'))
ok('bez potoku plik 4700 B cały', h.get('BIG4.TXT') == h.get('BIG.TXT'))
ok('upper > up.txt', h.get('UP.TXT') == h.get('README.TXT').upper())
ok('< nofile: nazwa w komunikacie', 'nofile: no such file' in scr)
ok('shell żyje po błędach', scr.rstrip().endswith('#') and '\nend\n' in scr)
for n, c in res: print(('OK   ' if c else 'FAIL ') + n)
# pełny dysk: błąd zapisu przy przekierowaniu
d2 = Disk(blocks=76); k = open('kernel.bin','rb').read(); d2.format(k, 0x0400, int(open('entry.txt').read(),16))
d2.mkdir('/bin'); d2.put('/bin/CAT.COM', h.get('/bin/CAT.COM')); d2.put('BIG.TXT', h.get('BIG.TXT'))
img2, scr2 = session(bytes(d2.d), "cat big.txt > z.txt\rcat big.txt > y.txt\rdf\r")
print(scr2[-300:])
ok2 = 'no space' in scr2
print(('OK   ' if ok2 else 'FAIL ') + 'przekierowanie na pełny dysk: "no space"'); res.append(('full', ok2))
print('WYNIK:', 'OK' if all(c for _, c in res) else 'BLAD')
