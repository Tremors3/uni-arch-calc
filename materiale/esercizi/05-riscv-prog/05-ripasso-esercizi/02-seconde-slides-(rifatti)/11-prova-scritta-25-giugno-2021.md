
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
# x10 = A
# x11 = n
proc:
    addi x2, x2, -16    # Allocate stack
    sw x1, 0(x2)        # Save ra
    sw x19, 4(x2)       # Save s3   (i)
    sw x20, 8(x2)       # Save s4   (A)
    sw x21, 12(x2)      # Save s5   (n)

    add x20, x0, x10    # x20 = A
    add x21, x0, x11    # x21 = n

    add x19, x0, x0     # i = 0
LOOP:
    bge x19, x21, END   # Goto END if (i >= n)
    
    sub x10, x0, x19    # x10 = -i
    jal x1, fun         # x10 = fun(-i)

    slli x5, x19, 2     # x5 = (i * 4)
    add x5, x5, x20     # x5 = A + (i * 4)
    sw x10, 0(x5)       # A[i] = fun(-i)

    addi x19, x19, 1    # i++
    jal x0, LOOP        # Goto LOOP
END:
    add x10, x0, x20    # x10 (ret val) = A[]

    lw x1, 0(x2)        # Restore ra
    lw x19, 4(x2)       # Restore s3
    lw x20, 8(x2)       # Restpre s4
    lw x21, 12(x2)      # Restore s5
    addi x2, x2, 16     # Deallocate stack

    jalr x0, 0(x1)      # Return to caller
```
