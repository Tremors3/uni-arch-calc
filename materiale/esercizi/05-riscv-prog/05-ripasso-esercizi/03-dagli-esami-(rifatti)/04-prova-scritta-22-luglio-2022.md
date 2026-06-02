
#### QUESITO

Implementare in assembly RISCV la funzione C `strcat`:  
 
```c
char *strcat(char *dest, const char *src);
```

La funzione `strcat()` concatena la stringa `src` aggiungendola al termine della stringa `dest`. La concatenazione avviene copiando la stringa `src` a partire dal terminatore della stringa `desc`. La copia di `src` e' comprensiva del suo terminatore. L'area di memoria puntata da `dest` deve essere sufficientemente ampia da accogliere entrambe le stringhe ed il terminatore **'\0'**, quindi `dest` deve essere dimensionata almeno per contenere `strlen(dest) + 
strlen(src) + 1` caratteri.

Gestire correttamente lo stack come da calling convention, così come il passaggio dei parametri di ingresso e di uscita sui registri appropriati. Scrivere la funzione `main` che invoca `strcat`, mostrando anche l’allocazione degli array sul segmento dati statico del file ELF.

#### RISOLUZIONE

```C

int strlen(const char* str) {
    int len = 0;
    while (str[len] != '\0')
        len++;
    return len;
}

char *strcat(char *dst, const char *src) {

    int len = strlen(src), i = 0;

    for (; src[i] != '\0'; i++)
        dst[len + i] = src[i];

    dst[len + i] = '\0';

    return dst;
}
```

```asm
# x10 = str
strlen:
    add x30, x0, x0         # len = 0
WHILE:
    add x5, x30, x10        # x5 = str + (len * 1)
    lbu x5, 0(x5)           # x5 = str[len]
    beq x5, x0, ENDWHILE    # Goto ENDWHILE if (str[len] == '\0')
    addi x30, x30, 1        # len++
    jal x0, WHILE           # Goto WHILE
ENDWHILE
    add x10, x0, x30        # x10 (ret val) = len
    jalr x0, 0(x1)          # Return to caller
# x10 = dst
# x11 = src
strcat:
    addi x2, x2, -12        # Allocate stack
    sw x1, 0(x2)            # Save ra
    sw x20, 4(x2)           # Save s4   (dst)
    sw x21, 8(x2)           # Save s5   (src)

    add x20, x0, x10        # x20 = dst
    add x21, x0, x11        # x21 = src

    add x10, x0, x20        # x10 (1° arg) = dst
    jal x1, strlen          # x10 = strlen(dst)
    add x30, x0, x10        # x30 = strlen(dst)

    add x10, x0, x20        # x10 = dst
    add x11, x0, x21        # x11 = src

    lw x1, 0(x2)            # Restore ra
    lw x20, 4(x2)           # Restore s4
    lw x21, 8(x2)           # Restore s5
    addi x2, x2, 12         # Deallocate stack

    add x29, x0, x0         # i = 0
L1:
    add x5, x29, x11        # x5 = src + (i * 1)
    lbu x5, 0(x5)           # x5 = src[i]
    beq x5, x0, ENDL1       # Goto ENDL1 if (src[i] == '\0')
    add x6, x29, x30        # x6 = len + i
    add x6, x6, x10         # x6 = dst + (len + i) * 1
    sb x5, 0(x6)            # dst[len + i] = src[i]
    addi x29, x29, 1        # i++
    jal x0, L1              # Goto L1
ENDL1:
    add x5, x29, x30        # x5 = len + i
    add x5, x5, x10         # x5 = dst + (i * 1)
    sb x0, 0(x5)            # dst[i] = '\0'

    jalr x0, 0(x1)          # Return to caller
```
