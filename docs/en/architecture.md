# 01 - Architecture (6502)

## Bus
- One address bus (16 bit) and one data bus (8 bit).
- The CPU does not distinguish RAM, ROM and devices: every access is a read or a write at an address.

## I/O devices
- Model: memory-mapped I/O. Each device has an address range, and its registers are accessed like memory.
- Example: an output chip at `$D000`. `STA $D000` sends a byte, `LDA $D001` reads the status.
- DMA: the 6502 itself has none. Possible only through an external DMA controller that takes over the bus.

## Address decoding
- The address decoder selects a component when the address falls in its range (chip select).
- The remaining address bits select a register or a byte inside the component.
- In hardware: the upper address bits (e.g. A15-A13) go to gates or a decoder (e.g. 74138). The CS output is active when the pattern matches.
- In the emulator: a list of ranges (`base`, `size`, component). For an access the matching range is looked up and the component gets the offset. Overlapping ranges must be forbidden or given a priority.
- Example details: `04-memory.md`.

## Mapping in the emulator (proposal)
- The bus holds a table: address range -> component.
- Each component (RAM, ROM, device) implements a common read and write interface.
- The CPU uses only the bus and does not know the concrete components.

## DMA and sound implementation (NES, proposal)
- OAM DMA (`$4014`): copying 256 bytes immediately on the write, plus 513/514 CPU cycles. The accurate version spreads the copy over cycles.
- DMC DMA: stealing 1-4 CPU cycles when a sample is read.
- APU: clocked every second CPU cycle, frame counter about 240 Hz or 120 Hz, non-linear mixing, resampling to 44.1/48 kHz.
- A ring buffer; synchronizing the CPU speed with audio playback.

## Clock and synchronization (proposal)
- Each CPU step returns the number of cycles. The other components are clocked at a fixed ratio (NES: PPU 3x, APU 1x per CPU cycle).
- Real-time pace: `Stopwatch.GetTimestamp()` with an accumulator instead of `Thread.Sleep`.
- Best synchronization: driving it by the audio buffer level.
- In a loop without allocations, `Step()` returns `int`.

## Framebuffer (proposal)
- The PPU writes palette indices (`byte`, NES 0-63). Conversion to ARGB through a `uint[64]` table.
- A fixed buffer, allocated once; double buffering by swapping references.
- Sending to the screen once per frame, taking `stride` into account.
- Rendering by lines, without per-pixel calls.

## Display in the UI (proposal)
- WPF: `WriteableBitmap` (Bgra32), `Lock`/`Buffer.MemoryCopy`/`AddDirtyRect`/`Unlock`, an `Image` with `NearestNeighbor`, refresh through `CompositionTarget.Rendering`.
- Avalonia: `WriteableBitmap.Lock()` returns an `ILockedFramebuffer` (`Address`, `RowBytes`), an `Image` with `BitmapInterpolationMode="None"`, `InvalidateVisual()`. For shaders: `OpenGlControlBase`.
- Emulation on a separate thread, the UI only copies and refreshes.

## NES sprites (proposal)
- OAM: 64 sprites of 4 bytes: Y (position minus 1), tile, attributes (palette 0-1, bit 5 priority, bit 6 H-flip, bit 7 V-flip), X.
- Size 8x8 or 8x16 (PPUCTRL); in 8x16 bit 0 of the tile selects the pattern table.
- Evaluation at the start of a line, a limit of 8 sprites per line (overflow flag).
- Color 0 is transparent. Mixing with the background by priority.
- Sprite 0 hit for scroll synchronization.

## Commodore sprites (VIC-II, C64)
- 8 hardware sprites, 24x21 pixels, 63 bytes of data (a 64 B block).
- A pointer in screen memory (by default `$07F8-$07FF`), address = pointer x 64 in the VIC bank.
- Modes: hi-res (2 colors) or multicolor (4 colors, wider pixels).
- Registers: `$D000-$D00F` positions (bit 9 of X in `$D010`), `$D015` enable, `$D017`/`$D01D` expansion, `$D01B` priority, `$D01C` multicolor, `$D027-$D02E` colors, `$D01E`/`$D01F` collisions (cleared on read).
- The VIC sees 16 KB selected through CIA2 (`$DD00`).
- Plus/4 (TED): no hardware sprites. C128 in 80-column mode: VDC, no sprites.

