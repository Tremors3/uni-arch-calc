
#### QUESITO

Si consideri di eseguire il seguente stralcio di codice su una pipeline RISC-V con logica di forwarding e dynamic branch predictor a due bit, inizialmente settato a BRANCH NOT TAKEN.

```asm
    li t2,3 // UB
    li t0,1 // i = 1
loop_i:
    li t1,0 // j = 0
loop_j:
    addi t1,t1,1
    blt  t1,t2,loop_j

    addi t0,t0,1
    blt  t0,t2,loop_i

    jr ra
```

- a) Si calcoli la misprediction rate.

- b) Sapendo che: 
    - per ogni predizione corretta un’istruzione di tipo branch impiega 1 ciclo ad eseguire, mentre in caso di misprediction ne impiega 8
    - le istruzioni aritmetico-logiche impiegano 3 cicli a eseguire
    - il salto incondizionato impiega 1 ciclo ad eseguire
    
    Si calcoli il CPI medio per l’esecuzione del programma

#### RISOLUZIONE

| Id | instruction  | Taken/Not Taken | 2 bit predictor | Hit/Miss |
|----|--------------|-----------------|-----------------|----------|
|  1 | li       |   |    |   |
|  2 | li       |   |    |   |
|  3 | li       |   |    |   |
|  4 | addi     |   |    |   |
|  5 | blt lj   | T | N2 | M |
|  6 | addi     |   |    |   |
|  7 | blt lj   | T | N1 | M |
|  8 | addi     |   |    |   |
|  9 | blt lj   | N | T1 | M |
| 10 | addi     |   |    |   |
| 11 | blt li   | T | N1 | M |
| 12 | li       |   |    |   |
| 13 | addi     |   |    |   |
| 14 | blt lj   | T | T1 | H |
| 15 | addi     |   |    |   |
| 16 | blt lj   | T | T2 | H |
| 17 | addi     |   |    |   |
| 18 | blt lj   | N | T2 | M |
| 19 | addi     |   |    |   |
| 20 | blt li   | N | T1 | M |
| 21 | jr       |   |    |   |

- **Instruction Counts**:
    - Arithmetic Instructions = 12
    - Branch Instructions = 8
    - Unconditional Jumps = 1

- **Branch hit-miss count**:
    - Misses = 6 / 8
    - Hits = 2 / 8

$$ CPI_{avg} = \frac{1}{IC} \times \sum_{i = 1}^{n} (CPI_i \cdot IC_i) $$

$$ CPI_{avg} = \frac{1}{21} \times \left(12 \cdot 3 + 1 \cdot 1 + 8 \cdot (\frac{6 \cdot 8 + 2 \cdot 1}{8}) \right) = \frac{36 + 1 + 50}{21} = \frac{87}{21} \approx 4 $$
