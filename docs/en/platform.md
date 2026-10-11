# Platform: the contract for the BIOS and OS

Scope: only what the software sees (the boundary of CPU/bus/devices). Out of scope: BOM, decoding and gating in hardware, chip internals, timing details below the register level.
Status: a draft from 2026-10-11. Items marked "to confirm" are default proposals.

## 1. Memory map (64 KB)

| Range | Contents |
|-------|----------|
| `$0000-$D7FF` | RAM (with the 6510 CPU: `$0000-$0001` is the CPU port, not RAM) |
| `$D800-$DFFF` | I/O (see 2). Takes precedence over RAM |
| `$E000-$F7FF` | RAM |
| `$F800-$FFFF` | ROM after reset, shadow RAM (a copy of the ROM) afterwards. Vectors `$FFFA-$FFFF` |

Rules visible to a program:
- A write to `$F800-$FFFF` always goes to RAM. A read depends on the shadow latch.
- A read of an address with no device returns an undefined value (do not rely on it).
- Vectors: `$FFFA` NMI, `$FFFC` RESET, `$FFFE` IRQ/BRK.

## 2. Devices (register interface)

### Shadow latch, `$DE00` (write)
- Bit 0: 0 = read `$F800-$FFFF` from ROM (the state after reset), 1 = from RAM.

### Serial console, `$DF00` / `$DF01`
- `$DF00` write: CONTROL. `$03` = reset, `$15` = 8N1, clock /16. Read: STATUS.
- STATUS: bit 0 = there is a byte in the receive buffer, bit 1 = can transmit, bit 5 = receive buffer overflow (a byte was lost; cleared by reading STATUS, then DATA, as in the 6850).
- Until configured after reset, bit 1 is not guaranteed. First reset, then configuration, only then polling.
- `$DF01`: DATA (write = transmit, read = take the oldest byte from the receive buffer).
- `$DF02`: RXCOUNT (read) = the number of bytes in the receive buffer.
- A 64 B FIFO receive buffer (proposal). When full, a new byte is lost and sets bit 5 of STATUS. Transmission without a buffer (one byte, bit 1 of STATUS).
- Choosing the depth: with 8N1 one character is 10 bits. 9600 baud = 960 characters/s (about 10 per 100 Hz tick), 115200 baud = 11520 characters/s (about 115 per tick). 64 B lasts about 66 ms at 9600 and about 5.5 ms at 115200.
- To confirm: a 6850-compatible interface or an own simpler one (STATUS/DATA without a reset sequence).

### Block device (disk), `$DF10-$DF18`
Linear addressing by block number, without tracks and sectors. A block = 256 B. The device moves data between the medium and RAM itself (the device is the bus master during the transfer).
- `$DF10`: CMD (write), STATUS (read).
  - CMD: `$00` RESET, `$01` READ BLOCK, `$02` WRITE BLOCK, `$03` INFO (refreshes SIZE).
  - STATUS: bit 0 = busy (BUSY), bit 1 = error (code in ERR), bit 2 = no medium, bit 3 = write protected.
- `$DF11` / `$DF12`: BLK lo / hi, the block number (16 bit, up to 65536 blocks = 16 MB).
- `$DF13` / `$DF14`: ADDR lo / hi, the address of the 256 B buffer in RAM (outside I/O and ROM; otherwise error 5).
- `$DF15` / `$DF16` (read): SIZE lo / hi, the number of blocks of the medium (0 = 65536), valid after INFO.
- `$DF17` (read): ERR. 0 = OK, 1 = block out of range, 2 = read or write error, 3 = no medium, 4 = write protected, 5 = bad buffer address. Cleared when a new command starts.
- `$DF18`: UNIT, drive select 0-3 (0 after reset).
- BUSY is set immediately after writing CMD, so STATUS is valid at once. The operation time is unspecified: wait for BUSY = 0.
- While BUSY, do not change BLK, ADDR or the buffer. After BUSY = 0 the data is in RAM (READ) or on the medium (WRITE).
- Interrupts: none (polling).

### I2C controller, `$DF20-$DF22`
- `$DF20` CTRL (write): bit 0 START, bit 1 STOP, bit 2 WRITE, bit 3 READ, bit 4 NACK after a read.
- `$DF21` DATA: the byte to send or the last one received.
- `$DF22` STATUS (read): bit 0 busy, bit 1 NACK.
- Devices on the bus: settings EEPROM `$50`, real-time clock `$68` (time in BCD, bit 7 of the seconds = clock halted).
- An EEPROM write takes several ms: during that time the address answers NACK, so retry.

