
#### QUESITO

Si consideri di eseguire il seguente stralcio di codice su una pipeline RISC-V con logica di forwarding e con dynamic branch predictor a due bit inizialmente settato a BRANCH TAKEN.

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
    - il salto incondizionato impiega 8 cicli ad eseguire

    Si calcoli il CPI medio per l’esecuzione del programma

#### RISOLUZIONE

| Id | instruction  | Taken/Not Taken | 2 bit predictor | Hit/Miss |
|----|--------------|-----------------|-----------------|----------|
|  1 | li       |   |    |   |
|  2 | li       |   |    |   |
|  3 | li       |   |    |   |
|  4 | addi     |   |    |   |
|  5 | blt lj   | T | T2 | H |
|  6 | addi     |   |    |   |
|  7 | blt lj   | T | T2 | H |
|  8 | addi     |   |    |   |
|  9 | blt lj   | N | T2 | M |
| 10 | addi     |   |    |   |
| 11 | blt li   | T | T1 | H |
| 12 | li       |   |    |   |
| 13 | addi     |   |    |   |
| 14 | blt lj   | T | T2 | H |
| 15 | addi     |   |    |   |
| 16 | blt lj   | T | T2 | H |
| 17 | addi     |   |    |   |
| 18 | blt lj   | N | T2 | M |
| 19 | addi     |   |    |   |
| 20 | blt li   | T | T1 | H |
| 21 | li       |   |    |   |
| 22 | addi     |   |    |   |
| 23 | blt lj   | T | T2 | H |
| 24 | addi     |   |    |   |
| 25 | blt lj   | T | T2 | H |
| 26 | addi     |   |    |   |
| 27 | blt lj   | N | T2 | M |
| 28 | addi     |   |    |   |
| 29 | blt li   | N | T1 | M |
| 30 | jr       |   |    |   |

- **Instruction Counts**:
    - Arithmetic Instructions = 17
    - Branch Instructions = 12
    - Unconditional Jumps = 1

- **Branch hit-miss count**:
    - Misses = 4 / 12
    - Hits = 8 / 12

- **Calcolo del $\textbf{CPI}_{\textbf{avg}}$**:

$$ CPI_{avg} = \frac{1}{IC} \times \sum_{i = 1}^{n} (CPI_i \cdot IC_i) $$

$$ CPI_{avg} = \frac{1}{30} \times \left(17 \cdot 2 + 1 \cdot 8 + 12 \cdot (\frac{4 \cdot 8 + 8 \cdot 2}{12}) \right) = \frac{34 + 8 + 48}{30} = \frac{90}{30} = 3  $$

#### NOTE

1. **Costruzione Rapida della tabella**

    - Scrivere solo le istruzioni essenziali in forma abbreviata (evitare gli argomenti delle istruzioni).
    - Per i branch, indicare la label di destinazione in forma abbreviata (`beq l1` $\rightarrow$ loop_1, `beq l2` $\rightarrow$ loop_2), e:
        - Esito reale (*Taken* / *Not taken*)
        - Stato del predittore prima della valutazione
        - Hit o Miss

    - Mantenere solo le colonne essenziali:
        - **Indice istruzione**: per contare il numero totale di istruzioni.
        - **Istruzione (forma breve)**: per verificare rapidamente la correttezza dell’esercizio.
        - **Branch Taken/Not Taken**: indica se il salto è stato eseguito (Taken) o meno (Not Taken) (solo per le istruzioni di branch).
        - **Predittore (1 o 2 bit)**: stato e previsione del predittore (solo per le istruzioni di branch).
        - **Hit/Miss**: risultato della previsione del predittore (solo per le istruzioni di branch).

2. **Predittore a 2 bit**

    - Stati: **T2** → **T1** → **N1** → **N2**
    - Tre errori consecutivi sono necessari per passare da *strongly taken* (T2) a *strongly not taken* (N2).
    - Lo stato viene aggiornato **dopo** la valutazione del branch.

3. **Conteggio hit/miss**

    - Contare separatamente il numero di predizioni corrette (hit) e sbagliate (miss).
    - Usare questi valori per calcolare **misprediction rate** e, in base ai cicli per tipo di istruzione, il **CPI medio**.