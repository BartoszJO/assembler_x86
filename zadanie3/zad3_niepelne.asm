section .data
    input_format db "%lf", 0    ; format wczytywania liczby
    output_format db "sin(%f) = %f, cos(%f) = %f, sqrt(%f) = %f, exp(%f) = %f", 10, 0
    number dq 0.0               ; zmienna na wczytaną liczbę

    ; db - define byte
    ; dq - define quadword (64 bity w pamięci - double)
    ; 0 - znak końca ciągu
    ; 10 - znak nowej linii w ASCII

section .bss
    sin_res resq 1             ; rezerwowanie miejsc na zmienne 
    cos_res resq 1
    sqrt_res resq 1
    exp_res resq 1

section .text
    global main
    extern scanf, printf

main:
    ; Wczytanie liczby
    push rbp                    ; wpisanie rbp do stosu
    mov rbp, rsp                ; skopiowanie wierzchołka stosu do rbp
    sub rsp, 16                 ; zmniejszamy stos o 16 bajtów, aby zarezerwować miejsce dla zmiennych
    mov rdi, input_format       ; przypisuje format do pierwszzego rejestru argumentu
    lea rsi, [number]           ; ładuje adres zmiennej number do drugiego rejestru
    mov rax, 0                  ; prawdopodobnie niepotrzebne
    call scanf
    add rsp, 16                 ; przywraca stos do pierwotnego stanu (dodaje 16 bajtów)

    ; Wczytanie liczby do rejestru FPU
    fld qword [number]          ; ładuje 64 bitową wartość zmiennej number na szczyt stosu
                                ; fld to instrukcja ładowania liczby zmiennoprzecinkowej

    ; Obliczenie sin(x)
    fsin                        ; Oblicza sinus wartości znajdującej się na szczycie stosu (czyli number)
    fstp qword [sin_res]        ; Zapisanie wyniku sin(x) i zdjęcie go ze stosu

    ; Obliczenie cos(x)
    fld qword [number]
    fcos
    fstp qword [cos_res]        ; Zapisanie wyniku cos(x)

    ; Obliczenie sqrt(x)
    fld qword [number]
    fsqrt
    fstp qword [sqrt_res]       ; Zapisanie wyniku sqrt(x)

    ; Obliczenie exp(x)
    fld qword [number]
    fldl2e                     ; Ładowanie log2(e)
    fmulp st1, st0             ; mnożenie st0 = st0 * st1 (dwóch górnych elementów stosu)
    f2xm1                      ; 2^st0 - 1
    fld1                       ; Ładowanie 1.0 na stos
    faddp st1, st0             ; Dodanie 1 do wyniku, st0 = st0 + st1
    fstp qword [exp_res]       ; Zapisanie wyniku exp(x)

    ; Wyświetlenie wyników
    mov rdi, output_format     ; format ciągu znaków wyniku 
    mov rax, 1                 ; przekazujemy jedną wartość zmiennoprzecinkową 
    movsd xmm0, [number]       ; przenosi wartość zmiennej number do rejestru xmm0 
    movsd xmm1, [sin_res]      ; przenosi wynik do kolejnego rejestru 
    movsd xmm2, [number]
    movsd xmm3, [cos_res]
    movsd xmm4, [number]
    movsd xmm5, [sqrt_res]
    movsd xmm6, [number]
    movsd xmm7, [exp_res]
    call printf                ; wywołanie printf 


    ; Zakończenie programu
    mov rsp, rbp               ; przywraca oryginalną wartość wskaźnika stosu 
    pop rbp                    ; zdejmuje wartość z wierzchołka stosu i zapisuje ją do rbp 
    ret                        ; instrukcja powrotu (return from procedure)


; rbp - Base pointer (Stos) - stały punkt odniesienia na stosie
; rsp - Stack pointer - wskazuje na wierzchołek stosu
; rdi - Destination index
; rsi - Source index
; rax - Accumulator - używany do przechowywania wyników operacji i do przekazywania liczby
; zmiennoprzecinkowych rejestrów XMM używanych w wywołaniu funkcji (scanf i printf)
; xmm0 - xmm7 - Strreaming SIMD Extenstions Registers - Rejestry SMID - używane do przekazywania
; liczby zmiennoprzecinkowej  i wyników do i z funkcji printf. Są używane do przechowywania
; argumentów zmiennoprzecinkowych podwójnej precyzji
; FPU - Floating Point Unit Stack
; st0 - st1 (rejestry fpu) - konkretne elementy stosu FPU używane w obliczeniac zmiennoprzecinkowych,
; jak fmulp, faddp