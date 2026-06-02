
#### QUESITO

Implementare in assembly RISCV la funzione C strncpy:  

```c
char *strncpy(char *dest, const char *src, size_t n);
```

che prende in ingresso una stringa destinazione `dest`, una stringa sorgente `src` e un numero di bytes `n`. La funzione copia al più n caratteri di `src` in `dest`, terminandola col terminatore **'\0'**.

Se `n > strlen(src)` allora `src` verrà interamente copiata in `dst`. Gestire correttamente lo stack come da calling convention, così come il passaggio dei parametri di ingresso e di uscita sui registri appropriati. Scrivere la funzione main che invoca strncpy, mostrando anche l'allocazione degli array sul segmento dati statico del file ELF. 

#### RISOLUZIONE

**Codice C**:

```c

void main();

char *strncpy(char *dest, const char*src, size_t n) {
    int i = 0;
    for(; i < n && src[i] != '\0'; i++) {
        dest[i] = src[i];
    }
    dest[i] = '\0';
    return dest;
}
```

**Codice Risc-V**:

```asm
.global main

.data
    x: .asciz "stringa"
    y: .space 8

.text
main:
    addi x2, x2, -16    // Allocate stack
    sd x1, 0(x2)        // Save ra
    sd x8, 8(x2)        // Save fp

    la x10, y           // Set 1° arg
    la x11, x           // Set 2° arg
    li x12, 4           // Set 3° arg

    jal x1, strncpy     // Call strncpy

    ld x1, 0(x2)        // Restore ra
    ld x8, 8(x2)        // Restore fp
    addi x2, x2, 16     // Deallocate stack

    li x10, 0           // Set exit value
    li x17, 93          // Set exit syscall code (93)
    ecall               // Call exit syscall

// x10 = dest
// x11 = src
// x12 = n

strncpy:
    add x29, x0, x0     // i = 0
LOOP:
    bge x29, x12, END   // Goto END if (i >= n)
    add x5, x29, x11    // x5 = src + (i * 1)
    lb x5, 0(x5)        // x5 = src[i]
    beq x5, x0, END     // Goto END if (src[i] == '\0')

    add x6, x29, x10    // x6 = dest[i]
    sb x5, 0(x6)        // dest[i] = src[i]
    
    addi x29, x29, 1    // i++
    jal x0, LOOP        // Goto LOOP
END:
    add x5, x29, x10    // x5 = dest[i]
    sb x0, 0(x5)        // dest[i] = '\0'

    jalr x0, 0(x1)      // Return to caller
```

**Ricorda**:

- Molto spesso uso `addi` (add immediate) anche quando devo **sommare due registri**. **NON VA BENE**! Devo ricordarmi di usare `add`.

- Solitamente, ai **contatori**, assegno: 

    - *x19* (s3) **||** *x29* (t4) **-->** *i*
    - *x20* (s4) **||** *x30* (t5) **-->** *j*

    A seconda che la procedura sia leaf/non-leaf. 
    Perchè mi sono abituato così.

- Il valore di ritorno della funzione `strncpy` è **'char \*'** (`dest`):
    ma in questo caso specifico `dest` si trova già in `x10` quindi non dobbiamo impostarlo manualmente come valore di ritorno.
