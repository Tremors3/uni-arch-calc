
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

// x10 = A
// x11 = i
// x12 = j

scambia:
    // Allocate Stack
    addi x2, x2, -16    // Allocate stack
    sd x19, 0(x2)       // Save s3
    sd x20, 8(x2)       // Save s4

    // Calculating Offsets
    slli x5, x11, 2     // x5 = offset_i
    add x5, x5, x10     // x5 = Array + offset_i
    slli x6, x12, 2     // x6 = offset_j
    add x6, x6, x10     // x6 = Array + offset_j

    // Swapping Values
    lw x19, 0(x5)       // x19 = A[i]
    lw x20, 0(x6)       // x20 = A[j]
    sw x20, 0(x5)       // A[i] = x20
    sw x19, 0(x6)       // A[j] = x19

    // Deallocating Stack
    ld x19, 0(x2)       // Restore s3
    ld x20, 8(x2)       // Restore s4
    addi x2, x2, 16     // Deallocate stack
    
    jalr x0, 0(x1)      // Jump to caller
```
