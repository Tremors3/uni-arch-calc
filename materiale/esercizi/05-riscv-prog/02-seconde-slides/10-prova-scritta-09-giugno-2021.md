
#### QUESITO

Si scriva una funzione `sommatoria` che prende in ingresso un intero n e ritorna la sommatoria mostrata sotto. Se n è non positivo la funzione ritorna -1, se è nullo ritorna 0.

$$ 1^1 + 2^2 + 3^3 + ... + n^n $$

Per svolgere il calcolo la funzione `sommatoria` deve chiamare una funzione `elev` che prende in ingresso un intero $a$ e restituisce $a^a$.

Si scrivano le funzioni `sommatoria` e `elev` rispettando la calling convention RISC-V e 
gestendo opportunamente lo stack e il register file, utilizzando i registri appropriati.

#### RISOLUZIONE

```asm
// x10 = a

int elev(int a) {
    int sum = a;
    
    if (a == 1) 
        return sum;
    
    for (int i = 1; i <= a; i++)
        sum *= a;
    
    return sum;
}

elev:
    add x5, x0, 1           // i = 1
    add x6, x0, x10         // x6 (sum) = a 
    beq x10, x5, ELEV_END   // Goto ELEV_END if (a == 1)
ELEV_LOOP:
    blt x10, x5, ELEV_END   // Goto ELEV_END if (i > a)
    mul x6, x6, x10         // sum *= a
    addi x5, x5, 1          // i++
    jal x0, ELEV_LOOP       // Goto ELEV_LOOP
ELEV_END:
    add x10, x0, x6         // x10 = sum
    jalr x0, 0(x1)          // Goto caller

// x10 = n

int sommatoria(int n) {
    int sum = 0;
    for (int i = 1; i <= n; i++) {
        sum += elev(i);
    }
    return sum;
}

sommatoria:
    blt x10, x0, NEGATIVE   // Goto NEGATIVE if (a < 0)
    beq x10, x0, NULL       // Goto NULL     if (a == 0)
    
    addi x2, x2, -32        // Allocate 32 bytes
    sd x1, 0(x2)            // Save ra
    sd x18, 8(x2)           // Save s2 (per sum)    // PERSISTANT
    sd x19, 16(x2)          // Save s3 (per i)      // PERSISTANT
    sd x20, 24(x2)          // Save s4 (per n)      // ARGUMENT

    add x20, x0, x10        // x20 = n
    addi x18, x0, 0         // sum = 0
    addi x19, x0, 1         // i = 1
SUM_LOOP:
    blt x20, x19, SUM_END   // Goto SUM_END if (i > n)

    add x10, x0, x19        // First elev argument (i)
    jal x1, elev            // call elev
    add x18, x18, x10       // sum += elev(i)

    addi x19, x19, 1        // i++
    jal x0, SUM_LOOP        // Goto SUM_LOOP
SUM_END:
    add x10, x0, x18        // x10 = sum
    
    ld x1, 0(x2)            // Restore ra
    ld x18, 8(x2)           // Restore s2
    ld x19, 16(x2)          // Restore s3
    ld x20, 24(x2)          // Restore s4
    addi x2, x2, 32         // Deallocate 32 bytes
    
    jal x0, END             // GOTO SUM_END
NEGATIVE:
    addi x10, x0, -1        // x10 = -1
    jal x0, END             // GOTO END
NULL:
    add x10, x0, x0         // X10 = 0
END:
    jalr x0, 0(x1)          // Return to caller
```
