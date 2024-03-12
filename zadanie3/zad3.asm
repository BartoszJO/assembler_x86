section .data
    input db '0.0', 0     ; Bufor na wejściową liczbę zmiennoprzecinkową
    input_len equ $-input  ; Długość bufora wejściowego
    format db '%f', 10, 0  ; Format do printf

section .bss
    number resb 10        ; Bufor na liczbę zmiennoprzecinkową (max 10 bajtów)

section .text
global main
extern atof, printf      ; Deklaracje funkcji zewnętrznych

main:
    ; Wczytanie liczby z wejścia
    mov eax, 3            ; Syscall do czytania (sys_read)
    mov ebx, 0            ; Wejście standardowe (stdin)
    mov ecx, input        ; Bufor na dane wejściowe
    mov edx, input_len    ; Maksymalna liczba bajtów do przeczytania
    int 0x80

    ; Konwersja ciągu znaków na liczbę zmiennoprzecinkową
    push input            ; Przekazanie adresu ciągu znaków na stos
    call atof             ; Wywołanie atof
    add esp, 4            ; Oczyszczenie stosu
    fstp dword [number]   ; Zapisz wartość zmiennoprzecinkową do zmiennej number

    ; Obliczenia sin(x), cos(x), sqrt(x), exp(x) używając koprocesora x87
    fld dword [number]    ; Załaduj liczbę do rejestru koprocesora
    fsin                  ; Oblicz sin(x)
    fstp dword [number]   ; Zapisz wynik z powrotem do pamięci
    ; Powtórz dla cos, sqrt i exp

    ; Wypisanie wyników
    push dword [number]   ; Przekazanie liczby zmiennoprzecinkowej
    push format           ; Przekazanie formatu
    call printf           ; Wywołanie printf
    add esp, 8            ; Oczyszczenie stosu

    ; Zakończenie programu
    mov eax, 1            ; Syscall do zakończenia (sys_exit)
    xor ebx, ebx          ; Kod zakończenia
    int 0x80
