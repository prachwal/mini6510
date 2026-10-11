# C64 test ROMs

The VICE package from most distributions ships **without** the Commodore ROMs. This project does not
need them (the BIOS takes over the machine with ROMs banked out), but VICE refuses to start without
ROM files of the right size, so the build generates stand-ins:

* `kernal.bin` – a tiny replacement for the KERNAL: at reset it copies `mini6510.prg` to `$0801` and
  jumps to its `SYS` stub (what `LOAD"*",8,1 : RUN` does on a real machine).
* `basic.bin` – 8 KB of zeros (never used).
* `chargen.bin` – a character ROM in the real C64 screen-code layout (lower/upper-case set) drawn from
  `font8x8.bin` (a 5x7 dot-matrix ASCII font, 2048 B, 8 bytes per glyph, MSB first).

With real ROMs use `python scripts/run_vice.py --roms DIR` (normal `-autostart` path).
