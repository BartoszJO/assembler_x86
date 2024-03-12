@ compile: arm-none-eabi-as main.asm -o main.o && arm-none-eabi-gcc -specs=rdimon.specs main.o
@ run:     qemu-arm-static a.out

.include "armFunctions.asm"

.data
format_str: .asciz "%d\n"       @ format dla printf

.text
.global main
.extern printf
main:
    ldr     r4, =#100000        @ ilosc pętli
    mov     r5, #0              @ loop counter = 0

main_loop:
    add     r5, r5, #1          @ iinkrementacja loop counter
    cmp     r5, r4              @ sprawdzenie,, czy loop counter osiągnął max
    beq     main_finished       @ jeśli tak, zakończ

    mov     r0, r5              @ ustaw aktualną liczbę jako argument dla isPrime
    
    bl      isPrime             @ call isPrime
    cmp     r1, #1              @ csprawdzenie, czy liczba jest pierwsza
    beq     main_printNumber    @ jeśli tak, print

    b       main_loop           @ powrót do pętli

main_printNumber:
    ldr     r0, =format_str     @ ustawienie formatu do wyświetlania
    mov     r1, r5              @ przekazanie aktualnej liczby jako argument do wyświetlenia
    bl      printf              @ call printf
    b       main_loop           @ wróc do pętli

main_finished:
    mov     r7, #1              @ syscall do exit
    mov     r0, #0              @ exit code
    swi     0                   @ syscall

@ ldr - load register - łąduje wartość do rejestru z pamięci
@ mov - przypisuje wartość do rejestru
@ add - dodawanie (np. r5, r5, #1 - dodaje 1 do wartości w rejestrze r5)
@ cmp - compare - powrównuje wartości rejestrów
@ beq (branchh if equal) - skok warunkowy, jeśli np. cmp było równe
@ bl - branch with link - wywołuje funkcje i zapisuje adres powrotu w rejestrze łącza rl
@ b - branch - instrukja do skoku do innej etykiety, nie zapisuje adresu powrotu
@ swi - software interrupt - wywołuje przerwanie programowe
