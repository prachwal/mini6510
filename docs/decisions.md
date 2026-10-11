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

## 2026-10-11 — Tryb niskiej pamięci / XIP (branch feature/c16-xip)
Cel: cartridge bez kopiowania czegokolwiek do RAM (C16/C116, 16 KB). Kod wykonywany z ROM, RAM tylko na zmienne. Na razie tylko projekt: `docs/xip.md` (do potwierdzenia: minimalny RAM 16 KB, własny zestaw znaków w ROM cartridge).

## 2026-10-11 — Kandydaci na kolejne platformy (na później, do potwierdzenia)
- **PET / CBM 8032 (80 kolumn):** nowa platforma `platforms/pet`. Do napisania: ekran 80×25 pod `$8000`, klawiatura (VIA/PIA), zegar 60 Hz, transport IEEE-488 (PIA 6520 + VIA) pod istniejącą warstwę blokową `bios/drive.s` (polecenia U1/U2). Uwaga na tablicę sektorów napędów 2031/4040/8050 i brak cartridge (bootloader z dysku lub ROM w gnieździe `$9000`). Test: VICE `xpet`.
- **C128:** tryb C64 powinien ruszyć praktycznie bez zmian (test w `x128`). Tryb natywny (`platforms/c128`): MMU `$FF00`, 128 KB RAM, wideo VIC-IIe 40 kol. lub VDC 8563 80 kol., napęd 1571 przez ten sam transport IEC (1328 bloków, inna tablica sektorów).
Status: do potwierdzenia (priorytet i kolejność).

## 2026-10-11 — Optymalizacja rozmiaru jądra (na później, do potwierdzenia)
Jądro `os/kernel.s` ma ok. 7,2 KB. Plan: (1) pomiar rozmiaru po funkcjach z mapy linkera, (2) wspólne podprocedury, dispatch przez tabele, więcej zmiennych na stronie zerowej, kompresja tekstów, (3) rzadkie polecenia (`uptime`, `date`, `ps`) do `/bin`, (4) flagi `.if FEATURE_X` pod wersję minimalną (tryb C16/XIP). Cel: -10-20 % bez utraty funkcji; testy regresji pilnują poprawności.

## 2026-10-11 — Ładowalne sterowniki + drukarka (na później, do potwierdzenia)
Pakiety na dysku (`/lib/drv`), ładowane w miarę potrzeby, max 1 blok (256 B), relokacja stronicowa (tylko starsze bajty adresów). Sterownik ładowany z dysku do obszaru RAM z automatyczną relokacją (tabela poprawek adresów w pliku modułu) i rejestrowany w tablicy sterowników (nazwa, tablica wejść, adres, rozmiar); jądro używa urządzeń przez tablicę (`/dev/lp`). Transport startowy zostaje w BIOS-ie/ROM-ie. Pierwszy kandydat: drukarka IEC (adres 4). Opis: `docs/drivers.md`.

## 2026-10-11 — Sterownik taśmy (na później, do potwierdzenia)
Kolejny sterownik ładowalny: magnetofon (`/dev/tap`), dostęp sekwencyjny, bloki 256 B z nagłówkiem i sumą kontrolną, własne kodowanie impulsów (bez KERNAL), podział na pakiety `tapr`/`tapw` (limit 1 blok). Test w VICE przez obraz `.tap`. Opis: `docs/drivers.md`.

## 2026-10-11 — Rdzeń na maszynę może być monolitem
Minimum na maszynę to start (boot + BIOS + rdzeń jądra), może być monolitem. Reszta (transporty dodatkowe, drukarka, taśma, zegar, filtry) jako ładowalne pakiety lub programy. Opis: `docs/drivers.md`.

## 2026-10-11 — Montowanie woluminów, cartridge jako wolumin bazowy (na później, do potwierdzenia)
ROM-dysk cartridge = wolumin bazowy `/` (tylko odczyt) z programami (`/bin`) i sterownikami (`/lib/drv`) bazowymi. RAM-dysk/REU pod `/ram`, napęd pod `/disk`, taśma pod `/tape`. Ścieżki zwykłe (bez liter napędów), polecenie `mount`/`umount`, PATH: `/ram/bin`, `/disk/bin`, `/bin` (kopia na zapisywalnym woluminie nadpisuje bazową). Opis: `docs/drivers.md`.

