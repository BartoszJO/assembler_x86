f_4:
    ; Parametry: float a (st0), int b
    fild dword [esp + 8]  ; Wczytuje b na stos
    fild dword [esp + 4]  ; Wczytuje a na stos
    fyl2x                ; y * log2(x)
    fidiv dword [esp + 8] ; Dzieli przez b
    f2xm1                ; 2^x - 1
    fld1                 ; Wczytuje 1 na stos
    fadd                ; Dodaje 1, otrzymując 2^x
    ret
