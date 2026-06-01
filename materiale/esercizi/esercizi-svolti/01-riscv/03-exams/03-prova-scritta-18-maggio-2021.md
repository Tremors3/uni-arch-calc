
#### QUESITO

Si scriva una funzione `serie` che prende in ingresso due interi `n` ed `m` e ritorna la sommatoria mostrata sotto. Se `n` è non positivo la funzione ritorna **0**. 

$$ n^m + (n-1)^m + (n-2)^m + ... + 1^m $$

Per svolgere il calcolo la funzione `serie` deve chiamare una funzione `pow` che prende in ingresso due interi `a` e `b` e restituisce $\mathbf{a^b}$.

#### RISOLUZIONE

**Codice C**:

```c
int pow(int i, int m) {
    return i ** m;
}

int serie(int n, int m) {
    int sum = 0;
    for (int i = 1; i <= n; i++)
        sum += pow(i, m);
    return sum;
}
```

**Codice Risc-V**:

```asm
.global main

.text
main:
    li x10, 3        // n
    li x11, 2        // m
    jal x1, serie    // Call serie(3,2)
    
    // x10 = 1^2 + 2^2 + 3^2 = 1 + 4 + 9 = 14
    
    li x17, 93      // Set exit syscall
    ecall           // Call exit syscall

// x10 = n
// X11 = m

pow:
    addi x5, x0, 1      // res = 1
    add x30, x0, x0     // i = 0
POWL:
    bge x30, x11, POWE  // Goto POWE if (i >= m)
    mul x5, x5, x10     // res *= n
    addi x30, x30, 1    // i++
    jal x0, POWL        // Goto POWL
POWE:
    add x10, x0, x5     // x10 = res
    jalr x0, 0(x1)      // Return to caller

// x10 = n
// x11 = m

serie:
    addi x2, x2, -40    // Allocate stack
    sd x1, 0(x2)        // Save ra
    sd x18, 8(x2)       // Save s2
    sd x19, 16(x2)      // Save s3
    sd x20, 24(x2)      // Save s4
    sd x21, 32(x2)      // Save s5

    add x20, x0, x10    // x20 = n
    add x21, x0, x11    // x21 = m

    add x18, x0, x0     // sum = 0
    addi x19, x0, 1     // i = 1
LOOP:
    blt x20, x19, END   // Goto END if (i > n)

    add x10, x0, x19    // Set 1° arg (i)
    add x11, x0, x21    // Set 2° arg (m)
    jal x1, pow         // Call pow

    add x18, x18, x10   // sum += pow(i, m)

    addi x19, x19, 1    // i++
    jal x0, LOOP        // Goto LOOP
END:
    add x10, x0, x18    // x10 = sum

    ld x1, 0(x2)        // Restore ra
    ld x18, 8(x2)       // Restore s2
    ld x19, 16(x2)      // Restore s3
    ld x20, 24(x2)      // Restore s4
    ld x21, 32(x2)      // Restore s5
    addi x2, x2, 40     // Deallocate stack

    jalr x0, 0(x1)      // Return to caller
```

**Ricorda**:

- Molto spesso uso `addi` (add immediate) anche quando devo **sommare due registri**. **NON VA BENE**! Devo ricordarmi di usare `add`.
