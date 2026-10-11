from oslib import session
script = "greet\rgreet Ada\recho Hello | rot13\recho Hello | rot13 | rot13\rls /bin\r"
img, scr = session(open('disk.img', 'rb').read(), script, extra=4_000_000)
print(scr[scr.index('# greet'):])
res = [
    ('greet default', 'Hello, world!' in scr),
    ('greet with argument', 'Hello, Ada!' in scr),
    ('rot13', 'Uryyb' in scr),
    ('rot13 twice is identity', '# echo Hello | rot13 | rot13\nHello\n' in scr),
    ('examples installed in /bin', 'GREET.COM' in scr and 'ROT13.COM' in scr),
]
for n, c in res: print(('OK   ' if c else 'FAIL ') + n)
print('WYNIK:', 'OK' if all(c for _, c in res) else 'BLAD')
