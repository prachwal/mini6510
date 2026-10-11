# BIOS API (6502 project)

Status: draft, to confirm. Last change: 2026-10-11.

## Purpose
Fixed entry points to BIOS routines used by user programs and the loader. Addresses and conventions are stable, so programs do not depend on the internal organization of the ROM.

## Jump table
At the start of the BIOS, from `$F800`. Each entry is a `JMP` to a routine.

| Address | Name | Status |
|---------|------|--------|
| `$F800` | `I2C_READ` | planned |
| `$F803` | `I2C_WRITE` | planned |
| `$F806` | `PutChar` | planned |
| `$F809` | `PrintStr` | planned |
| `$F80C` | `PutCRLF` | planned |
| `$F80F` | `PrintTime` | planned |
| `$F812` | `LoadSystem` | planned |

The addresses are examples. The fixed layout will be settled before the ROM is burned.

## Calling conventions
- Arguments in registers A, X, Y. The result in A.
- An error is signaled by the C flag: C=1 means error.
- Routines may overwrite A, X, Y and the flags unless described otherwise.
- A program does not assume what the BIOS leaves in memory apart from the result.

## Routines

### `I2C_READ` (`$F800`)
- In: A = 7-bit device address, X = register.
- Out: A = value read, C=0. On error C=1.
- Implementation: I2C controller at `$DF20`, sequence START, address, register, repeated START, READ+NACK, STOP.

### `I2C_WRITE` (`$F803`)
- In: A = 7-bit device address, X = register, Y = value.
- Out: C=0 OK, C=1 error.

### `PutChar` (`$F806`)
- In: A = character.
- Out: A preserved. Sends the character through the 6850 UART (`$DF00/$DF01`), waits for TDRE.

### `PrintStr` (`$F809`)
- In: ptr2 (`$F2/$F3`) = address of a zero-terminated text.
- Out: none. Destroys Y.

### `PutCRLF` (`$F80C`)
- Sends CR and LF.

### `PrintTime` (`$F80F`)
- Reads the time from the DS1307 RTC (`$68`) and prints `HH:MM:SS`.

### `LoadSystem` (`$F812`)
- Loads the first sector from drive 0 (FDC, `$DF10`) to `$0800` and jumps there.
- On error it prints `DISK ERROR` and halts.
- Does not return on success.

## Reserved areas

| Range | Purpose |
|-------|---------|
| `$00-$0F` | BIOS reserve |
| `$10-$1F` | `rtc_buf` (7 bytes of time) |
| `$F0-$F1` | `ptr` (RAM pointer, tests) |
| `$F2-$F3` | `ptr2` (text pointer) |
| `$F4-$F5` | `tmp`, `tmp2` |
| `$F6` | `lines` (shadow of the I2C line state in bit-bang) |
| `$F8` | `ZP_TEST` (CPU type test) |
| `$F9-$FB` | I2C API arguments |

A user program may use `$00-$EF` outside the BIOS reserve. `$0100-$01FF` is the stack.

## Hardware registers (addresses)

| Address | Chip | Description |
|---------|------|-------------|
| `$DE00` / `$DE01` | PIA 6520 | port A (SCL, SDA in bit-bang), CRA |
| `$DF00` / `$DF01` | UART 6850 | status/control, data |
| `$DF10`-`$DF13` | FDC WD1793 | cmd/status, track, sector, data |
| `$DF18` | FDC latch | drive select, motor |
| `$DF20`-`$DF22` | I2C controller | CTRL, DATA, STATUS |

## Dependencies
- `bios-post.s`: POST, `Row`, `PrintStr`, `PutChar`, `PutCRLF`.
- `rtc.s`: reading the DS1307 time, `PrintTime`.
- FDC loader: `LoadSystem` (in ROM).
- Header file `bios.inc` (to be written): fixed addresses of entries and ZP variables.

## To confirm
- [ ] Final addresses of the jump table.
- [ ] Should `PutChar` preserve all registers (more convenient for programs).
- [ ] The format of `bios.inc` and how errors are reported (C flag or a code in A).
- [ ] Should `LoadSystem` be part of the API, or only an internal routine.

## New entries (platform-neutral)

| Address | Name | Description |
|---|---|---|
| $F824 | BIOS_KeyGet | A = ASCII character or 0 (no key); X/Y preserved |
| $F827 | BIOS_TickAck | acknowledges the timer IRQ (C64: read of $DC0D) |
| $F82A | BIOS_TickStart | starts the ~100 Hz timer |
| $F82D | BIOS_RtcRead | reads the time into the buffer pointed to by `ptr` (RTC) |
