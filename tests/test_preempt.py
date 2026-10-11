from oslib import session, hostdisk
orig = open('disk.img','rb').read()
script = "count a &\rcount b &\rps\ruptime\r" + "\x00"*5000 + "ps\r"
img, scr = session(orig, script, extra=300_000)
open('screen_preempt.txt','w').write(scr); print(scr[scr.index('# count a'):])
seg = scr[scr.index('# count a'):]
body = ''.join(c for c in seg.split('# ps')[0] if c in 'ab' )
# znaki a/b wypisane przez zadania (po uruchomieniu)
out = seg[seg.index('[2]'):]
import re
letters = ''.join(re.findall(r'(?m)^[ab]+$|[ab]', out.split('# uptime')[0].split('# ps')[0] if False else out))
res = []; ok = lambda n, c: res.append((n, c))
txt = out.replace('\n', '')
lett = ''.join(ch for ch in txt if ch in 'ab')
first_a, last_a = lett.index('a'), lett.rindex('a')
ok('oba zadania bez yield dostały CPU (po 16 znaków)', lett.count('a') == 16 and lett.count('b') == 16)
ok('wywłaszczanie: b pojawia się między a', 'b' in lett[first_a:last_a])
ok('zadania w tle zakończone ([N] done)', scr.count('] done') >= 2)
ok('uptime liczy impulsy zegara', 'ticks (10 ms)' in scr)
for n, c in res: print(('OK   ' if c else 'FAIL ') + n)
print('WYNIK:', 'OK' if all(c for _, c in res) else 'BLAD')
