# 05 - Testy (POST i RAM)

## Jak robią to inne systemy (z pamięci, do weryfikacji)
- IBM PC: zapis i odczyt wzorców w blokach, licznik na ekranie. Część płyt ma kontrolę parzystości sprzętową.
- Commodore (KERNAL RAMTAS, BASIC): zapis i odczyt stron, wyznaczenie górnej granicy RAM. Nie pełny test.
- Amiga (Kickstart): pamięć w liście, rozszerzenia wykrywane zapisem i odczytem.
- Apple II, Atari, CP/M: brak testu, BIOS zakłada, że RAM działa.

## Techniki testu RAM
- Wzorce: `$55`/`$AA` (naprzemienne bity), `$00`/`$FF`. Wykrywa zwarcia i przytknięte bity.
- Test linii adresowych: unikalna wartość pod adres i pod adresy oddalone o potęgi dwójki. Odczyt z innego adresu oznacza zwarcie lub brak linii w dekoderze.
- Walking ones/zeros: pojedynczy bit przechodzi przez zakres. Wykrywa przytkniętą linię danych.
- Lustrzane odbicie: zapis pod adres, odczyt pod adres o rozmiar RAM dalej. Pozwala ustalić rzeczywisty rozmiar.

## Dla naszego projektu (2× 62256, dekoder A15)
- Test wzorców w pełnym zakresie (z wyłączeniem I/O i BIOS).
- Test linii A0–A15, szczególnie A15 (wybór między dwoma układami).
- Wykrywanie lustrzanego odbicia, żeby wykryć RAM źle podłączony do dekodera.
- Nietestowane w obecnym kodzie: stos `$0100–$01FF`, port `$00–$01`.

## Do potwierdzenia
- [ ] Czy test linii adresowych w POST (koszt czasu vs wartość).
- [ ] Czy wyświetlać rozmiar RAM z testu w tabeli.
