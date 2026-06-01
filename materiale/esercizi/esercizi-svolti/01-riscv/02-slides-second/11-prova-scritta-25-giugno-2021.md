
#### QUESITO

Si scriva una funzione assembly RISC-V Init che prende in ingresso un array A e la sua dimensione n e inizializza l’array come indicato sotto:

```c
void proc(int A[], int n) {
    for (i=0; i<n; i++)
        A[i] = fun(-i)
}
```

NON occorre implementare la funzione fun, solo invocarla rispettando le convenzioni sull’utilizzo dei registri per le chiamate a funzione. Gestire opportunamente lo stack nel rispetto della calling convention RISC-V.

#### RISOLUZIONE

```asm
// x10 = A
// x11 = n

proc:
    bge x0, x11, END    // Handle null/negative N input

    addi x2, x2, -16    // Allocate stack
    sw x1, 0(x2)        // Save ra
    sw x19, 4(x2)       // Save s3 (per i)      // PERSISTANT
    sw x20, 8(x2)       // Save s4 (per A)      // ARGUMENT
    sw x21, 12(x2)      // Save s5 (per n)      // ARGUMENT

    add x20, x0, x10    // x20 = A
    add x21, x0, x11    // X21 = n

    add x19, x0, x0     // i = 0
LOOP:
    bge x19, x21, LEND  // Goto LEND if (i >= n)

    sub x10, x0, x19     // x10 (Arg) = -i
    jal x1, fun         // Call fun

    slli x6, x19, 2     // x6 = i * 4
    add x6, x6, x20     // x6 = a + (i * 4)
    sw x10, 0(x6)       // A[i] = x10 (Ret)

    addi x19, x19, 1    // i++
    jal x0, LOOP        // Goto LOOP
LEND:
    lw x1, 0(x2)        // Restore ra
    lw x19, 4(x2)       // Restore s3
    lw x20, 8(x2)       // Restore s4
    lw x21, 12(x2)      // Restore s5
    addi x2, x2, 16     // Deallocate stack
END:
    jalr x0, 0(x1)      // Return to caller
```
