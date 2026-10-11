# mini6510

BIOS i prosty system Unix-podobny (**MiniUnix**) dla 8-bitowej maszyny z 64 KB RAM opartej o 6510,
wraz z modelem maszyny w Pythonie do uruchamiania i testowania — bez sprzętu i emulatora.

Sam procesor jest poza zakresem projektu: opisujemy i testujemy **kontrakt widoczny dla oprogramowania**
(mapa pamięci, rejestry I/O, punkty wejścia BIOS) oraz wszystko, co działa na nim.

## Szybki start

```sh
sudo apt install cc65 && pip install -r requirements.txt
python scripts/build.py     # build/bios.rom, build/kernel.bin, build/disk.img
python scripts/test.py      # wszystkie testy (~2 min)
python scripts/run.py "ls -l\recho hi | upper\r"
```

Dokumentacja projektowa (po polsku) jest w [`docs/`](docs/): `platform.md`, `bios-api.md`, `architecture.md`, `decisions.md`.
Pełny opis funkcji i układ katalogów: [README.md](README.md).
