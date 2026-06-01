
#### QUESITO

Scrivere una funzione assembly che prende in ingresso due interi O, N e calcola Z, dove:

$$ Z = \begin{cases}
    2^N,        \hspace{30pt} \text{if } O = 0 \\
    log_2 N,    \hspace{17pt} \text{if } O = 1
\end{cases} $$

#### RISOLUZIONE

```
Z:
    add x5, x0, x10         // x5 = O
    add x6, x0, x11         // x6 = N
    addi x7, x0, 1          // x7 = 1
    add x28, x0, x0         // sum for log
    beq x10, x0, POW        // Goto POW if (O == 0)
LOG:
    srli x6, x6, 1          // N >> 1
    addi x28, x28, 1        // sum ++
    blt x7, x6, LOG         // Goto LOG until (N > 1)
    add x10, x0, x28        // x10 = sum
    jal x0, END             // Goto END
POW:
    sll x10, x7, x6         // x10 = 1 << N
END:
```

**Ricorda**:

- $2^N$: Si calcola shiftando 1 a sinistra di N posizioni.

- $log_2 N$: Si calcola **contando il numero di shift verso destra** del numer N.
    - *Esempio*: Se **`N = 8`**, contiamo il numero di shift: 
      - **`(8 --> 4 --> 2 --> 1) = 3` shift verso destra**.
      - **Infatti `log2(8) = 3`**.