## Specialized Commodore chips (from memory, to verify)
- VIC-II (6567/6569): video, 8 sprites. C64, C128.
- VIC-I (6561): video. VIC-20.
- TED (7360/8360): video, sound, timers, keyboard. Plus/4, C16, C116.
- SID (6581/8580): sound, 3 voices, filters. C64, C128.
- CIA 6526 (x2): timers, I/O, keyboard, interrupts. C64, C128.
- VIA 6522 (x2): I/O, timers. VIC-20, PET, the 1541 drive.
- PIA 6520: I/O. PET.
- CRTC 6545: video controller. PET.
- VDC 8563/8568: 80-column video. C128.
- MMU 8722: memory banks. C128.
- PLA 82S100: address decoding. C64.
- Each chip is a separate component on the bus with its own address range.

## References (checked locally, shallow clones in /home/claude/<owner>/<repo>)
6502/NES repositories in C#:
- barryw/e6502 (https://github.com/barryw/e6502): a full 6502 platform with a RealTimeCycleScheduler (Stopwatch), CPU.cs with NMOS/CMOS and cycle counting (ClocksForNext), OpCodeTable.cs, BusDevice.cs, IBusDevice.cs, VirtualDmaController.cs, SidChip.cs, Rendering/SpriteRenderer.cs, tests in e6502UnitTests.
- DualBrain/EMU6502 (https://github.com/DualBrain/EMU6502): a small 6502 interpreter in MOS6502.cs, a Cycle event raised every cycle, full BCD, bug emulation marked with the BUG symbol, RAM64K.cs.
- Xyene/Emulator.NES (https://github.com/Xyene/Emulator.NES): a full NES in dotNES/. CPU.Core.cs (ExecuteSingleInstruction, Cycle), CPU.IORegisters.cs (case 0x4014: OAM DMA), PPU.Memory.cs (PerformDMA), Addressable.cs (read map through delegates), mappers (MMC1, MMC3 etc.).
- RupertAvery/Fami (https://github.com/RupertAvery/Fami): NES in Fami.Core/. CPU/CpuExecution.cs (PPU every 3 cycles, counting down instruction cycles), Bizhawk/APU.cs (DMC DMA with the dmc_dma_countdown counter), Audio/ (Oscillator, Sweeper, Envelope, BlipBuffer), Video/Ppu.cs, SpriteScanline.cs, LoopyRegister.cs.
- McNeight/6502Net and farell/6502net: a 6502 simulator in WPF with functional tests (Processor/Processor.cs, Processor.UnitTests/FunctionalProcessorTests.cs).
- plnelson/nes: UWP code only, little to use.

Notes: I did not check the licenses or full correctness. First to read: DualBrain (a small, readable CPU) and Fami (APU, PPU, DMA).

## Text terminal over UART (proposal)
- Keyboard and screen on the PC side (a VT100/ANSI terminal).
- UART 6850 (ACIA), e.g. `$DF00` status/control, `$DF01` data.
- Status: bit 0 RDRF (data to read), bit 1 TDRE (can send).
- Settings 9600 or 19200 baud, 8N1.
- Polling: getchar waits for RDRF, putchar waits for TDRE. IRQ optional.
- Emulator: an input queue (host keys), output to `Console.Out`.

## CP/M-compatible disk drive (proposal)
- FDC controller: WD1793/1770, Intel 8272 or NEC uPD765.
- Registers: command/status, track, sector, data. Control: drive select, motor, side. An interrupt or an end flag.
- BIOS: SELDSK, SETTRK, SETSEC, SETDMA, READ, WRITE. Sector layout from the Disk Parameter Block (DPB).
- Emulator: a component on the bus, data from an `.img` file (sectors in order). Without modeling physical rotation.
- Own OS: own disk format and API, without a DPB.

## Boot from disk (proposal)
- The ROM (RESET vector) initializes the UART, the FDC and memory.
- RESTORE to track 0, READ sector 1 to a fixed RAM address (e.g. `$0800`), jump to that address.
- The ROM is usually 1-2 KB, so the loader is short. If the system is larger, the first sector loads the rest (a loop over sectors).
- Emulator: the first sector of the `.img` is the data to load, read by the FDC component.

## EEPROM with settings (proposal)
- Stores BIOS settings: default drive, UART speed, RAM size, date.
- Chips: 24C02 (I2C, 256 B, bit-banging through the PIA), 93C46 (Microwire, 128x16 bit), X2212 (NVSRAM with backup).
- Slow writes (ms per byte or page), a limited number of writes. Write only on change.
- A checksum. After an error, defaults. Protection against writing during startup.
- Emulator: a component writing to a file (e.g. `settings.bin`) on change. The write time is optional.

## Shadow ROM (proposal)
- The BIOS in ROM/EPROM/Flash is copied to RAM at startup. A switch (e.g. an I/O register) disconnects the ROM and the RAM takes over that range.
- Benefits: faster code, the ability to patch. Cost: copy time, RAM used.
- The EEPROM with settings is not suitable for executing code (too small, too slow).
- Emulator: a copy of the ROM in a RAM array, the switch register changes the mapping of the range.
- The copy is done by the CPU in a loop. The PIA 6520 does not copy memory, it only provides a mapping switch bit (like the `$0001` bits in the C64).
- Copying without the CPU needs a DMA controller (e.g. Intel 8237) with bus arbitration. Not needed at the start.

## Minimal bootloader (example, ca65)
- UART 6850: reset `$03`, 8N1 configuration `/64` = `$15`. TDRE = status bit 1.
- A message and halt, NMI/RESET/IRQ vectors at `$FFFA-$FFFF`.
- Size: about 90-100 B of code and message + 6 B of vectors. Shadow ROM adds a dozen or so bytes.
- A 2 KB chip is enough with room to spare. With a full loader from disk (FDC) the size grows.

## Chip list (BOM, proposal)
- CPU: 6502 (or 6510/8502). Clock: a 2 MHz crystal with a divider into phi1/phi2, or 1 MHz.
- Reset: RC + a Schmitt gate (74HC14).
- ROM: 2716/27C16 or 28C64. RAM: 62256 (32 KB), for 128 KB two chips or bank switching.
- Decoder: 74HC138. Bank register: 74HC373/574.
- UART: 6850 (ACIA). RS-232 levels: MAX232/MAX3232. A DE-9 connector.
- Optional: PIA 6520 (shadow ROM, I2C), EEPROM 24C02 (settings), FDC WD1793/8272 + a drive connector.
- Power: 7805, capacitors. Logic: 74HC00, 74HC02, 74HC32. Pull-ups for IRQ/NMI/RDY.
- A Z80 instead of the 6502 (CP/M): the clock, the vectors and the decoder change.

## FDC loader (example, ca65)
- Prints `LOADING SYSTEM` over the UART, turns on drive 0 and the motor (`$DF18`), waits for spin-up.
- RESTORE (`$00`), checking TR00 (bit 2). Sector 1 is read with the command `$80` in a DRQ loop to `$0800`.
- Errors: LOST (bit 2), CRC (bit 3), RNF (bit 4). On an error `DISK ERROR` and halt. On success: a jump to `$0800`.
- FDC registers: `$DF10` cmd/status, `$DF11` track, `$DF12` sector, `$DF13` data. Delays depend on the clock.

## Build and run (proposal)
- ROM: `ca65 boot.s -o boot.o`, `ld65 -C rom.cfg boot.o -o boot.bin` (MEMORY ROM: start `$F800`, size `$0800`). The result is 2048 B.
- A program on disk: `ca65 sys.s -o sys.o`, `ld65 -C sys.cfg` with `.org $0800`, then `dd ... bs=256 count=1` into `disk.img` (track 0, sector 1).
- Emulator: `boot.bin` at `$F800`, `disk.img` as drive 0, RESET.
- Hardware: burn `boot.bin` into an EPROM/EEPROM, put the disk image on a medium, power on.

## POST (startup check, proposal)
- Order: CPU (NMOS/CMOS), RAM (patterns $55/$AA in $0200-$7FFF), UART (status after reset), FDC (FORCE INTERRUPT, `$FF` = no chip), then a table of results.
- Entering SETUP: about 2 s for the key `s` (RDRF). Setup is a subroutine in the same BIOS chip.
- Code: `bios-post.s` (ca65). The RAM test destroys `$0200-$7FFF`, so the BIOS variables live in ZP or on the stack.
- To refine: ROM checksum, EEPROM check, RAM size from the test, the SETUP menu.

## RTC (proposal)
- DS1307 (I2C, `$68`, 32.768 kHz, battery). On the same bus as the 24C02 EEPROM (`$50`).
- Alternatives: DS1302 (3-wire), MC146818 (parallel, more lines).
- I2C in software on the PIA: PA0 = SCL, PA1 = SDA, open-drain lines (DDR=1 pulls to 0, DDR=0 releases). 4.7 kOhm pull-up resistors.
- Reading the time: pointer `$00`, repeated start, 7 BCD bytes. Bit 7 of the seconds is CH (oscillator halted).
- Code: `rtc.s` (ca65). Match the I2C delays to the clock (min. about 4.7 us).
- Emulator: a DS1307 model with the host clock or simulated time, I2C as state.

## I2C controller with registers (proposal)
- Base `$DF20`: CTRL (write: bit0 START, bit1 STOP, bit2 WRITE, bit3 READ, bit4 NACK), DATA (the byte to send / last received), STATUS (bit0 BUSY, bit1 NACK).
- The controller times the bits and ACK itself. The CPU only writes data and waits for BUSY=0. A BIOS without delay loops.
- Emulator: a component with a state machine; on the bus DS1307 and 24C02 models (register pointer, ACK). Bit times can be skipped.
- A ready equivalent: the Philips PCF8584 (obsolete, but designed for 8-bit).
- The bit-banging from `rtc.s` stays as a fallback when there is no controller.

## I2C API in the BIOS (proposal)
- A jump table at the start of the BIOS: `I2C_READ` = `$F800`, `I2C_WRITE` = `$F803`. A fixed address for programs.
- `I2C_READ`: A = 7-bit address, X = register -> A = value, C=1 error. `I2C_WRITE`: A = address, X = register, Y = value, C=1 error.
- The START/ACK/STOP sequence in the BIOS, on the controller at `$DF20`. A program uses `bios.inc` with the addresses and the convention.
- ZP variables used: `$F9`-`$FB`.

## Components from Arduino (scope)
- Directly through the API: I2C (known address and registers), UART (GPS modules, BT, text controllers).
- Requires additional logic: SPI (a controller or bit-banging), analog sensors (ADC), timing (1-Wire, DHT22, WS2812, HC-SR04).
- Does not work: USB, Arduino C++ libraries (must be rewritten).
- Solution: a bridge microcontroller (Arduino). It handles the protocols, the 6502 sends commands over the UART or a shared register.
- Voltages: 5 V vs 3.3 V, check for each module.

## Diagram of the current architecture (as of 2026-10-11)
- CPU 6502 (reset, IRQ, NMI) -> bus of 16 address bits + 8 data bits.
- Under the bus: ROM 2 KB (`$F800`, start), RAM 32 KB (`$0000-$7FFF`), the 74HC138 decoder.
- The decoder selects: UART 6850 (`$DF00-$DF01`), FDC WD1793 (`$DF10-$DF13`), I2C controller (`$DF20-$DF22`).
- On I2C: EEPROM 24C02 (`$50`, BIOS settings) and RTC DS1307 (`$68`, time).
- Not in the diagram, to add: PIA 6520 (`$DE00`, shadow ROM, optionally I2C), the ROM/RAM map in `04-memory.md`.

## Startup sequence (as of 2026-10-11)
1. Reset: the 6510 CPU reads the vector from `$FFFC`. Shadow latch = 0, reads from ROM. Port `$0000-$0001` after reset (DDR = 0).
2. ShadowInit: copy `$F800-$FFFF` ROM -> RAM (same address), latch = 1, reads from RAM.
3. Initialization: UART (`$03`, `$15`), RtcInit (starting the oscillator if CH = 1).
4. POST: CPU, RAM (excluding `$F800-$FFFF` and I/O), UART, FDC, a table of results.
5. A SETUP window of about 2 s (key `s`), optionally `SetupMenu` from the EEPROM.
6. LoadSystem: drive 0, RESTORE, sector 1 to `$0800`, errors LOST/CRC/RNF -> `DISK ERROR`.
7. Jump to `$0800`.

## Startup sequence with a RAM test (2026-10-11)
1. Reset, latch 0, vector from ROM.
2. ShadowInit: copy `$F800-$FFFF` ROM -> RAM, latch 1.
3. Low RAM test (`$0200-$DDFF`, `$E000-$F7FF`) from code in RAM.
4. RelocAndTest: copy `RELOC` to `$0200`, TestHiRam tests `$F800-$FFFF` and restores from ROM.
5. The rest of POST, a table of results.
6. The SETUP window (2 s).
7. LoadSystem, range check, a jump through `jmp (entry)`.
- Sizes (estimate): the test about 180 B, the whole BIOS about 900-1000 B. Confirm with an `ca65 -l` listing.
- Not tested: `$0100-$01FF` (stack) and `$00-$01` (6510 port).

## To confirm
- [ ] Should the bus support DMA (a simulated separate component) at a later stage?
- [ ] Should devices share a common `Read(ushort)` / `Write(ushort, byte)` interface?
