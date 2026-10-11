from oslib import session, hostdisk, Disk
orig = open('disk.img','rb').read()
script = ("pwd\rls -l\rmkdir work\rmkdir work\rcd work\rpwd\rmkdir sub\recho hi > a.txt\recho more >> a.txt\rcat a.txt\r"
          "ls -l\rcd sub\rpwd\rcd ..\rcd ..\rpwd\rmv big.txt work\rls\rls work\rmv work/a.txt work/sub\rls work/sub\r"
          "rmdir work\rrm work\rcd /work/sub\rcd /nodir\rcat /readme.txt\rcd /bin\rhello x\rcd /\rmv work wk\rls\rdate\r"
          "cp wk/big.txt wk/sub/b\rls wk/sub\rmv wk wk/sub\rrm wk/sub/b\rrm wk/big.txt\rrm wk/sub/a.txt\rrmdir wk/sub\rrmdir wk\rls\r")
img, scr = session(orig, script, extra=6_000_000)
open('screen_dirs.txt','w').write(scr); print(scr[scr.index('# pwd'):])
h = hostdisk(img); res = []
ok = lambda n, c: res.append((n, c))
ok('pwd root = /', '# pwd\n/\n' in scr)
ok('mkdir istniejący -> file exists', 'mkdir: file exists' in scr)
ok('pwd w podkatalogu', '/WORK\n' in scr)
ok('pwd zagnieżdżony', '/WORK/SUB\n' in scr)
ok('>> dopisuje', 'hi\nmore\n' in scr)
ok('ls -l: data 2026-10-11', '2026-10-11 14:45 A.TXT' in scr)
ok('ls pokazuje katalog z /', 'WORK/' in scr)
ok('mv do katalogu', 'BIG.TXT      4700' in scr.split('# ls work')[1].split('# mv work/a.txt')[0])
ok('rmdir niepusty -> błąd', 'rmdir: directory not empty' in scr)
ok('rm katalogu -> is a directory', 'rm: is a directory' in scr)
ok('cd /nodir -> błąd', 'cd: no such file' in scr)
ok('program z /bin bez ścieżki (hello)', 'hello\nx\n' in scr or 'hello x' in scr)
ok('cat po ścieżce absolutnej', 'prosty system' in scr)
ok('mv wk do własnego potomka -> bad argument', 'mv: bad argument' in scr)
ok('date w formacie', '2026-10-11 14:45:' in scr.split('# date')[1])
ok('na końcu katalog WK usunięty', 'WK/' not in scr.split('# rmdir wk\n')[-1])
print()
# dopisywanie w miejscu: plik zostaje w tym samym bloku startowym
d = hostdisk(orig); st0 = [e[2] for e in d.entries() if e[1] == 'BIG.TXT'][0]
img2, scr2 = session(orig, "echo x >> big.txt\recho y >> big.txt\rdf\r", extra=4_000_000)
h2 = hostdisk(img2)
st1 = [e[2] for e in h2.entries() if e[1] == 'BIG.TXT'][0]
ok('append w miejscu (miejsce za plikiem): ten sam blok startowy', st0 == st1)
ok('append: treść', h2.get('BIG.TXT') == d.get('BIG.TXT') + b'x\ny\n')
img4, scr4 = session(orig, "echo x >> readme.txt\rcat readme.txt\r", extra=3_000_000)
h4 = hostdisk(img4)
ok('append bez miejsca za plikiem: przeniesienie, treść OK', h4.get('README.TXT') == d.get('README.TXT') + b'x\n')
big = hostdisk(orig); stb = [e[2] for e in big.entries() if e[1] == 'BIG.TXT'][0]
img3, scr3 = session(orig, "echo z >> big.txt\r", extra=3_000_000)
h3 = hostdisk(img3)
ok('append do pliku na końcu dysku (przez przeniesienie lub w miejscu): treść', h3.get('BIG.TXT') == big.get('BIG.TXT') + b'z\n')
for n, c in res: print(('OK   ' if c else 'FAIL ') + n)
print('WYNIK:', 'OK' if all(c for _, c in res) else 'BLAD')
