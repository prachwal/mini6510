# mini6510

BIOS i prosty system Unix-podobny (**MiniUnix**) dla 8-bitowej maszyny z 64 KB RAM opartej o 6510,
wraz z modelem maszyny w Pythonie do uruchamiania i testowania — bez sprzętu i emulatora.

Sam procesor jest poza zakresem projektu: opisujemy i testujemy **kontrakt widoczny dla oprogramowania**
(mapa pamięci, rejestry I/O, punkty wejścia BIOS) oraz wszystko, co działa na nim.

## Zrzuty ekranu (VICE, C64)

| Powłoka: `ls -l` z datami | Potoki: filtry `rot13` i `upper` | Programy, katalogi, zegar |
|---|---|---|
| ![ls](docs/img/c64-ls.png) | ![pipes](docs/img/c64-pipes.png) | ![dirs](docs/img/c64-dirs-date.png) |

### Przykłady

```
# echo Hello | rot13
Uryyb
# cat readme.txt | upper
MINIUNIX: PROSTY SYSTEM DLA 6510.
# mkdir d1
# cd d1
# pwd
/D1
# date
2026-10-11 09:01:34
# loop &
[1]
# ps
```

## Szybki start

```sh
sudo apt install cc65 && pip install -r requirements.txt
python scripts/build.py     # build/bios.rom, build/kernel.bin, build/disk.img
python scripts/test.py      # wszystkie testy (~2 min)
python scripts/run.py "ls -l\recho hi | upper\r"
```

Dokumentacja projektowa (po polsku) jest w [`docs/`](docs/): `platform.md`, `bios-api.md`, `architecture.md`, `decisions.md`.
Pełny opis funkcji i układ katalogów: [README.md](README.md).
