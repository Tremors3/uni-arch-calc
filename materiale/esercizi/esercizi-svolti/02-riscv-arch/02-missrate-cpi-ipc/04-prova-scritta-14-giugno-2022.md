
#### QUESITO

Si consideri di eseguire il seguente stralcio di codice su una pipeline RISC-V con logica di forwarding e con dynamic branch predictor a singolo bit inizialmente settato a BRANCH TAKEN. 

```asm
    li t2,3 // UB
    li t0,0 // i = 0
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
    - per ogni predizione corretta un’istruzione di tipo branch impiega 2 cicli ad eseguire, mentre in caso di misprediction ne impiega 8
    - le istruzioni aritmetico-logiche impiegano 2 cicli a eseguire
    - il salto incondizionato impiega 2 cicli ad eseguire

    Si calcoli il CPI medio per l’esecuzione del programma

#### RISOLUZIONE

| Id | instruction  | Taken/Not Taken | 1 bit predictor | Hit/Miss |
|----|--------------|-----------------|-----------------|----------|
|  1 | li           |   |   |   |
|  2 | li           |   |   |   |
|  3 | li           |   |   |   |
|  4 | addi         |   |   |   |
|  5 | blt loop_j   | T | T | H |
|  6 | addi         |   |   |   |
|  7 | blt loop_j   | T | T | H |
|  8 | addi         |   |   |   |
|  9 | blt loop_j   | N | T | M |
| 10 | addi         |   |   |   |
| 11 | blt loop_i   | T | N | M |
| 12 | li           |   |   |   |
| 13 | addi         |   |   |   |
| 14 | blt loop_j   | T | T | H |
| 15 | addi         |   |   |   |
| 16 | blt loop_j   | T | T | H |
| 17 | addi         |   |   |   |
| 18 | blt loop_j   | N | T | M |
| 19 | addi         |   |   |   |
| 20 | blt loop_i   | T | N | M |
| 21 | li           |   |   |   |
| 22 | addi         |   |   |   |
| 23 | blt loop_j   | T | T | H |
| 24 | addi         |   |   |   |
| 25 | blt loop_j   | T | T | H |
| 26 | addi         |   |   |   |
| 27 | blt loop_j   | N | T | M |
| 28 | addi         |   |   |   |
| 29 | blt loop_i   | N | N | H |
| 30 | jal          |   |   |   |

- **Instruction Counts**:
    - Arithmetic Instructions = 17
    - Branch Instructions = 12
    - Unconditional Jumps = 1

- **Branch hit-miss count**:
    - Misses = 5 / 12
    - Hits = 7 / 12

- **Calcolo del $\textbf{CPI}_{\textbf{avg}}$**:

$$ CPI_{avg} = \frac{1}{IC} \times \sum_{i = 1}^{n} (CPI_i \cdot IC_i) $$

$$ CPI_{avg} = \frac{1}{30} \times \left(17 \cdot 2 + 1 \cdot 2 + 12 \cdot (\frac{5 \cdot 8 + 7 \cdot 2}{12}) \right) = \frac{34 + 2 + 54}{30} = \frac{90}{30} = 3  $$

