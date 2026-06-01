
#### QUESITO

Implementare in assembly RISCV, la due funzioni C sum_vec e square.

```c
short int square(int n) {
    return n ** 2;
}

short int* vet_sum(short int A[], short int B[], short int C[], int N)
{
    for (int i = 0; i < N; i++) {
        C[i] = A[i] + B[i] + square(i);
    }
    return C;
}
```

Assumiamo che `square` sia una funzione che calcola il quadrato dell'argomento i ($i^2$). Gestire correttamente lo stack come da calling convention, così come il passaggio dei parametri di ingresso e di uscita sui registri appropriati. **NON** serve scrivere la funzione `main` che invoca `sum_vec`.

#### RISOLUZIONE

**Codice Risc-V**:

```asm
// x10 = n

square:
    mul x10, x10, x10   // x10 = n * n
    jalr x0, 0(x1)      // Return to caller

// x10 = A[]
// x11 = B[]
// x12 = C[]
// x13 = N

vet_sum:
    addi x2, x2, -48    // Allocate stack
    sd x1, 0(x2)        // Save ra
    sd x19, 8(x2)       // Save s3
    sd x20, 16(x2)      // Save s4
    sd x21, 24(x2)      // Save s5
    sd x22, 32(x2)      // Save s6
    sd x23, 40(x2)      // Save s7

    add x20, x0, x10    // x20 = A[]
    add x21, x0, x11    // x21 = B[]
    add x22, x0, x12    // x22 = C[]
    add x23, x0, x13    // x23 = N

    add x19, x0, x0     // i = 0
LOOP:
    bge x19, x23, END   // Goto END if (i >= N)
    
    add x10, x0, x19    // Set 1° arg (i)
    jal x1, square      // Call square
    
    slli x28, x19, 1    // x28 = i * 2
    add x5, x28, x20    // x5 = A + (i * 2)
    add x6, x28, x21    // x6 = B + (i * 2)
    add x7, x28, x22    // x7 = C + (i * 2)

    lh x5, 0(x5)        // x5 = A[i]
    lh x6, 0(x6)        // x6 = B[i]

    add x30, x5, x6     // x30 = A[i] + B[i]
    add x30, x30, x10   // x30 = A[i] + B[i] + square(i)

    sh x30, 0(x7)       // C[i] = A[i] + B[i] + square(i)

    addi x19, x19, 1    // i++
    jal x0, LOOP        // Goto LOOP
END:
    add x10, x0, x22    // x10 = C

    ld x1, 0(x2)        // Restore ra
    ld x19, 8(x2)       // Restore s3
    ld x20, 16(x2)      // Restore s4
    ld x21, 24(x2)      // Restore s5
    ld x22, 32(x2)      // Restore s6
    ld x23, 40(x2)      // Restore s7
    addi x2, x2, 48     // Deallocate stack

    jalr x0, 0(x1)       // Return to caller
```

**Ricorda**:

- Molto spesso uso `addi` (add immediate) anche quando devo **sommare due registri**. **NON VA BENE**! Devo ricordarmi di usare `add`.

- Ricordati che **i registri temporanei non persistono dopo una chiamata a funzione**!. Le soluzioni sono 2:
    1. **Non usare registri temporanei**: allocare dei *registri saved* nello stack.
    2. **Effettuare la chiamata a funzione come prima cosa**: dopo aver effettuato la chiamata allora si procedere con i calcoli che posso fare con registri temporanei. (Quella che preferisco).
