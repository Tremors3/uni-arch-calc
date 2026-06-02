
#### QUESITO

Scrivere una funzione assembly scambia che prende in ingresso un array di interi (32bit) A e due interi i, j e che scambi di posizione gli elementi i e j nell’array.

L’equivalente C è:

```c
void scambia (int A[], int i, int j)
{
  int temp = A[i];
  A[i] = A[j];
  A[j] = temp;
}
```

Si consideri, come da convenzione, che i parametri di ingresso vengano passati sui registri x10, x11, x12 (a0, a1, a2) e il puntatore all’indirizzo dell’istruzione chiamante sul registro x1 (ra). Si utilizzino saved registers (s0, s1,...) per ospitare i risultati intermedi del calcolo, gestendoli opportunamente come da calling convention RISC-V.

#### RISOLUZIONE

```asm
scambia:
    # Saving registers
    addi x2, x2, -32    # Allocate stack
    sw x1, 0(x2)        # Save ra
    sw x18, 4(x2)       # Save s2   (i)
    sw x19, 8(x2)       # Save s3   (j)
    sw x20, 12(x2)      # Save s4   (A[])
    sw x21, 16(x2)      # Save s5   (temp1)
    sw x22, 20(x2)      # Save s6   (temp2)
    sw x23, 24(x2)      # Save s7   (temp3)
    sw x24, 28(x2)      # Save s8   (temp4)

    # Storing parameters
    add x18, x0, x11    # s2 = i
    add x19, x0, x12    # s3 = j
    add x20, x0, x10    # s4 = A[]

    # Calculating offsets
    slli x21, x18, 2    # s5 = (i * 4)
    add x21, x21, x20   # s5 = A + (i * 4)
    slli x22, x19, 2    # s6 = (j * 4)
    add x22, x22, x20   # s6 = A + (j * 4)

    # Swapping elements
    lw x23, 0(x21)      # s7 = A[i]
    lw x24, 0(x22)      # s8 = A[j]
    sw x23, 0(x22)      # A[j] = s7
    sw x24, 0(x21)      # A[i] = s8

    # Restoring registers
    lw x1, 0(x2)        # Restore ra
    lw x18, 4(x2)       # Restore s2
    lw x19, 8(x2)       # Restore s3
    lw x20, 12(x2)      # Restore s4
    lw x21, 16(x2)      # Restore s5
    lw x22, 20(x2)      # Restore s6
    lw x23, 24(x2)      # Restore s7
    lw x24, 28(x2)      # Restore s8
    addi x2, x2, 32     # Deallocate stack

    # Returning
    jalr x0, 0(x1)      # Return to caller
```
