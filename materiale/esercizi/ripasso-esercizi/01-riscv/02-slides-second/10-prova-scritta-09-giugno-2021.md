
#### QUESITO

Si scriva una funzione `sommatoria` che prende in ingresso un intero n e ritorna la sommatoria mostrata sotto. Se n è non positivo la funzione ritorna -1, se è nullo ritorna 0.

$$ 1^1 + 2^2 + 3^3 + ... + n^n $$

Per svolgere il calcolo la funzione `sommatoria` deve chiamare una funzione `elev` che prende in ingresso un intero $a$ e restituisce $a^a$.

Si scrivano le funzioni `sommatoria` e `elev` rispettando la calling convention RISC-V e 
gestendo opportunamente lo stack e il register file, utilizzando i registri appropriati.

#### RISOLUZIONE

```C
int elev(int n) {
    int res = 1;
    for (int i = n; i > 0; i--)
        res *= n;
    return res;
}

int sommatoria(int n) {
    if (n < 0) return -1;
    if (n == 0) return 0;

    int res = 0;
    for (; n > 0; n--)
        res += elev(n);
    return res;
}
```

```asm
# x10 = n
elev:
    addi x5, x0, 1      # res = 1
    add x6, x0, x10     # temp = n
eLOOP:
    bge x0, x6, eENDL   # Goto eENDL if (temp <= 0)
    mul x5, x5, x10     # res *= n
    addi x6, x6, -1     # n--
    jal x0, eLOOP       # Goto eLOOP
eENDL:
    add x10, x0, x5     # x10 (ret val) = res
    jalr x0, 0(x1)      # Return to caller
# x10 = n
sommatoria:
    bge x10, x0, ENDIF1 # Goto ENDIF1 if (n >= 0)
    addi x10, x0, -1    # x10 (ret val) = -1
    jalr x0, 0(x1)      # Return to caller
ENDIF1:
    bne x10, x0, ENDIF2 # Goto ENDIF2 if (n != 0)
    addi x10, x0, 0     # x10 (ret val) = 0
    jalr x0, 0(x1)      # Return to caller
ENDIF2:
    addi x2, x2, -12    # Allocate stack
    sw x1, 0(x2)        # Save ra
    sw x29, 4(x2)       # Save s3   (n)
    sw x30, 8(x2)       # Save s4   (res)

    add x29, x0, x10    # s3 = n
    add x30, x0, x0     # s4 (res) = 0
sLOOP:
    bge x0, x29, sENDL  # Goto sENDL if (n <= 0)

    add x10, x0, x29    # x10 = n
    jal x1, elev        # x10 = elev(n)
    add x30, x30, x10   # res += elev(n)

    addi x29, x29, -1   # n--
    jal x0, sLOOP       # Goto sLOOP
sENDL:
    add x10, x0, x30    # x10 (ret val) = res

    lw x1, 0(x2)        # Restore ra
    lw x29, 4(x2)       # Restore s3
    lw x30, 8(x2)       # Restore s4
    addi x2, x2, 12     # Deallocate stack

    jalr x0, 0(x1)      # Return to caller
```
