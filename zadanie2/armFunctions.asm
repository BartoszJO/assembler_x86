@--------------------------------------------------------------------------------------------------
@ bool isPrime(int number)
@ sprawdza, czy liczba jest pierwsza
@ r0 powinna zawierać liczbę do sprawdzenia
@ r1 będzie ustawione na 0 jeśli liczba nie jest pierwsza i na 1 jeśli będzie
isPrime:
    push    {r5, r6, r7, lr}        @ wrzucenie wartości na stos, aby je zachować

    cmp     r0, #2                  @ powrównaj liczbę z 2
    blt     notPrime                @ jeśli liczba jest mniejsza, nie jest pierwsza

    mov     r7, r0                  @ przerzuć liczbę do r7
    lsr     r5, r0, #1              @ oblicz liczba / 2 poprzez przesunięcie bitów w prawo, r5 = (r0 >> 1)
    @ lsr - local shift right - przesunięcie bitów w prawo o 1
    @ równoważne z dzieleniem przez 2

    mov     r6, #2                  @ ustawienie loop counter na 2
loop:
    cmp     r6, r5                  @ sprawdź, czy counter > n/2
    bgt     prime                   @ jeśli tak, przestań powrównywać, to jest liczba pierwsza

    mov     r0, r7                  @ ładowanie liczby
    mov     r1, r6                  @ ładowwanie countera jako dzielnik
    bl      __aeabi_uidivmod        @ wynik dzielenia w r0 a reszta w r1
    cmp     r1, #0                  @ ssprawdzenie, czy reszta jest równa zero
    beq     notPrime                @ jeśli tak, liczba nie jest pierwsza

    add     r6, r6, #1              @ inkrementacja loop counter
    b       loop                    @ powrót do etykiety loop
prime:
    mov     r1, #1                  @ ustawiamy r1 = 1, bbo liczba jest pierwsza
    b       finished                @ przejście do etykiety końcowej

notPrime:
    mov     r1, #0                  @ ustawiamy r1 = 0, bo liczba ni jest pierwsza

finished:
    pop     {r5, r6, r7, lr}        @ przywrócenie zapisanych wartości
    bx      lr                      @ rpowrót do miejsca gdzie wywołano funkcję

    @ bgt -branch if greater than - skocz do etykiety, na podstawie wyniku poprzedniej operacji