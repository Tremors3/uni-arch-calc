
#### QUESITO

Si consideri il seguente loop RISCV. 

```
CICLO: 
    blt x13, x0, EXIT
    addi x13, x13, -1
    addi x12, x12, 2
    jal x0, CICLO
EXIT:
```

Assumendo che il registro x12 sia inizializzato col valore 0 e il registro x13 col valore 10, 
qual è il valore contenuto in x12 dopo l’esecuzione di queste istruzioni?

- a) **`22`**
- b) 20
- c) 10
- d) 2

#### Risoluzione

Il ciclo esegue 11 iterazioni (x13 = 10, 9, ..., 1, 0).
Ad ogni iterazione x12 viene incrementato di 2. Quindi 11 * 2 = **`22`**.