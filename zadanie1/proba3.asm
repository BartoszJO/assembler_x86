section .bss             ; deklarowanie zmiennych
    num resb 10          ; Rezerwacja 10 bajtów na liczbę wejściową
                         ; resb - reserve byte
    len equ $ - num      ; Długość bufora
                         ; symbol $ oznacza bieżący adres w kodzie, a $ - num oznacza, że
                         ; len będzie miała długość 10   

section .data
    hexChars db '0123456789ABCDEF'

section .text
    global _start

_start:
    ; Odczyt liczby ze standardowego wejścia (stdin)
    mov eax, 3           ; Numer systemowy read
    mov ebx, 0           ; Deskryptor pliku (0 = stdin)
    mov ecx, num         ; Wskaźnik na bufor
    mov edx, len         ; Długość bufora
    int 0x80             ; Wywołanie przerwania

    ; Konwersja ciągu znaków na liczbę
    mov esi, ecx         ; Wskaźnik na bufor
    xor eax, eax         ; Wyczyszczenie rejestru eax
    xor ebx, ebx         ; Wyczyszczenie rejestru ebx

convertLoop:
    mov bl, byte [esi]   ; Pobranie kolejnego znaku
    cmp bl, 10           ; Sprawdzenie czy to znak nowej linii (koniec danych)
    je printHex          ; Jeśli tak, przejdź do drukowania
    sub bl, '0'          ; Konwersja znaku na liczbę (odejmujemy 48 w ASCII)
    imul eax, eax, 10    ; eax = eax * 10
    add eax, ebx         ; Dodanie cyfry do eax
    inc esi              ; Przesunięcie wskaźnika na kolejny znak
    jmp convertLoop

printHex:
    ; Przygotowanie do wydrukowania w formacie szesnastkowym
    mov ebx, eax         ; Skopiowanie liczby do ebx
    mov ecx, 8           ; Licznik cyfr w formacie szesnastkowym
    mov edi, num + 7     ; Wskaźnik na koniec bufora

convertToHex:
    xor eax, eax         ; Wyczyszczenie rejestru eax
    mov al, bl           ; Pobranie najmłodszej cyfry z ebx
    and al, 0x0F         ; Maskowanie
    mov al, [hexChars + eax] ; Pobranie znaku szesnastkowego
    mov [edi], al        ; Umieszczenie znaku w buforze
    shr ebx, 4           ; Przesunięcie ebx w prawo o 4 bity
    dec edi              ; Przesunięcie wskaźnika bufora
    dec ecx              ; Dekrementacja licznika
    jnz convertToHex     ; Kontynuacja jeśli licznik > 0

    ; Wyświetlenie wyniku
    mov eax, 4           ; Numer systemowy write
    mov ebx, 1           ; Deskryptor pliku (1 = stdout)
    mov ecx, num         ; Wskaźnik na bufor
    mov edx, 8           ; Długość danych do wydrukowania
    int 0x80             ; Wywołanie przerwania

    ; Zakończenie programu
    mov eax, 1           ; Numer systemowy exit
    xor ebx, ebx         ; Kod powrotu
    int 0x80             ; Wywołanie przerwania
