from oslib import session, hostdisk, Disk
orig = open('disk.img','rb').read()
script = ("hello a bb ccc\r" "wc readme.txt\r" "status\r" "wc nofile\r" "status\r"
 "echo one > t.txt\r" "echo two >> t.txt\r" "cat t.txt\r" "echo three > t.txt\r" "cat t.txt\r"
 "cat < readme.txt\r" "cat readme.txt | upper\r" "ls | cat\r" "echo piped text | upper\r"
 "skip readme.txt 40\r" "cp readme.txt notes.txt\r" "cat notes.txt\r" "touch notes.txt\r" "abc\x03" "\recho po ^C ok\r"
 "cat nofile\r" "foo\r" "wc t.txt\r")
img, scr = session(orig, script)
open('screen_min.txt','w').write(scr); print(scr)
h = hostdisk(img)
res = []
ok = lambda n, c: res.append((n, c))
ok('argc/argv', 'hello\na\nbb\nccc' in scr)
ok('exit code 0 / 1 (status)', 'rc 0' in scr and 'rc 1' in scr)
ok('wc: 2 linie, 61 B', '2 61' in scr)
ok('strerror z programu', 'no such file' in scr.split('# wc nofile')[1].split('#')[0])
ok('> i >> (one, two)', 'one\ntwo' in scr)
ok('> obcina (three)', h.get('T.TXT') == b'three\n')
ok('< stdin', scr.count('Pliki ciagle, bloki 256 B.') >= 2)
ok('pipe: upper', 'MINIUNIX: PROSTY SYSTEM DLA 6510.' in scr and 'PIPED TEXT' in scr)
ok('pipe: ls | cat', 'README.TXT' in scr.split('# ls | cat')[1])
ok('PIPE.TMP usunięty', 'PIPE.TMP' not in [e[1] for e in h.entries()])
seg = scr.split('# skip readme.txt 40')[1].split('#')[0]
ok('seek: skip od 40', 'ciagle, bloki 256 B.' in seg and 'Pliki' not in seg and 'MiniUnix' not in seg)
ok('cp nadpisuje (notes == readme)', h.get('NOTES.TXT') == h.get('README.TXT'))
ok('touch istniejący -> file exists', 'touch: file exists' in scr)
ok('^C przerywa linię (abc nie wykonane)', 'abc^C' in scr and 'abc: command not found' not in scr)
ok('cat nofile -> błąd', 'cat: no such file' in scr)
ok('foo -> command not found', 'foo: command not found' in scr)
for n, c in res: print(('OK   ' if c else 'FAIL ') + n)
print('WYNIK:', 'OK' if all(c for _, c in res) else 'BLAD')
