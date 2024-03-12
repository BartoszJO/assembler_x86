f_2:
    ; Parametry: double a (st0), int b
    fild dword [esp + 8]  ; Wczytuje b na stos
    fyl2x                ; y * log2(x)
    fld1                 ; Wczytuje 1 na stos
    fld st1              ; Duplikuje st0
    fyl2x                ; y * log2(x) dla 1
    fsub                ; Odejmuje: log2(a) - log2(b) = logb(a)
    ret
