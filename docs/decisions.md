# Decyzje

Format: data, decyzja, status (potwierdzona / do potwierdzenia).

## 2026-10-11
- Wektory przerwań (NMI, RESET, IRQ/BRK) znajdują się w ROM pod $FFFA-$FFFF. CPU tylko je odczytuje. Status: do potwierdzenia (domyślnie tak).
- Urządzenia I/O: memory-mapped. Brak DMA w rdzeniu CPU, ewentualnie osobny komponent później. Status: do potwierdzenia.
- Mapowanie domyślne: RAM $0000-$7FFF, ROM $8000-$FFFF. Status: do potwierdzenia.
- Zapis do ROM ignorowany. Status: do potwierdzenia.
- CP/M wymaga CPU 8080/Z80 (nie 6502). Propozycja: Z80. Status: do potwierdzenia.
- RS-232 wymaga UART (6850, 8251, 6551 lub Z80 SIO). PIA 6520 nie jest szeregowy. Status: do potwierdzenia.
- RAM 128 KB wymaga bank switching (CPU widzi 64 KB). Status: do potwierdzenia.
- EEPROM z ustawieniami BIOS (np. 24C02 przez PIA, suma kontrolna). Status: do potwierdzenia.
- RAM 64 KB (2× 62256), shadow ROM przez zatrzask 74HC273 pod `$DE00` (bit0: 0 = ROM ON). Zapis zawsze do RAM. Status: wybrane przez użytkownika (2026-10-11).
- Zatrzask zamiast PIA 6520 dla shadow (stan po resecie). Status: propozycja.
- CPU 6510 zamiast 6502. Port pod `$0000–$0001` (nie RAM), zmienne BIOS poza tym obszarem, zatrzask shadow zewnętrzny. Status: do potwierdzenia.
- Procesor jest poza zakresem tych notatek (ma go osobno). Status: wskazane przez użytkownika (2026-10-11).
- Cel: BIOS i OS dla wiernego emulatora. Notatki opisują tylko granicę komunikacji (kontrakt widoczny dla oprogramowania), bez szczegółów implementacji urządzeń i sprzętu. Kontrakt w `platforma.md`. Status: wskazane przez użytkownika (2026-10-11), zastępuje wcześniejsze propozycje o zakresie.
- Zegar systemowy z okresowym IRQ pod `$DF30–$DF33` (domyślnie 100 Hz, okres w ms, potwierdzenie zapisem). Dla wywłaszczania w OS Unix-like. Status: wskazane przez użytkownika (2026-10-11), szczegóły rejestrów do potwierdzenia.
- Konsola z sprzętowym buforem odbiorczym FIFO 64 B, rejestr `$DF02` (RXCOUNT), bit przepełnienia w STATUS. Powód: pojedynczy rejestr odbiorczy gubi znaki przy odpytywaniu 100 Hz. Status: wskazane przez użytkownika (2026-10-11), głębokość do potwierdzenia.
- Ekran i klawiatura: terminal ANSI/VT100 przez konsolę szeregową, bez osobnego urządzenia wideo. Rozmiar 80×24 jako domyślny, do potwierdzenia. Status: wskazane przez użytkownika (2026-10-11).
- Dysk: interfejs blokowy (numer bloku 16 bit, blok 256 B, transfer do bufora w RAM, `$DF10–$DF18`), zamiast interfejsu wzorowanego na WD179x. Status: wskazane przez użytkownika (2026-10-11), szczegóły rejestrów do potwierdzenia.
- Alternatywa dla CP/M: własny OS (bootloader, sterowniki, wywołania systemowe, prosty FS, loader, shell). Propozycja: własny OS na 6502. Status: do potwierdzenia.

## 2026-10-11 — Port C64
Platformy rozdzielone na `bios/` + `platforms/<nazwa>/`; jądro zależy tylko od `bios.inc` i `platform.inc`. Dysk C64 = REU. Zatwierdzone przez użytkownika: refaktoryzacja pod C64 i test w emulatorze.

## 2026-10-11 — Cartridge Magic Desk (branch feature/c64-cartridge)
Rozruch całego systemu z cartridge: bank 0 = boot + BIOS, banki 1-15 = dysk ROM 480 bloków. Z REU kopiujemy dysk do REU (zapisywalny), bez REU tylko odczyt. Do potwierdzenia: merge do main.

## 2026-10-11 — Port Commodore Plus/4 (branch feature/plus4)
Plus/4 startuje z cartridge CART-1 (32 KB). Dysk w ROM (108 bloków) + zapisywalna nakładka w RAM (24 bloki). Czas programowy (brak RTC). Do potwierdzenia: merge do main.

## 2026-10-11 — Napędy dysków (branch feature/iec-drive)
Sterownik napędu 8 jako urządzenie blokowe: IEC/1541 (C64) i TCBM/1551 (Plus/4, natywny napęd tej maszyny), wspólna warstwa U1/U2. Napęd z dyskiem MiniUnix ma pierwszeństwo przed REU/ROM. BIOS Plus/4 urósł do 5 KB (dysk ROM 104 bloki, BIOS od $E700, nakładka 23 bloki). Opis: `docs/drives.md`. Do potwierdzenia: merge; następny krok: tryb niskiej pamięci (C16/C116, wykonywanie z ROM).