### System clock (timer), `$DF30-$DF33`
- `$DF30` CTRL (write): bit 0 = clock enabled, bit 1 = IRQ reporting enabled. 0 after reset.
- `$DF31`: read = STATUS (bit 0 = a tick is pending), write of any value = acknowledge (clears bit 0).
- `$DF32` DIV (write/read): the tick period in units of 1 ms. 10 after reset (that is 100 Hz). The value 0 is treated as 256.
- `$DF33` COUNT (read): the tick counter modulo 256, grows regardless of acknowledgements.
- The period is given in real time, not in CPU cycles.
- The IRQ line is active when bit 0 of STATUS = 1 and bit 1 of CTRL = 1. It stays active until acknowledged. No acknowledgement = entering the interrupt again.
- A tick when the previous one is not cleared does not accumulate (bit 0 stays 1).

### Interrupts
- The IRQ/BRK vector `$FFFE` is shared. The handler tells BRK apart by the B flag in the P register copied to the stack.
- After the shadow, the vectors `$FFFA-$FFFF` are in RAM, so the OS can change them. After start the BIOS has IRQ disabled (flag I=1), and the OS enables it deliberately.
- IRQ sources: the system clock. Console and disk: polling only (to confirm).
- NMI: no device raises it (to confirm).

## 3. Startup contract

1. Reset: the CPU reads the vector from `$FFFC`, ROM visible.
2. The BIOS copies `$F800-$FFFF` to RAM and sets the latch to 1.
3. POST: CPU type, RAM (excluding I/O and the BIOS code after the shadow), console, disk, a table of results.
4. A SETUP window (key `s`), settings in the EEPROM.
5. Loading the system from disk and a jump to the entry point.

The system disk format (drive 0, 256 B blocks):
- Block 0 (header): bytes 0-1 load address, byte 2 number of data blocks, bytes 3-4 start address.
- Blocks 1.. data, in order, at the load address.
- The image must fit in RAM below `$D800` and above `$0200`. The loader checks: load address >= `$0200`, number of blocks 1-255, end of the image <= `$D800` (an unaligned address is counted too). The start address is not validated.
- Boot errors: the message `BOOT ERROR n`, then a halt. `n` = 1-5 the ERR code of the block device, 6 operation timeout (65536 loop iterations, about 1 s at 1 MHz), 7 bad header.
- Implementation: `loader.s` (229 B with messages), constants in `bios.inc`.

State on entering the system: IRQ interrupts disabled, shadow active, memory `$F800-$FFFF` contains the BIOS, zero page `$F0-$FF` reserved for the BIOS.

## 4. BIOS jump table (from `$F800`, 3-byte `JMP` entries)

| Address | Function | In | Out |
|---------|----------|----|-----|
| `$F800` | `I2C_READ` | A = 7-bit address, X = register | A = value, C=1 error |
| `$F803` | `I2C_WRITE` | A = address, X = register, Y = value | C=1 error |
| `$F806` | `PutChar` | A = character | A preserved |
| `$F809` | `PrintStr` | text pointer (zero page), zero-terminated text | none |
| `$F80C` | `PutCRLF` | none | none |
| `$F80F` | `PrintTime` | none | prints HH:MM:SS |
| `$F812` | `LoadSystem` | none | does not return on success |

Proposals to confirm (needed by the OS):
- `ReadBlock` (`$F815`) and `WriteBlock` (`$F818`): A = drive, X = block lo, Y = block hi, buffer address in `ptr` (`$F0/$F1`). Out: C=0 OK, C=1 error with the ERR code in A. The BIOS waits for BUSY = 0.
- `GetChar` (console read, blocking or not), `GetTime`/`SetTime`.
Conventions: arguments in A, X, Y; an error = the C flag; A/X/Y/flags may be changed unless described otherwise.

## 5. Behaviors visible to a program (to take into account in the BIOS)

- Disk: after writing CMD, STATUS is valid at once (BUSY set). Wait for BUSY = 0, preferably with a timeout.
- Console: transmission only after configuration (see 2).
- EEPROM write: retry after NACK with a limit.
- The RAM test does not cover: I/O, `$F800-$FFFF` (tested from a copy in low RAM), the zero page and the stack used by the test.

## 6. The OS (to agree)

- System calls: through the BIOS jump table (`JSR`) or `BRK` with a function number.
- The file system, the format of executable programs, error handling.
- Zero page: the split between the BIOS (`$F0-$FF`, exception: the CPU port `$00-$01` with the 6510) and the OS and programs.

### Terminal: output with positioning and a minimal tty (proposal)
- The screen is a terminal on the host side (ANSI/VT100) connected to the serial console. Positioning is character sequences, with no separate video device. Size 80x24 (to confirm). `ESC` = `$1B`.
- A minimal set of output sequences:
  - `ESC [ 2 J`: clear the screen. `ESC [ H`: cursor to the top left corner.
  - `ESC [ r ; c H`: cursor to row `r`, column `c` (numbered from 1, decimal numbers without leading zeros).
  - `ESC [ K`: clear from the cursor to the end of the line.
  - `ESC [ n A` / `B` / `C` / `D`: cursor up / down / right / left by `n`.
  - Optionally: `ESC [ ? 25 l` / `h` (hide/show the cursor), `ESC [ 7 m` / `0 m` (reverse/normal).
