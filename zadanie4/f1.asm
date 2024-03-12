f_1:
    ; Parametry: double a (st0), float b, double c, int d
    fld dword [esp + 12] ; Wczytuje b na stos
    fdiv                ; a / b
    fild dword [esp + 20] ; Wczytuje d na stos
    fild qword [esp + 16] ; Wczytuje c na stos
    fimul               ; c * d
    fsub                ; (a / b) - (c * d)
    ret

; fld dword [esp + 12] - ładuje wartość b typu float  na stos
; wartość ta znajduje się w pamięci 12 bajtów od szczytu stosu

; fdiv - dzielenie liczby na szczycie stosu (st0=a) przez bajtów
; ładuje wartość d typu int na stos, wartość znajduje się 20 bajtów od stosu,
; ładuje wartośc c typu double na stos, wartośc znajduje się w pamięci
; 16 bajtów od szczytu stosu
; fimul - mnoży dwie liczby na szczycie stosu (czyli c i d)
; a wynik umieszcza na szczycie stosu
; fsub - instrukcja odejmjuje wartosc na szczycie stosu fpu (c *d) od wartości
; znajdującej się pod nią (a/b) i wynik na góre stosu
; ret - kończy funkcję ii zwraca sterowanie do funkcji wywołującej.
; Wynik działań znajduje się na szczycie stosu