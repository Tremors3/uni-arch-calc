
#### QUESITO

Si scriva una funzione `serie` che prende in ingresso due interi `n` ed `m` e ritorna la sommatoria mostrata sotto. Se `n` è non positivo la funzione ritorna **0**. 

$$ n^m + (n-1)^m + (n-2)^m + ... + 1^m $$

Per svolgere il calcolo la funzione `serie` deve chiamare una funzione `pow` che prende in ingresso due interi `a` e `b` e restituisce $\mathbf{a^b}$.

#### RISOLUZIONE

```C
int pow (int a, int b) {
    int res = 1;
    for (int i = 0; i < b; i++) {
        res *= a;
    }
    return res;
}

int serie(int n, int m) {
    if (n < 0) return 0;

    int res = 0;

    for (int i = 1; i <= n; i++) {
        res += pow(i, m);
    }

    return res;
}
```

```asm
# x10 = a
# x11 = b
pow:
    addi x30, x0, 1         # res = 1
    add x29, x0, x0         # i = 0
powL1:
    bge x29, x11, powENDL1  # Goto powENDL1 if (i >= b)
    mul x30, x30, x10       # res *= a
    addi x29, x29, 1        # i++
    jal x0, powL1           # Goto powL1
powENDL1:
    add x10, x0, x30        # x10 (ret val) = res
    jalr x0, 0(x1)          # Return to caller
# x10 = n
# x11 = m
serie:
    bge x10, x0, serENDIF   # Goto serENDIF if (n >= 0)
    xor x10, x0, x0         # x10 (ret val) = 0
    jalr x0, 0(x1)          # Return to caller
serENDIF:
    addi x2, x2, -20        # Allocate stack
    sw x1, 0(x2)            # Save ra
    sw x18, 4(x2)           # Save s2   (res)
    sw x19, 8(x2)           # Save s3   (i)
    sw x20, 12(x2)          # Save s4   (n)
    sw x21, 16(x2)          # Save s5   (m)

    add x20, x0, x10        # x10 = n
    add x21, x0, x11        # x11 = m

    xor x18, x0, x0         # res = 0
    addi x19, x0, 1         # i = 1
serL1:
    blt x20, x19, serENDL1  # Goto serENDL1 if (i > n)

    add x10, x0, x19        # 1° Arg = i
    add x11, x0, x21        # 2° Arg = m
    jal x1, pow             # x10 = pow(i, m)
    add x18, x18, x10       # res += pow(i, m)
    addi x19, x19, 1        # i++
    jal x0, serL1           # Goto SerL1
serENDL1:
    add x10, x0, x18        # x10 (ret val) = res

    lw x1, 0(x2)            # Restore ra
    lw x18, 4(x2)           # Restore s2
    lw x19, 8(x2)           # Restore s3
    lw x20, 12(x2)          # Restore s4
    lw x21, 16(x2)          # Restore s5
    addi x2, x2, 20         # Deallocate stack

    jalr x0, 0(x1)          # Return to caller
```
