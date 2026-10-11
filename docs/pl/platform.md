# Platforma: kontrakt dla BIOS i OS

Zakres: tylko to, co widzi oprogramowanie (granica CPU/magistrala/urządzenia). Poza zakresem: BOM, dekodowanie i bramkowanie w sprzęcie, wnętrze układów, szczegóły czasowe poniżej poziomu rejestrów.
Status: szkic z 2026-10-11. Pozycje „do potwierdzenia" to propozycje domyślne.

## 1. Mapa pamięci (64 KB)

| Zakres | Zawartość |
|--------|-----------|
| `$0000–$D7FF` | RAM (przy CPU 6510: `$0000–$0001` to port CPU, nie RAM) |
| `$D800–$DFFF` | I/O (patrz 2). Pierwszeństwo przed RAM |
| `$E000–$F7FF` | RAM |
| `$F800–$FFFF` | ROM po resecie, po shadow RAM (kopia ROM). Wektory `$FFFA–$FFFF` |

Zasady widoczne dla programu:
- Zapis do `$F800–$FFFF` zawsze trafia do RAM. Odczyt zależy od zatrzasku shadow.
- Odczyt adresu bez urządzenia zwraca wartość nieokreśloną (nie polegać).
- Wektory: `$FFFA` NMI, `$FFFC` RESET, `$FFFE` IRQ/BRK.

## 2. Urządzenia (interfejs rejestrów)

### Zatrzask shadow, `$DE00` (zapis)
- Bit 0: 0 = odczyt `$F800–$FFFF` z ROM (stan po resecie), 1 = z RAM.

### Konsola szeregowa, `$DF00` / `$DF01`
- `$DF00` zapis: CONTROL. `$03` = reset, `$15` = 8N1, zegar ÷16. Odczyt: STATUS.
- STATUS: bit 0 = w buforze odbiorczym jest bajt, bit 1 = można nadawać, bit 5 = przepełnienie bufora odbiorczego (utracony bajt; kasowane odczytem STATUS, a potem DATA, jak w 6850).
- Do czasu skonfigurowania po resecie bit 1 nie jest gwarantowany. Najpierw reset, potem konfiguracja, dopiero potem polling.
- `$DF01`: DATA (zapis = nadaj, odczyt = zdejmij najstarszy bajt z bufora odbiorczego).
- `$DF02`: RXCOUNT (odczyt) = liczba bajtów w buforze odbiorczym.
- Bufor odbiorczy FIFO 64 B (propozycja). Po zapełnieniu nowy bajt jest tracony i ustawia bit 5 STATUS. Nadawanie bez bufora (jeden bajt, bit 1 STATUS).
- Dobór głębokości: przy 8N1 jeden znak to 10 bitów. 9600 bodów = 960 znaków/s (ok. 10 na tyknięcie 100 Hz), 115200 bodów = 11520 znaków/s (ok. 115 na tyknięcie). 64 B starcza na ok. 66 ms przy 9600 i ok. 5,5 ms przy 115200.
- Do potwierdzenia: interfejs zgodny z 6850 czy własny prostszy (STATUS/DATA bez reset-sekwencji).

### Urządzenie blokowe (dysk), `$DF10–$DF18`
Adresowanie liniowe po numerze bloku, bez ścieżek i sektorów. Blok = 256 B. Urządzenie samo przenosi dane między nośnikiem a RAM (urządzenie jest masterem magistrali przy transferze).
- `$DF10`: CMD (zapis), STATUS (odczyt).
  - CMD: `$00` RESET, `$01` READ BLOCK, `$02` WRITE BLOCK, `$03` INFO (odświeża SIZE).
  - STATUS: bit 0 = zajęty (BUSY), bit 1 = błąd (kod w ERR), bit 2 = brak nośnika, bit 3 = zapis zabroniony.
- `$DF11` / `$DF12`: BLK lo / hi, numer bloku (16 bit, do 65536 bloków = 16 MB).
- `$DF13` / `$DF14`: ADDR lo / hi, adres bufora 256 B w RAM (poza I/O i ROM; w przeciwnym razie błąd 5).
- `$DF15` / `$DF16` (odczyt): SIZE lo / hi, liczba bloków nośnika (0 = 65536), ważne po INFO.
- `$DF17` (odczyt): ERR. 0 = OK, 1 = blok poza zakresem, 2 = błąd odczytu lub zapisu, 3 = brak nośnika, 4 = zapis zabroniony, 5 = zły adres bufora. Kasowany przy starcie nowego polecenia.
- `$DF18`: UNIT, wybór napędu 0–3 (po resecie 0).
- BUSY jest ustawiane natychmiast po zapisie CMD, więc STATUS jest od razu ważny. Czas operacji nieokreślony: czekać na BUSY = 0.
- W czasie BUSY nie zmieniać BLK, ADDR ani bufora. Po BUSY = 0 dane są w RAM (READ) lub na nośniku (WRITE).
- Przerwania: brak (polling).

