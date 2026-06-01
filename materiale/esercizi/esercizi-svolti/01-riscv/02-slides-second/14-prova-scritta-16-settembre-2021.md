
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

Risposte corrette:

- **b) fun non adempie alla calling convention**
- **c) fun2 non adempie alla calling convention**
- **d) Non ritorna correttamente al chiamante di fun**
