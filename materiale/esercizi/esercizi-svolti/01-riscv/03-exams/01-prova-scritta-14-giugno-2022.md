
#### QUESITO

Scrivere una funzione assembly RISCV `mystrcpy` che prenda in ingresso una stringa destinazione `dest`, una stringa sorgente `src`, un numero di bytes `b` e una direzione `d`. La funzione deve copiare i primi `b` caratteri della stringa src sulla stringa `dst`, terminandola col terminatore **'\0'**. Se il numero di bytes `b` indicato dovesse essere più grande del numero di caratteri effettivamente presenti nella stringa src quest'ultima verrà interamente copiata nella stringa `dst`. Se la direzione `d` è pari a **0** la copia deve essere diretta, se è pari a **1** deve essere invertita.

Es.
```
  char x[10] = "distintivo”;
  char y[10]; 
  mystrcpy(y, x, 4, 0) produce y = "distF = {'d', 'i', 's', 't', '\0'}
  mystrcpy(y, x, 4, 1) produce y = "tsid” = {'t', 's', 'i', 'd', '\0'}
```

Gestire correttamente lo stack come da calling convention, così come il passaggio dei parametri di ingresso e di uscita sui registri appropriati. Scrivere la funzione `main` che invoca `mystrcpy`, mostrando anche l'allocazione degli array sul segmento dati statico del file ELF.

#### RISOLUZIONE

**Codice C**:

```c
void mystrcpy(char* dst, const char* src, int b, bool d) {

    int i = 0;

    if (d == 0) {
    
        // direct copy
        for(; i < b && src[i] != '\0'; i++)
            dst[i] = src[i];
    
    } else {

        // Determino lunghezza stringa
        while(src[i] != '\0') { i++; }

        if (i > b) {
            i = b;
        }

        // reverse copy
        for(int j = 0; j < i; j++)
            dst[j] = src[i - j - 1];
    
    }

    dst[i] = '\0';
}
```

**Codice Risc-V**:

```asm
.global main

.data
    x: .asciz = "distintivo"
    y: .space 11

.text
main:
    addi x2, x2, -16    // Allocate stack
    sd x1, 0(x2)        // Save ra
    sd x8, 8(x2)        // Save fp

    la x10, y           // Set 1° arg
    la x11, x           // Set 2° arg
    addi x12, x0, 4     // Set 3° arg
    addi x13, x0, 0     // Set 4° arg

    jal x1, mystrcpy    // Call mystrcpy

    ld x1, 0(x2)        // Restore ra
    ld x8, 8(x2)        // Restore fp
    addi x2, x2, 16     // Deallocate stack

    li x10, 0           // Set exit value
    li x17, 93          // Set exit syscall code (93)
    ecall               // Call exit syscall

// x10 = dst
// x11 = src
// x12 = b
// x13 = d

mystrcpy:
    add x29, x0, x0     // i = 0
    bne x13, x0, LEN    // Goto REV if (d != 0)
DIR:
    bge x29, x12, END   // Goto END if (i >= b)
    add x5, x29, x11    // x5 = src + (i * 1)
    lb x5, 0(x5)        // x5 = src[i]
    beq x5, x0, END     // Goto END if (src[i] == '\0')

    add x6, x29, x10    // x6 = dst + (i * 1)
    sb x5, 0(x6)        // dst[i] = src[i]

    addi x29, x29, 1    // i++
    jal x0, DIR         // Goto DIR
LEN:
    add x5, x29, x11    // x5 = src + (i * 1)
    lb x5, 0(x5)        // x5 = src[i]
    beq x5, x0, HREV    // Goto HREV if (src[i] == '\0')
    addi x29, x29, 1    // i++ (len)
    jal x0, LEN         // Goto LEN
HREV:
    add x30, x0, x0     // j = 0
    bge x12, x29, REV   // Goto REV if (b >= i)
    add x29, x0, x12    // i = b
REV:
    bge x30, x29, END   // Goto END if (j >= i)
    addi x5, x29, -1    // x5 = i - 1
    sub x5, x5, x30     // x5 = i - 1 - j
    add x5, x5, x11     // x5 = src + (i - 1 - j) * 1
    lb x5, 0(x5)        // x5 = src[i - 1 - j]
    
    add x6, x30, x10    // x6 = dst + (j * 1)
    sb x5, 0(x6)        // dst[j] = src[i - 1 - j]

    addi x30, x30, 1    // j++
    jal x0, REV         // Goto REV
END:
    add x5, x29, x10    // x5 = dst + (i * 1)
    sb x0, 0(x5)        // dst[i] = '\0'

    jalr x0, 0(x1)      // Return to caller
```

**Ricorda**:

- Molto spesso uso `addi` (add immediate) anche quando devo **sommare due registri**. **NON VA BENE**! Devo ricordarmi di usare `add`.
