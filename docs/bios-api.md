# BIOS API (projekt 6502)

Status: szkic, do potwierdzenia. Ostatnia zmiana: 2026-10-11.

## Cel
Stałe wejścia do procedur BIOS, z których korzystają programy użytkownika i loader. Adresy i konwencje są stabilne, żeby programy nie zależały od wewnętrznej organizacji ROM.

## Tabela skoków
Na początku BIOS, od `$F800`. Każdy wpis to `JMP` do procedury.

| Adres | Nazwa | Status |
|-------|-------|--------|
| `$F800` | `I2C_READ` | zaplanowane |
| `$F803` | `I2C_WRITE` | zaplanowane |
| `$F806` | `PutChar` | zaplanowane |
| `$F809` | `PrintStr` | zaplanowane |
| `$F80C` | `PutCRLF` | zaplanowane |
| `$F80F` | `PrintTime` | zaplanowane |
| `$F812` | `LoadSystem` | zaplanowane |

Adresy są przykładowe. Stały układ ustali się przed wypaleniem ROM.

## Konwencje wywołania
- Argumenty przez rejestry A, X, Y. Wynik w A.
- Błąd sygnalizowany przez flagę C: C=1 oznacza błąd.
- Procedury mogą nadpisywać A, X, Y i flagi, chyba że opisano inaczej.
- Program nie zakłada, co BIOS zostawia w pamięci poza wynikiem.

## Procedury

### `I2C_READ` (`$F800`)
- Wejście: A = adres urządzenia 7-bit, X = rejestr.
- Wyjście: A = odczytana wartość, C=0. Przy błędzie C=1.
- Realizacja: kontroler I2C na `$DF20`, sekwencja START, adres, rejestr, repeated START, READ+NACK, STOP.

### `I2C_WRITE` (`$F803`)
- Wejście: A = adres urządzenia 7-bit, X = rejestr, Y = wartość.
- Wyjście: C=0 OK, C=1 błąd.

### `PutChar` (`$F806`)
- Wejście: A = znak.
- Wyjście: A zachowane. Wysyła znak przez UART 6850 (`$DF00/$DF01`), czeka na TDRE.

### `PrintStr` (`$F809`)
- Wejście: ptr2 (`$F2/$F3`) = adres tekstu zakończonego zerem.
- Wyjście: brak. Niszczy Y.

### `PutCRLF` (`$F80C`)
- Wysyła CR i LF.

### `PrintTime` (`$F80F`)
- Odczytuje czas z RTC DS1307 (`$68`) i wypisuje `HH:MM:SS`.

### `LoadSystem` (`$F812`)
- Ładuje pierwszy sektor z napędu 0 (FDC, `$DF10`) do `$0800` i skacze tam.
- Przy błędzie wypisuje `DISK ERROR` i zatrzymuje się.
- Nie wraca, jeśli sukces.

## Zarezerwowane obszary

| Zakres | Przeznaczenie |
|--------|---------------|
| `$00–$0F` | rezerwa BIOS |
| `$10–$1F` | `rtc_buf` (7 bajtów czasu) |
| `$F0–$F1` | `ptr` (wskaźnik RAM, testy) |
| `$F2–$F3` | `ptr2` (wskaźnik tekstu) |
| `$F4–$F5` | `tmp`, `tmp2` |
| `$F6` | `lines` (cień stanu linii I2C w bit-bang) |
| `$F8` | `ZP_TEST` (test typu CPU) |
| `$F9–$FB` | argumenty API I2C |

Program użytkownika może używać `$00–$EF` poza rezerwą BIOS. `$0100–$01FF` to stos.

## Rejestry sprzętowe (adresy)

| Adres | Układ | Opis |
|-------|-------|------|
| `$DE00` / `$DE01` | PIA 6520 | port A (SCL, SDA w bit-bang), CRA |
| `$DF00` / `$DF01` | UART 6850 | status/control, dane |
| `$DF10`–`$DF13` | FDC WD1793 | cmd/status, track, sector, data |
| `$DF18` | zatrzask FDC | wybór napędu, silnik |
| `$DF20`–`$DF22` | kontroler I2C | CTRL, DATA, STATUS |

## Zależności
- `bios-post.s`: POST, `Row`, `PrintStr`, `PutChar`, `PutCRLF`.
- `rtc.s`: odczyt czasu DS1307, `PrintTime`.
- Loader FDC: `LoadSystem` (w ROM).
- Plik nagłówkowy `bios.inc` (do napisania): stałe adresy wejść i zmiennych ZP.

## Do potwierdzenia
- [ ] Ostateczne adresy tabeli skoków.
- [ ] Czy `PutChar` ma zachowywać wszystkie rejestry (dla programów wygodniej).
- [ ] Format `bios.inc` i sposób zgłaszania błędów (flaga C czy kod w A).
- [ ] Czy `LoadSystem` ma być częścią API, czy tylko wewnętrzną procedurą.
