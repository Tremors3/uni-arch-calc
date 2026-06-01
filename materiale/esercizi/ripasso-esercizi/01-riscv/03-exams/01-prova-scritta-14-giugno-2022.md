
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

```C
char* mystrcpy(char* dst, const char* src, int b, bool d) {
    int len = 0;
    
    while ((len < b) && (src[len] != '\0'))
        len++;

    if (d == 0) { // Direct copy
        for (int i = 0; i < len; i++) {
            dst[i] = src[i];
        }
    } else { // Inverse copy
        for (int i = 0; i < len; i++) {
            dst[len - i - 1] = src[i];
        }
    }

    dst[len] = '\0';
    return dst;
}
```

```asm
# x10 = dst
# x11 = src
# x12 = b
# x13 = d
mystrcpy:
    addi x2, x2, -8     # Allocate stack
    sw x1, 0(x2)        # Save ra
    sw x8, 4(x2)        # Save s0   (len)

    add x8, x0, x0      # len = 0
WHILE:
    bge x8, x12, ENDW   # Goto ENDW if (len >= b)
    add x5, x8, x11     # x5 = src + (len * 1)
    lbu x5, 0(x5)       # x5 = src[len]
    beq x5, x0, ENDW    # Goto ENDW if (src[len] == '\0')
    addi x8, x8, 1      # len++
    jal x0, WHILE       # Goto WHILE
ENDW:
    bne x13, x0, INVERSE # Goto INVERSE if (d != 0)
DIRECT:
    add x29, x0, x0     # i = 0
L1:
    bge x29, x8, ENDL1  # Goto ENDL1 if (i >= len)
    add x6, x29, x10    # x6 = dst + (i * 1)
    add x5, x29, x11    # x5 = src + (i * 1)
    lbu x5, 0(x5)       # x5 = src[i]
    sb x5, 0(x6)        # dst[i] = src[i]
    addi x29, x29, 1    # i++
    jal x0, L1          # Goto L1
ENDL1:
    jal x0, ENDL2       # Goto ENDL2
INVERSE:
    add x29, x0, x0     # i = 0
L2:
    bge x29, x8, ENDL2  # Goto ENDL2 if (i >= len)
    sub x6, x8, x29     # x6 = len - i
    addi x6, x6, -1     # x6 = len - i - 1
    add x6, x6, x10     # x6 = dst + (len - i - 1) * 1
    add x5, x29, x11    # x5 = src + (i * 1)
    lbu x5, 0(x5)       # x5 = src[i]
    sb x5, 0(x6)        # dst[len - i - 1] = src[i]
    addi x29, x29, 1    # i++
    jal x0, L2          # Goto L2
ENDL2:
    add x5, x8, x10     # x5 = dst + (len * 1)
    sb x0, 0(x5)        # dst[len] = '\0'

    lw x1, 0(x2)        # Restore ra
    lw x8, 4(x2)        # Restore s0
    addi x2, x2, 8      # Deallocate stack

    jalr x0, 0(x1)      # Return to caller
```

- Si tratta di una leaf-function; quindi l'allocazione dello stack non è strettamente necessaria.
- Ma ho voluto comunque inserirla per fornirne un esmpio.