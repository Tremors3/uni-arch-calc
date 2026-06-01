
#### QUESITO

Implementare in assembly RISCV la funzione C strncpy:  

```c
char *strncpy(char *dest, const char *src, size_t n);
```

che prende in ingresso una stringa destinazione `dest`, una stringa sorgente `src` e un numero di bytes `n`. La funzione copia al più n caratteri di `src` in `dest`, terminandola col terminatore **'\0'**.

Se `n > strlen(src)` allora `src` verrà interamente copiata in `dst`. Gestire correttamente lo stack come da calling convention, così come il passaggio dei parametri di ingresso e di uscita sui registri appropriati. Scrivere la funzione main che invoca strncpy, mostrando anche l'allocazione degli array sul segmento dati statico del file ELF. 

#### RISOLUZIONE

```C
size_t strlen(const char* str, size_t n) {
    size_t len = 0;
    while ((len < n) && str[len] != '\0')
        len++;
    return len;
}

char *strncpy(char *dst, const char *src, size_t n) {

    size_t len = strlen(src, n);

    for (int i = 0; i < len; i++)
        dst[i] = src[i];

    dst[len] = '\0';
    return dst;
}
```

```asm
# x10 = str
# x11 = n
strlen:
    add x30, x0, x0         # len = 0
WHILE:
    bge x30, x11, ENDW      # Goto ENDW if (len >= n)
    add x5, x30, x10        # x5 = str + (len * 1)
    lbu x5, 0(x5)           # x5 = str[i]
    beq x5, x0, ENDW        # Goto ENDW if (str[len] == '\0')
    addi x30, x30, 1        # len++
    jal x0, WHILE           # Goto WHILE
ENDW:
    add x10, x0, x30        # x10 (ret val) = len
    jalr x0, 0(x1)          # Return to caller
# x10 = dst
# x11 = src
# x12 = n
strcpy:
    addi x2, x2, -16        # Allocate stack
    sw x1, 0(x2)            # Save ra
    sw x20, 4(x2)           # Save s4
    sw x21, 8(x2)           # Save s5
    sw x22, 12(x2)          # Save s6

    add x20, x0, x10        # x20 = dst
    add x21, x0, x11        # x11 = src
    add x22, x0, x12        # x12 = n

    add x10, x0, x21        # x10 (1° arg) = src
    add x11, x0, x22        # x11 (2° arg) = n
    jal x1, strlen          # Call strlen procedure
    add x30, x0, x10        # x30 = strlen(src, n)

    add x10, x0, x20        # x10 = dst
    add x11, x0, x21        # x11 = src
    add x12, x0, x22        # x12 = n

    lw x1, 0(x2)            # Restore ra
    lw x20, 4(x2)           # Restore s4
    lw x21, 8(x2)           # Restore s5
    lw x22, 12(x2)          # Restore s6
    addi x2, x2, 16         # Deallocate stack

    add x29, x0, x0         # i = 0
L1:
    bge x29, x30, ENDL1     # Goto ENDL1 if (i >= len)
    add x5, x29, x10        # x5 = dst + (i * 1)
    add x6, x29, x11        # x5 = src + (i * 1)
    lbu x6, 0(x6)           # x6 = src[i]
    sb x6, 0(x5)            # dst[i] = src[i]
    addi x29, x29, 1        # i++
    jal x0, L1              # Goto L1
ENDL1:
    add x7, x30, x10        # x7 = dst + (len + 1)
    sb x0, 0(x7)            # dst[len] = '\0'
    jalr x0, 0(x1)          # Return to caller
```
