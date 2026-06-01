
#### QUESITO

Relativamente al programma mostrato, quali affermazioni sono vere?

```asm
fun:
    li t0, 5
    li t1, 1
    add s0, t0, t1
    mv a0, s0
    jal ra, fun2
    add a0, a0, t0
    ret
 
fun2:
    addi t0, a0, 1
    ret
```

- a) fun ritorna 12
- b) fun non adempie alla calling convention
- c) fun2 non adempie alla calling convention
- d) Non ritorna correttamente al chiamante di fun

#### RISOLUZIONE

```asm
fun:
    li t0, 5        # t0 = 5
    li t1, 1        # t1 = 1
    add s0, t0, t1  # s0 = 6
    mv a0, s0       # a0 = 6
    jal ra, fun2    # Call fun2 procedure
    add a0, a0, t0  # a0 = 6 + 5 = 11
    ret             # Return to caller
 
fun2:
    addi t0, a0, 1  # t0 = 7
    ret             # Return to caller
```

VERE:
- b) fun non adempia alla calling convention
- c) fun2 non adempia alla calling convention
- d) Non ritorna correttamente al chiamante di fun
