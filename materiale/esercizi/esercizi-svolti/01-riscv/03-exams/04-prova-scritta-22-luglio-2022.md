
#### QUESITO

Implementare in assembly RISCV la funzione C `strcat`:  
 
```c
char *strcat(char *dest, const char *src); 
```

La funzione `strcat()` concatena la stringa `src` aggiungendola al termine della stringa `dest`. La concatenazione avviene copiando la stringa `src` a partire dal terminatore della stringa `desc`. La copia di `src` e' comprensiva del suo terminatore. L'area di memoria puntata da `dest` deve essere sufficientemente ampia da accogliere entrambe le stringhe ed il terminatore **'\0'**, quindi `dest` deve essere dimensionata almeno per contenere `strlen(dest) + 
strlen(src) + 1` caratteri.

Gestire correttamente lo stack come da calling convention, così come il passaggio dei parametri di ingresso e di uscita sui registri appropriati. Scrivere la funzione `main` che invoca `strcat`, mostrando anche l’allocazione degli array sul segmento dati statico del file ELF.

#### RISOLUZIONE

**Codice C**:

```c
int main();

char *strcat(char *dest, const char* src) {

    // Calc dest length
    int j = 0;
    while(dest[j] != '\0')
        j++;
    
    // Concatenate src to dest
    for(int i = 0; src[i] != '\0'; i++, j++)
        dest[j] = src[i];
    
    // Add terminator to src
    dest[j] = '\0';
    return dest;
}
```

**Codice Risc-V**:

```asm
.global main
.data
    x: .asciz "strsrc"  // source
    y: .space 32        // destination
.text
main:
    addi x2, x2, -16    // Allocate stack
    sd x1, 0(x2)        // Save ra
    sd x8, 8(x2)        // Save fp

    la x10, y           // Set 1° arg (dest)
    la x11, x           // Set 2° arg (src)
    jal x1, strcat      // Call strcat

    ld x1, 0(x2)        // Restore ra
    ld x8m 8(x2)        // Restore fp
    addi x2, x2, 16     // Deallocate stack

    la x10, y           // Set exit value
    li x17, 93          // Set exit syscall code
    ecall               // Call exit syscall

// x10 = dest
// x11 = src

strcat:
    add x30, x0, x0     // j = 0
LEN:
    add x5, x30, x10    // x5 = dest + (j * 1)
    lb x5, 0(x5)        // x5 = dest[j]
    beq x5, x0, LENEND  // Goto LENEND if (dest[j] == '\0')
    addi x30, x30, 1    // j++
    jal x0, LEN         // Goto LEN
LENEND:
    add x29, x0, x0     // i = 0
LOOP:
    add x5, x29, x11    // x5 = src + (i * 1)
    lb x5, 0(x5)        // x5 = src[i]
    beq x5, x0, END     // Goto END if (src[i] == '\0')

    add x6, x30, x10    // x6 = dest + (j * 1)
    sb x5, 0(x6)        // dest[j] = src[i]

    addi x29, x29, 1    // i++
    addi x30, x30, 1    // j++
    jal x0, LOOP        // Goto LOOP
END:
    add x6, x30, x10    // x6 = dest + (j * 1)
    sb x0, 0(x6)        // dest[j] = '\0'

    add x10, x0, x10    // x10 = dest
    jalr x0, 0(x1)      // Return to caller
```

**Ricorda**:

- Molto spesso uso `addi` (add immediate) anche quando devo **sommare due registri**. **NON VA BENE**! Devo ricordarmi di usare `add`.