### Kontroler I2C, `$DF20–$DF22`
- `$DF20` CTRL (zapis): bit 0 START, bit 1 STOP, bit 2 WRITE, bit 3 READ, bit 4 NACK po odczycie.
- `$DF21` DATA: bajt do wysłania lub ostatnio odebrany.
- `$DF22` STATUS (odczyt): bit 0 zajęty, bit 1 NACK.
- Urządzenia na szynie: EEPROM ustawień `$50`, zegar czasu rzeczywistego `$68` (czas w BCD, bit 7 sekund = zegar zatrzymany).
- Zapis do EEPROM trwa kilka ms: w tym czasie adres odpowiada NACK, trzeba ponawiać.

### Zegar systemowy (timer), `$DF30–$DF33`
- `$DF30` CTRL (zapis): bit 0 = zegar włączony, bit 1 = zgłaszanie IRQ włączone. Po resecie 0.
- `$DF31`: odczyt = STATUS (bit 0 = tyknięcie oczekuje), zapis dowolnej wartości = potwierdzenie (kasuje bit 0).
- `$DF32` DIV (zapis/odczyt): okres tyknięcia w jednostkach 1 ms. Po resecie 10 (czyli 100 Hz). Wartość 0 traktowana jak 256.
- `$DF33` COUNT (odczyt): licznik tyknięć modulo 256, rośnie niezależnie od potwierdzeń.
- Okres jest zadany w czasie rzeczywistym, nie w cyklach CPU.
- Linia IRQ jest aktywna, gdy bit 0 STATUS = 1 i bit 1 CTRL = 1. Pozostaje aktywna do potwierdzenia. Brak potwierdzenia = ponowne wejście w przerwanie.
- Tyknięcie przy nieskasowanym poprzednim nie kumuluje się (bit 0 pozostaje 1).

### Przerwania
- Wektor IRQ/BRK `$FFFE` jest wspólny. Obsługa rozróżnia BRK po fladze B w skopiowanym na stos rejestrze P.
- Po shadow wektory `$FFFA–$FFFF` leżą w RAM, więc OS może je zmienić. Po starcie BIOS ma IRQ wyłączone (flaga I=1), a OS włącza je świadomie.
- Źródła IRQ: zegar systemowy. Konsola i dysk: tylko polling (do potwierdzenia).
- NMI: żadne urządzenie go nie zgłasza (do potwierdzenia).

## 3. Kontrakt startu

1. Reset: CPU czyta wektor z `$FFFC`, ROM widoczny.
2. BIOS kopiuje `$F800–$FFFF` do RAM i ustawia zatrzask na 1.
3. POST: typ CPU, RAM (z wyłączeniem I/O, kodu BIOS po shadow), konsola, dysk, tabela wyników.
4. Okno SETUP (klawisz `s`), ustawienia w EEPROM.
5. Ładowanie systemu z dysku i skok do punktu startu.

Format dysku systemowego (napęd 0, bloki 256 B):
- Blok 0 (nagłówek): bajty 0–1 adres ładowania, bajt 2 liczba bloków danych, bajty 3–4 adres startowy.
- Bloki 1.. dane, kolejno pod adres ładowania.
- Obraz musi mieścić się w RAM poniżej `$D800` i powyżej `$0200`. Loader sprawdza: adres ładowania ≥ `$0200`, liczba bloków 1–255, koniec obrazu ≤ `$D800` (niewyrównany adres też liczony). Adres startowy nie jest walidowany.
- Błędy rozruchu: komunikat `BOOT ERROR n`, po czym zatrzymanie. `n` = 1–5 kod ERR urządzenia blokowego, 6 limit czasu operacji (65536 obiegów pętli, ok. 1 s przy 1 MHz), 7 zły nagłówek.
- Implementacja: `loader.s` (229 B z komunikatami), stałe w `bios.inc`.

Stan przy wejściu do systemu: przerwania IRQ wyłączone, shadow aktywny, pamięć `$F800–$FFFF` zawiera BIOS, zero page `$F0–$FF` zarezerwowane dla BIOS.

## 4. Tabela skoków BIOS (od `$F800`, po 3 bajty `JMP`)

