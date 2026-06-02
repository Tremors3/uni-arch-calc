
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

- a) **`33`**
- b) 30
- c) 11
- d) 3

#### RISOLUZIONE

Il ciclo compie **11 iterazioni** perchè x6 = 10 e decrementa di 1 ad ogni iterazione fino a che non diventa x6 < 0. Il registro x5 inizialmente è x5 = 0, e ad ogni iterazione viene **incrementato di 3**.

Risultato: **11 * 3 = `33`**.