# Przegląd mini6510 — 2026-10-12

Stan analizowany: `d77223933f40a64254485cd63c3f6e3b8c47cb91`.
Metoda: odczyt kodu i dokumentacji przez konektor GitHub oraz analiza logów istniejącego CI.
Nie uruchamiano projektu lokalnie. Poniższe uwagi są zadaniami do wykonania; zmiana dokumentacji ich nie naprawia.

## Ocena architektury

Mocne strony: rozdzielenie BIOS-u, platform i jądra, wspólne ABI, wykonywanie rzeczywistego kodu
asemblerowego w testach, potoki, multitasking oraz backendy REU/ROM i napędów.
Projekt jest funkcjonalnym prototypem; testy modelowe nie zastępują weryfikacji VICE i sprzętu.

## Uwagi i priorytety

| Priorytet | Miejsce | Ustalenie | Zalecane działanie |
|---|---|---|---|
| P1 | `scripts/test.py`, `.github/workflows/ci.yml` | Wyrażenie `WYNIK: OK\|SKIP` zalicza pominięcie jako sukces i drukuje PASS. Log ostatniego CI pokazuje 11 zestawów modelowych i pięć zestawów VICE po 0,0 s. | Raportować PASS/SKIP/FAIL osobno. Dodać tryb wymagający wykonania testów emulatora oraz job z potrzebnymi narzędziami i legalnie dostarczonymi ROM-ami. |
| P1 | `tests/test_space.py` | Sprawdzenie „n3 trafił w dziurę po F2” otrzymuje stałe `True`. Po defragmentacji nie można już odtworzyć miejsca wcześniejszej alokacji. | Sprawdzić obraz po alokacji, przed defrag, i porównać blok N3 z blokiem usuniętego F2. Zachować niezależne testy zawartości i ciągłości po defrag. |
| P2 | `sim/harness.py` | `Machine.step()` obsługuje zgłoszenie IRQ timera, a `Machine.run()` wywołuje bezpośrednio `m.step()`, omijając tę obsługę. | Ujednolicić ścieżkę wykonywania i dodać test IRQ uruchamiany przez `run()`. Zweryfikować wpływ na obecne testy POST. |
| P2 | `os/kernel.s` | 3559 linii łączy syscall ABI, konsolę, SFS, scheduler, potoki, loader, shell i RTC. | Wydzielać moduły etapami, zachowując tablicę ABI i mapę pamięci. Po każdym etapie porównać mapę linkera i uruchomić istniejące testy. |
| P3 | `README.md`, `README.pl.md` | Nieaktualne ścieżki build i zależności; angielski README deklarował brak IEC/1541 i wyłącznie modelową weryfikację mimo opisanych testów VICE. | Poprawiono w tym commicie. Status CI nadal opisuje ograniczenia obecnego runnera. |

## Proponowany podział jądra

1. Stała tablica syscall ABI i wspólne definicje pamięci.
2. Konsola i operacje strumieniowe.
3. Scheduler, kontekst zadań i potoki.
4. SFS: katalogi, alokacja, odczyt/zapis i defragmentacja.
5. Loader COM i relokacje.
6. Parser powłoki oraz polecenia.
7. Czas i konwersja danych RTC.

To propozycja refaktoryzacji, nie wykryty błąd działania. Przy podziale należy jawnie określić
współdzielone bufory, zmienne zero page i konwencje zachowania rejestrów.

## Dowody

- [Analizowany commit](https://github.com/prachwal/mini6510/commit/d77223933f40a64254485cd63c3f6e3b8c47cb91).
- [Przebieg CI](https://github.com/prachwal/mini6510/actions/runs/38208830350).
- [Runner testów](../../scripts/test.py).
- [Test alokacji](../../tests/test_space.py).
- [Model maszyny](../../sim/harness.py).
- [Jądro](../../os/kernel.s).
