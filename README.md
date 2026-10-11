# mini6510

A BIOS and a small Unix-like operating system (**MiniUnix**) for a 64 KB, 6510-based 8-bit machine,
plus a Python machine model that boots and tests them — no hardware or emulator required.

The CPU itself is out of scope: this project defines and tests the **software-visible contract**
of the machine (memory map, I/O registers, BIOS entry points) and everything that runs on top of it.

```
BIOS 6510 V0.1

TEST    RANGE           RESULT
CPU                     OK NMOS
RAM     0002-01FF       OK
RAM     0200-D7FF       OK
RAM     E000-F7FF       OK
RAM     F800-FFFF       OK SHADOW
CONSOLE DF00            OK
DISK    DF10            OK 512 KB
TIMER   DF30            OK 100 HZ

LOADING SYSTEM
MiniUnix 0.1 (6510)
# ls -l
2026-10-11 14:45 BIN/         dir
2026-10-11 14:45 README.TXT   61
# cat big.txt | upper | cat > up.txt
```

## Features

**BIOS (2 KB ROM, shadowed into RAM)** — POST (zero page/stack, full RAM walk, ROM→RAM shadow copy),
console, 256-byte block device loader, timer check, jump table at `$F800` (see [docs/bios-api.md](docs/bios-api.md)).

**MiniUnix kernel (~7 KB at `$0400`)**
- SFS file system: files > 1 block, directories and paths (`/`, `.`, `..`), timestamps from a DS1307 RTC over I²C,
  largest-gap allocation, `defrag`, in-place append
- Shell: redirection (`>`, `>>`, `<`), pipes with streaming 255-byte buffers, background jobs (`&`), `^C`, quoting,
  `ls cd pwd mkdir rmdir cp mv rm touch df defrag date ps kill uptime …`
- Multitasking: up to 4 tasks, cooperative (`k_yield`) and pre-emptive on the timer IRQ
- Relocatable `.COM` programs with argc/argv, exit codes, stdin/stdout/stderr, `errno`-style messages
- Syscall ABI: [`os/sys.inc`](os/sys.inc)

## Quick start

```sh
sudo apt install cc65          # or: brew install cc65  (needs ca65/ld65)
pip install -r requirements.txt
python scripts/build.py        # -> build/bios.rom, build/kernel.bin, build/disk.img
python scripts/test.py         # builds and runs all suites (~2 min)
python scripts/run.py "ls\rcat readme.txt\recho hi | upper\r"   # boot and type keys, print the screen
```

If cc65 is not in `PATH`, set `CC65_HOME` to its root directory.

## Layout

| Path | Contents |
|---|---|
| `bios/` | POST, console, block loader (ca65) and the BIOS ↔ OS register definitions (`bios.inc`) |
| `os/` | MiniUnix kernel, syscall ABI (`sys.inc`), linker configs, standard programs in `os/programs/` |
| `examples/` | Example programs (`greet`, `rot13`) and recorded console sessions |
| `sim/` | Python machine model: 6510 (py65), RAM/ROM shadow, console, block device, timer, I²C + RTC |
| `tools/` | `sfs.py` (disk image / SFS), `mkdisk.py`, `mkcom.py` (relocatable `.COM` builder) |
| `tests/` | End-to-end tests driving the real ROM and kernel through the simulated console |
| `scripts/` | `build.py`, `test.py`, `run.py` |
| `docs/` | Platform contract, architecture, decisions and verification notes (Polish) |

## Writing a program

Programs are relocatable `.COM` files loaded into 12 KB slots. Entry: `A` = argc, `X/Y` = argv table.
Exit with `RTS` (A = exit code) or `k_exit`. Free zero page: `$E0–$EF`.

```asm
        .include "sys.inc"
        .segment "CODE"
        lda #<msg
        ldx #>msg
        jsr k_puts
        lda #0
        rts
msg:    .byte "Hi!", 10, 0
```

Drop the file into `examples/programs/` (or `os/programs/`) and run `python scripts/build.py`;
it ends up in `/bin` on the disk image. See [`examples/`](examples/README.md).

## Status

Everything is verified against the **Python model** of the platform only. Running it on a real
6510 machine or another emulator requires that machine to honour the contract in
[docs/platform.md](docs/platform.md) (some items there are still marked "to be confirmed").
Known limits: no memory protection, no users/permissions, files ≤ 64 KB, polled console input.

## License

MIT — see [LICENSE](LICENSE).
