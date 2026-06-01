
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

```asm
# x10 = n
square:
    mul x10, x10, x10   # x10 (ret val) = n^2 = n * n
    jalr x0, 0(x1)
# x10 = A
# x11 = B
# x12 = C
# x13 = N
vet_sum:
    addi x2, x2, -24
    sw x1, 0(x2)        # Save ra
    sw x19, 4(x2)       # Save s3   (i)
    sw x20, 8(x2)       # Save s4   (A)
    sw x21, 12(x2)      # Save s5   (B)
    sw x22, 16(x2)      # Save s6   (C)
    sw x23, 20(x2)      # Save s7   (N)

    add x20, x0, x10    # x20 = A
    add x21, x0, x11    # x21 = B
    add x22, x0, x12    # x22 = C
    add x23, x0, x13    # x23 = N

    add x19, x0, x0     # i = 0
L1:
    bge x19, x23, ENDL1 # Goto ENDL1 if (i >= n)
    
    add x10, x0, x19    # Arg1 = i
    jal x1, square      # x10 = square(i)
    
    slli x5, x19, 1     # x5 = (i * 2)
    
    add x29, x5, x20    # x29 = A + (i * 2)
    lh x29, 0(x29)      # x29 = A[i]

    add x30, x5, x21    # x30 = B + (i * 2)
    lh x30, 0(x30)      # x30 = B[i]

    add x6, x29, x30    # x6 = A[i] + B[i]
    add x6, x6, x10     # x6 = A[i] + B[i] + square(i)

    add x30, x5, x22    # x30 = C + (i * 2)
    sh x6, 0(x30)       # C[i] = A[i] + B[i] + square(i)

    addi x19, x19 1     # i++
    jal x0, L1          # Goto L1
ENDL1:
    add x10, x0, x22    # x10 (ret val) = C

    lw x1, 0(x2)        # Save ra
    lw x19, 4(x2)       # Save s3
    lw x20, 8(x2)       # Save s4
    lw x21, 12(x2)      # save s5
    lw x22, 16(x2)      # Save s6
    lw x23, 20(x2)      # Save s7
    addi x2, x2, 24     # Deallocate stack

    jalr x0, 0(x1)      # Return to caller
```