## 2026-10-11 — Zgodność wsteczna i uruchamianie gier (na później, do potwierdzenia)
Cel: uruchamianie istniejących gier/PRG z dysków CBM DOS. Gra przejmuje całą maszynę, wyjście = reset (gry nie mają exit), więc system nie musi przeżyć uruchomienia gry. Polecenie `run`/`load`: wczytanie PRG pod adres z nagłówka, przywrócenie stanu jak po resecie (układ pamięci z ROM-ami i KERNAL-em, wektory, rejestry VIC/TED/CIA, przerwania), start przez `SYS`/`RUN`. Rezydent w ROM cartridge (tryb XIP) nie zajmuje RAM-u gry; powrót do MiniUnix przez reset (programowy lub przycisk). Poza zasięgiem: zabezpieczenia, własne formaty dysku, cartridge-gry. Test: VICE z prawdziwymi `.prg`/`.d64`.

## 2026-10-11 — Plan wersji 0.2
Plan podzielony na wersje: 0.2 (mała i rezydentna w ROM: optymalizacja, XIP, woluminy `/` i `/ram`, snake), 0.3 (sterowniki ładowalne, dyski 8/9, drukarka, dźwięk, tetris), 0.4 (VFS + CBM DOS, `run` dla gier, taśma). Reszta w „Ideas”: nowe maszyny, pacman, testy na sprzęcie. Opis: `docs/roadmap-0.2.md`. Status: do potwierdzenia.

## 2026-10-11 — Wspólny BIOS grafiki
Wymóg użytkownika: jeden wspólny interfejs grafiki w BIOS-ie dla wszystkich maszyn (nie ładny, tylko wspólny). Wąski kontrakt: `GfxCaps`, `GfxMode`, `Clear`, `Plot`, `Fill`, `Line`; aplikacje czytają rozmiar i dostosowują układ (w komórkach 8×8). Efekty i sprite'y poza kontraktem. Wersja 0.3. Opis: `docs/graphics.md`. Status: do potwierdzenia.

## 2026-10-11 — Budżet pamięci
Pamięć jest głównym ograniczeniem: każdy element (jądro, BIOS, sterownik, grafika) ma limit ROM/RAM w tabeli w `docs/roadmap-0.2.md`, a `scripts/build.py` ma przerywać build po jego przekroczeniu (0.2). Kod i stałe w ROM (XIP), pakiety ładowane na żądanie, bitmapa grafiki, bufor dysku i nakładka zapisu nie jednocześnie na małej maszynie. Status: do potwierdzenia.

## 2026-10-11 — Nośnik rozruchowy w monolicie
Monolit zawiera dokładnie jeden transport nośnika rozruchowego, zależnie od sposobu startu: cartridge (czytnik ROM-dysku), napęd IEC/1541, TCBM/1551 albo REU. Inne transporty to pakiety ładowane z woluminu rozruchowego. Osobny build na maszynę i sposób startu (`--boot cart|iec|tcbm|reu`), BIOS mniejszy, bez wszystkich transportów naraz. Dotyczy 0.2. Opis: `docs/drivers.md`.

## 2026-10-11 — musicplay (Atari, SAP)
Narzędzie `musicplay plik.sap` na Atari: wczytanie SAP (typ B najpierw), załadowanie bloków, `INIT` z numerem utworu, `PLAYER` z timera co ramkę (`TickSet hz`). `.sid` na Atari tylko przez konwersję offline. Wymaga platformy Atari (nierozpoczętej), więc w „Ideas”. Opis: `docs/musicplay.md`. Status: do potwierdzenia.

## 2026-10-11 — musicplay (C64, SID)
Narzędzie `musicplay plik.sid` na C64: PSID najpierw (RSID później przez `run`), wczytanie pod adres z nagłówka z kontrolą kolizji z jądrem/BIOS-em, `init` z numerem utworu, `play` z timera 50/60 Hz (`TickSet`), klawisze, wyciszenie SID po wyjściu. Pierwszy kandydat po 0.2 (platforma C64 istnieje). Opis: `docs/musicplay.md`. Status: do potwierdzenia.