| Adres | Funkcja | Wejście | Wyjście |
|-------|---------|---------|---------|
| `$F800` | `I2C_READ` | A = adres 7-bit, X = rejestr | A = wartość, C=1 błąd |
| `$F803` | `I2C_WRITE` | A = adres, X = rejestr, Y = wartość | C=1 błąd |
| `$F806` | `PutChar` | A = znak | A zachowane |
| `$F809` | `PrintStr` | wskaźnik tekstu (zero page), tekst zakończony zerem | brak |
| `$F80C` | `PutCRLF` | brak | brak |
| `$F80F` | `PrintTime` | brak | wypis HH:MM:SS |
| `$F812` | `LoadSystem` | brak | nie wraca przy sukcesie |

Propozycje do potwierdzenia (potrzebne OS):
- `ReadBlock` (`$F815`) i `WriteBlock` (`$F818`): A = napęd, X = blok lo, Y = blok hi, adres bufora w `ptr` (`$F0/$F1`). Wyjście: C=0 OK, C=1 błąd z kodem ERR w A. BIOS czeka na BUSY = 0.
- `GetChar` (odczyt konsoli, blokujący lub nie), `GetTime`/`SetTime`.
Konwencje: argumenty w A, X, Y; błąd = flaga C; A/X/Y/flagi mogą być zmienione, chyba że opisano inaczej.

## 5. Zachowania widoczne dla programu (do uwzględnienia w BIOS)

- Dysk: po zapisie CMD STATUS jest od razu ważny (BUSY ustawione). Czekać na BUSY = 0, najlepiej z limitem czasu.
- Konsola: nadawanie dopiero po konfiguracji (patrz 2).
- Zapis do EEPROM: ponawianie po NACK z limitem.
- Test RAM nie obejmuje: I/O, `$F800–$FFFF` (testowane z kopii w niskim RAM), zero page i stosu używanych przez test.

## 6. OS (do uzgodnienia)

- Wywołania systemowe: przez tabelę skoków BIOS (`JSR`) czy `BRK` z numerem funkcji.
- System plików, format wykonywalnych programów, obsługa błędów.
- Zero page: podział między BIOS (`$F0–$FF`, wyjątek: port CPU `$00–$01` przy 6510) a OS i programy.

### Terminal: wyjście z pozycjonowaniem i minimalny tty (propozycja)
- Ekran to terminal po stronie hosta (ANSI/VT100) podłączony do konsoli szeregowej. Pozycjonowanie to sekwencje znaków, bez osobnego urządzenia wideo. Rozmiar 80×24 (do potwierdzenia). `ESC` = `$1B`.
- Minimalny zestaw sekwencji wyjściowych:
  - `ESC [ 2 J`: czyść ekran. `ESC [ H`: kursor w lewy górny róg.
  - `ESC [ w ; k H`: kursor w wiersz `w`, kolumnę `k` (numeracja od 1, liczby dziesiętne bez zer wiodących).
  - `ESC [ K`: czyść od kursora do końca linii.
  - `ESC [ n A` / `B` / `C` / `D`: kursor w górę / dół / prawo / lewo o `n`.
  - Opcjonalnie: `ESC [ ? 25 l` / `h` (ukryj/pokaż kursor), `ESC [ 7 m` / `0 m` (odwrócony/normalny).
- Znaki sterujące: CR `$0D` początek linii, LF `$0A` w dół, BS `$08` cofnięcie, BEL `$07` dzwonek.
- BIOS: `PutChar` surowy, bez tłumaczeń. Do potwierdzenia dodatkowe procedury: `ConClear`, `ConClearEol`, `ConGotoXY` (A = wiersz, X = kolumna, numeracja od 0; BIOS sam drukuje liczby dziesiętne po dodaniu 1).
- Minimalny tty w OS (dyscyplina linii):
  - Tryb liniowy (domyślny): znaki trafiają do bufora linii (np. 80 B) z echem; `BS`/`DEL` kasuje ostatni znak (wysyła `BS`, spację, `BS`); `^U` kasuje linię; `CR` kończy linię i zwraca ją do `read` (na wejściu `CR` → `LF`).
  - Wyjście: `LF` → `CR LF`.
  - Tryb surowy: znaki bez echa i edycji (edytory, gry). Przełączany przez wywołanie systemowe.
  - `^C` przerywa program (wymaga sygnałów, później).
- Alternatywa: tekstowa pamięć ekranu (np. 80×25 bajtów pod stałym adresem), pozycjonowanie przez zapis do pamięci. Wymaga nowego urządzenia wideo i okna w mapie pamięci. Odłożone.

