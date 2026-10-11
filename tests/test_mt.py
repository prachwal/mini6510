from oslib import session, hostdisk, Disk
orig = open('disk.img','rb').read()
script = ("ps\r" "cat big.txt | upper | cat > up.txt\r" "echo abc | upper | upper | upper\r" "ls | upper\r"
          "tick a 3 &\r" "tick b 3 &\r" "ps\r" "\r" "tick x 2\r" "status\r"
          "loop &\r" "ps\r" "kill 1\r" "ps\r" "loop &\r" "loop &\r" "loop &\r" "loop &\r" "ps\r"
          "kill 1\rkill 2\rkill 3\r" "wc nofile\r" "status\r" "cat < readme.txt | upper\r" "echo end\r")
img, scr = session(orig, script)
open('screen_mt.txt','w').write(scr); print(scr)
h = hostdisk(img)
res = []; ok = lambda n, c: res.append((n, c))
ok('ps: shell działa', '0 R shell' in scr)
big = h.get('BIG.TXT')
ok('streaming 3 zadań: cat|upper|cat > up.txt (4700 B, pełne)', h.get('UP.TXT') == big.upper())
ok('3 relokowane kopie upper w slotach 1-3', '\nABC\n' in scr)
ok('builtin | program: ls | upper', 'README.TXT   61'.upper() in scr.upper() and 'BIN/ ' in scr)
seg = scr[scr.index('# tick x 2') + 11:]
seq = ['a 1', 'b 1', 'x 1', 'a 2', 'b 2', 'x 2', 'a 3', 'b 3']
pos = [seg.index(x) for x in seq]
ok('a, b (tło) i x (pierwszy plan) przeplatają się: a1 b1 x1 a2 b2 x2 a3 b3', pos == sorted(pos))
ok('zadanie w tle kończy: "] done"', '] done' in scr)
ok('tick x 2 kończy się, rc 0', 'rc 0' in scr)
ok('ps pokazuje loop', ' loop\n' in scr)
ok('kill zamyka zadanie', scr.count('R loop') >= 3)
ok('4. zadanie -> brak wolnego slotu', 'loop: no free task slot' in scr)
ok('wc nofile rc 1 (zadanie)', 'rc 1' in scr)
ok('cat < plik | upper', scr.count('MINIUNIX: PROSTY SYSTEM DLA 6510.') >= 1)
ok('shell żyje na końcu', scr.rstrip().endswith('#') and '\nend\n' in scr)
for n, c in res: print(('OK   ' if c else 'FAIL ') + n)
print('WYNIK:', 'OK' if all(c for _, c in res) else 'BLAD')
