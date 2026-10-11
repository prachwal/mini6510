; platform.inc - parametry platformy widoczne dla jądra i programów (generic: RAM 64 KB, I/O $D800-$DFFF)
KBASE        = $0400    ; adres ładowania jądra (tablica wywołań systemowych)
DB           = $2000    ; początek obszaru danych jądra (bufory, zadania, potoki)
SLOT_END_HI  = $D8      ; strona końca pamięci programów (wył.)