- Control characters: CR `$0D` start of line, LF `$0A` down, BS `$08` back, BEL `$07` bell.
- BIOS: `PutChar` raw, without translations. Additional routines to confirm: `ConClear`, `ConClearEol`, `ConGotoXY` (A = row, X = column, numbered from 0; the BIOS prints the decimal numbers itself after adding 1).
- A minimal tty in the OS (line discipline):
  - Line mode (the default): characters go to a line buffer (e.g. 80 B) with echo; `BS`/`DEL` deletes the last character (sends `BS`, space, `BS`); `^U` deletes the line; `CR` ends the line and returns it to `read` (on input `CR` -> `LF`).
  - Output: `LF` -> `CR LF`.
  - Raw mode: characters without echo and editing (editors, games). Switched by a system call.
  - `^C` interrupts the program (needs signals, later).
- Alternative: a text screen memory (e.g. 80x25 bytes at a fixed address), positioning by writing to memory. Needs a new video device and a window in the memory map. Postponed.

### Running commands, e.g. `ls` (proposal)
1. `LoadSystem` loads the kernel, which starts the shell (the first process) with descriptors 0, 1, 2 connected to `/dev/tty` (the console).
2. The shell reads a line from descriptor 0 and splits it into words.
3. A built-in command (`cd`, `exit`) it executes itself. Otherwise it looks for a file in the directories of a path list (e.g. `/bin/ls`) on the block device.
4. `spawn(path, arguments)`: the kernel opens the file, reads the program header (marker, sizes of code, data and BSS, the relocation table, the entry point), allocates a contiguous RAM block below `$D800`, copies the program, applies the relocations, copies the arguments, inherits descriptors 0, 1, 2 (redirections and pipes are swapping descriptors before the start), creates a task (own stack and zero page) and starts it.
5. `ls` as a program: `open` of the directory, `readdir` in a loop, for each name `write(1, ...)`, `exit(0)` at the end.
6. The shell does `wait`; after the program ends the kernel frees its RAM block and the shell prints the prompt.
- Minimal system calls: `open`, `close`, `read`, `write`, `readdir`, `spawn`, `wait`, `exit`, `chdir`. The function number in A, arguments in X/Y and in a small parameter block in zero page. Entry through `JSR` to the OS table or `BRK` (to confirm).
- First version (one task): as in CP/M, a program loaded at a fixed address (e.g. `$0800`) without relocation, the shell suspended while it runs. Relocation and multiple tasks later.

### Unix-like on this platform (proposal)
- A Unix-like (not a full Unix) is realistic: without an MMU there is no `fork` and no memory protection, use `spawn` instead of `fork`.
- 6502/6510 limits: a fixed stack on page `$01` (256 B) and a small zero page, so tasks need saving/restoring the stack and zero page on a switch and relocatable programs (LUnix and GeckOS do it this way; GeckOS: 4 tasks with a shared stack, 16 with stack copying).
- Minimal version: file descriptors (`open`/`read`/`write`/`close`), devices as files (`/dev/tty`), a simple file system on a block device, pipes, a shell, `spawn`. One task first, multitasking later.
- Preemption is enabled by the system clock (`$DF30`, 100 Hz by default). The console has a hardware 64 B FIFO, so at 9600 baud polling in the clock interrupt (100 Hz) is enough. A faster link needs a console IRQ.
- Programs: a relocatable format with a header (sizes, relocations).

## 7. Out of the contract's scope

BOM and the diagram, decoder logic and ROM/RAM gating, clock and baud generator chips, drive power, FDC/UART internals, timing models below the register level.

## 8. Open questions

- [ ] Console: 6850-compatible or an own simple one?
- [x] Disk: a block interface (block number, buffer in RAM). Indicated by the user 2026-10-11.
- [ ] Should a disk transfer halt the CPU, or does the CPU keep running during BUSY (currently: it runs, do not touch the buffer)?
- [ ] Are the 256 B block size and the number of blocks (a 16-bit number = up to 16 MB) enough?
- [ ] Interrupts: polling only, or IRQ from the console and the timer?
- [ ] BIOS functions for the OS: `GetChar`, `ReadBlock`/`WriteBlock`, time.
- [ ] OS system calls: a jump table or `BRK`.
- [x] A time device with a periodic IRQ: added (`$DF30-$DF33`, 100 Hz by default), indicated by the user 2026-10-11.
- [ ] Should the console raise an IRQ (character received), or is polling in the clock interrupt enough (depends on the link speed)?
- [ ] The depth of the console FIFO: 64 B (proposal) or other?
- [ ] Multitasking from the start, or one task first?
- [x] Screen: an ANSI terminal over the serial console (a text screen memory rejected). Indicated by the user 2026-10-11.
- [ ] Screen size (80x24?) and whether the BIOS provides `ConClear`, `ConClearEol`, `ConGotoXY`.
