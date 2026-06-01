#### QUESITO

Si consideri di eseguire il seguente stralcio di codice su una pipeline RISC-V con logica di forwarding e con dynamic branch predictor a 1 bit. Inizialmente il predittore è settato a BRANCH TAKEN. Qual è la misprediction rate per questo codice?

```asm
    li t0,1 
    li t1,0 
    li t2,10 
loop: 
    slli t0,t0,1 
    addi t1,t1,1 
    blt  t1,t2,loop 
```

- a) 10% 
- b) 20% 
- c) 30% 
- d) Nessuna delle precedenti

#### RISOLUZIONE

1. **Numero di iterazioni**
    - Il ciclo incrementa t1 partendo da 0 fino a raggiungere il valore t2 = 10.
    - Questo significa che il corpo del ciclo viene eseguito 10 volte e il branch blt t1, t2, loop viene valutato 10 volte:
        - 9 volte con salto taken (rientro nel loop)
        - 1 volta con salto not taken (uscita dal loop).

2. **Comportamento del predittore a 1 bit**
    - All’inizio il predittore è impostato su taken.
    - Per le prime 9 iterazioni, la predizione è taken e risulta corretta.
    - All’ultima iterazione, la condizione t1 < t2 è falsa, quindi il salto reale è not taken, ma il predittore (ancora impostato su taken) sbaglia la predizione.
    - Dopo l’uscita, il predittore cambierebbe stato, ma il ciclo termina, quindi non ci sono altri salti.

3. **Calcolo del misprediction rate**

    $$ \text{Misprediction rate} = \frac{\text{numero di predizioni errate}}{\text{numero totale di predizioni}} = \frac{1}{10} = \textbf{10\%} $$
