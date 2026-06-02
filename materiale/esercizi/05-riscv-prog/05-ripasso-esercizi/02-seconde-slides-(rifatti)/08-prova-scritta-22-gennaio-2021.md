
#### QUESITO

Scrivere una funzione assembly che prende in ingresso due interi O, N e calcola Z, dove:

$$ Z = \begin{cases}
    2^N,        \hspace{30pt} \text{if } O = 0 \\
    log_2 N,    \hspace{17pt} \text{if } O = 1
\end{cases} $$

#### RISOLUZIONE

```C
int func (int n, int O) {
    int res;

    if (O = 1) {
        // EXP
        //for (res = 1; n > 0; n--) { res *= 2; }
        res = 1 << n;
    } else {
        // LOG
        for (res = 0; n > 0; n >> 1) { res ++; }
    }
}
```

```
# x10 = N
# x11 = O
func:
    beq x11, x0, EXP    # Goto EXP if (O == 1)
    add x5, x0, x0      # res = 0
LOG:
    bge x0, x10, END    # Goto END if (n <= 0)
    srli x10, x10, 1    # N >> 1 (N/2)
    addi x5, x5, 1      # res++
    jal x0, LOG         # Goto LOG
EXP:
    addi x6, x0, 1      # temp = 1
    sll x5, x6, x10     # x5 = 1 << N
END:
    add x10, x0, x5     # x10 (ret val) = res
    jalr x0, 0(x1)      # Return to caller
```