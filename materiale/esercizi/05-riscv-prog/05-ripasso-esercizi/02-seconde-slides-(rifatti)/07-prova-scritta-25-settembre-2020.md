
#### QUESITO

Si consideri il seguente loop RISCV.

```
CICLO: 
    blt x6, x0, EXIT
    addi x6, x6, -1
    addi x5, x5, 3
    jal x0, CICLO
EXIT:
```

Assumendo che il registro x5 sia inizializzato col valore 0 e il registro x6 col valore 10, 
qual è il valore contenuto in x5 dopo l’esecuzione di queste istruzioni?

- a) 33
- b) 30
- c) 11
- d) 3

#### RISOLUZIONE

- Il ciclo compie 11 iterazioni.
- Ogni iterazione il valore di x5 viene incrementato di 3 (x5 parte da 0).
- Valore di x5 post iterazioni: **33**.
    $$ \text{x5} = 11 * 3 = 33 $$