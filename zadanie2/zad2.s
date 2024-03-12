.global _start

.section .text
_start:
    ldr r1, =2          // Ustaw r1 na 2, pierwszą liczbę do sprawdzenia
    ldr r3, =100000     // Załaduj wartość 100000 do rejestru r3

loop:
    cmp r1, r3          // Porównaj r1 z wartością w r3 (100000)
    bgt end             // Jeśli r1 > 100000, zakończ program

    mov r2, #2          // Ustaw r2 na 2, pierwszy dzielnik do sprawdzenia
    bl is_prime         // Sprawdź, czy r1 jest liczbą pierwszą
    cmp r0, #1          // Sprawdź wynik funkcji is_prime
    bne not_prime       // Jeśli r0 nie jest 1, liczba nie jest pierwsza

    push {r1}           // Zachowaj r1 na stosie
    bl print_prime      // Wydrukuj liczbę pierwszą
    pop {r1}            // Przywróć r1 ze stosu

not_prime:
    add r1, r1, #1      // Inkrementuj r1
    b loop              // Powróć do pętli

end:
    mov r7, #1          // Wywołanie systemowe zakończenia programu
    svc #0

is_prime:
    push {lr}           // Zachowaj link register na stosie

    cmp r2, r1          // Porównaj r2 z r1
    bge prime           // Jeśli r2 >= r1, liczba jest pierwsza

    mov r0, r1          // Przygotuj r0 (liczba do sprawdzenia) i r1 (dzielnik)
    mov r1, r2
    bl __aeabi_uidivmod // Wywołaj funkcję dzielącą
    cmp r1, #0          // Sprawdź resztę z dzielenia
    mov r1, r2          // Przywróć oryginalną wartość r1
    bne not_prime_func  // Jeśli reszta nie jest 0, liczba nie jest pierwsza

    add r2, r2, #1      // Inkrementuj r2
    b is_prime          // Kontynuuj pętlę sprawdzania

prime:
    mov r0, #1          // Ustaw r0 na 1 (oznaczenie liczby pierwszej)
    pop {pc}            // Powróć z funkcji

not_prime_func:
    mov r0, #0          // Ustaw r0 na 0 (oznaczenie braku liczby pierwszej)
    pop {pc}            // Powróć z funkcji

print_prime:
    // Kod do drukowania liczby pierwszej na standardowe wyjście
    // Implementacja zależy od systemu i środowiska wykonawczego

    bx lr               // Powróć z funkcji