### Uruchamianie poleceń, np. `ls` (propozycja)
1. `LoadSystem` ładuje jądro, które uruchamia powłokę (pierwszy proces) z deskryptorami 0, 1, 2 podłączonymi do `/dev/tty` (konsola).
2. Powłoka czyta linię z deskryptora 0 i dzieli ją na słowa.
3. Polecenie wbudowane (`cd`, `exit`) wykonuje sama. W innym wypadku szuka pliku w katalogach z listy ścieżek (np. `/bin/ls`) na urządzeniu blokowym.
4. `spawn(ścieżka, argumenty)`: jądro otwiera plik, czyta nagłówek programu (znacznik, rozmiar kodu, danych i BSS, tablica relokacji, punkt wejścia), przydziela ciągły blok RAM poniżej `$D800`, kopiuje program, stosuje relokacje, kopiuje argumenty, dziedziczy deskryptory 0, 1, 2 (przekierowania i potoki to podmiana deskryptorów przed startem), tworzy zadanie (własny stos i zero page) i je startuje.
5. `ls` jako program: `open` katalogu, w pętli `readdir`, dla każdej nazwy `write(1, ...)`, na końcu `exit(0)`.
6. Powłoka robi `wait`, po zakończeniu programu jądro zwalnia jego blok RAM, powłoka drukuje znak zachęty.
- Minimalne wywołania systemowe: `open`, `close`, `read`, `write`, `readdir`, `spawn`, `wait`, `exit`, `chdir`. Numer funkcji w A, argumenty w X/Y i w małym bloku parametrów w zero page. Wejście przez `JSR` do tabeli OS albo `BRK` (do potwierdzenia).
- Wersja pierwsza (jedno zadanie): jak w CP/M, program ładowany pod stały adres (np. `$0800`) bez relokacji, powłoka zawieszona na czas działania. Relokacja i wiele zadań później.

### Unix-like na tej platformie (propozycja)
- Realne jest Unix-like (nie pełny Unix): bez MMU brak `fork` i ochrony pamięci, zamiast `fork` użyć `spawn`.
- Ograniczenia 6502/6510: stos stały na stronie `$01` (256 B) i mała zero page, więc zadania wymagają zapisu/odtwarzania stosu i zero page przy przełączeniu oraz programów relokowalnych (LUnix i GeckOS robią to tak; GeckOS: 4 zadania ze wspólnym stosem, 16 z kopiowaniem stosu).
- Wersja minimalna: deskryptory plików (`open`/`read`/`write`/`close`), urządzenia jako pliki (`/dev/tty`), prosty system plików na urządzeniu blokowym, potoki, powłoka, `spawn`. Najpierw jedno zadanie, potem wielozadaniowość.
- Wywłaszczanie umożliwia zegar systemowy (`$DF30`, domyślnie 100 Hz). Konsola ma sprzętowy bufor FIFO 64 B, więc przy 9600 bodów wystarczy odpytywanie w przerwaniu zegara (100 Hz). Przy szybszym łączu potrzebne IRQ konsoli.
- Programy: format relokowalny z nagłówkiem (rozmiar, relokacje).

## 7. Poza zakresem kontraktu

BOM i schemat, logika dekodera i bramkowanie ROM/RAM, układy zegara i generatora baudów, zasilanie napędu, wnętrze FDC/UART, modele czasowe poniżej poziomu rejestrów.

## 8. Otwarte pytania

- [ ] Konsola: zgodna z 6850 czy własna prosta?
- [x] Dysk: interfejs blokowy (numer bloku, bufor w RAM). Wskazane przez użytkownika 2026-10-11.
- [ ] Czy transfer dysku ma wstrzymywać CPU, czy CPU pracuje w czasie BUSY (obecnie: pracuje, nie dotykać bufora)?
- [ ] Rozmiar bloku 256 B i liczba bloków (16-bitowy numer = do 16 MB) wystarczą?
- [ ] Przerwania: tylko polling, czy IRQ od konsoli i timera?
- [ ] Funkcje BIOS dla OS: `GetChar`, `ReadBlock`/`WriteBlock`, czas.
- [ ] Wywołania systemowe OS: tabela skoków czy `BRK`.
- [x] Urządzenie czasu z okresowym IRQ: dodane (`$DF30–$DF33`, domyślnie 100 Hz), wskazane przez użytkownika 2026-10-11.
- [ ] Czy konsola ma zgłaszać IRQ (odbiór znaku), czy odpytywanie w przerwaniu zegara wystarcza (zależy od prędkości łącza)?
- [ ] Głębokość bufora FIFO konsoli: 64 B (propozycja) czy inna?
- [ ] Wielozadaniowość od początku, czy najpierw jedno zadanie?
- [x] Ekran: terminal ANSI przez konsolę szeregową (tekstowa pamięć ekranu odrzucona). Wskazane przez użytkownika 2026-10-11.
- [ ] Rozmiar ekranu (80×24?) i czy BIOS dostarcza `ConClear`, `ConClearEol`, `ConGotoXY`.
