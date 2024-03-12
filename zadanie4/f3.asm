f_3:
    ; Parametry: double a (st0), int b
    fild dword [esp + 8]  ; Wczytuje b na stos
    fldl2e               ; Wczytuje log2(e) na stos
    fmulp st1, st0       ; mnoży st1 przez st0 i umieszcza wynik w st1
    f2xm1                ; 2^x - 1
    fld1                 ; Wczytuje 1 na stos
    fadd                ; Dodaje 1, otrzymując 2^x
    ret
