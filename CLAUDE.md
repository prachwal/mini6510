# mini6510

BIOS and MiniUnix for 6510-class machines: ports `generic` (py65 model), `c64`, `plus4` (`platforms/`), shared BIOS in `bios/`, kernel in `os/`.

## Documentation layout
- `docs/pl/`: Polish project notes (originals). `docs/en/`: English (translations + newer documents). Index: `docs/README.md`.
- Shared: `docs/img/` (screenshots), `docs/disasm/` (ROM disassemblies). Link to images as `../img/...` from the language folders.
- Decisions go to `docs/pl/decisions.md` and `docs/en/decisions.md` (keep both in step). Plan: `docs/en/roadmap-0.2.md`.
- Newer documents (`drives`, `drivers`, `xip`, `graphics`, `musicplay`, `roadmap-0.2`) are English only for now.

## Build and test
- Build: `CC65_HOME=<cc65> python3 scripts/build.py --platform generic|c64|plus4`.
- Tests: `python3 scripts/test.py` (VICE tests need `C64_ROMS`, `PLUS4_ROMS` with the original ROMs and `dos1541.bin`/`dos1551.bin`; they SKIP without).
- Write tests on copies of disk images only.

## Rules
- Do not guess hardware facts: verify in a primary source and record it in the document.
- Memory is the main constraint: keep to the budget table in `docs/en/roadmap-0.2.md`.
- Commit messages end with the Co-Authored-By and Claude-Session lines when made by Claude.
