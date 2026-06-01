
#### QUESITO

Si consideri di eseguire il seguente stralcio di codice su una pipeline RISC-V con logica di 
forwarding e con dynamic branch predictor a 1 bit. Inizialmente il predittore è settato a 
BRANCH NOT TAKEN. Qual è la misprediction rate per questo codice? 

```asm
    li x5,1
    li x6,10
loop: 
    addi x6,x6,-1
    slli x5,x5,1
    bgt  x6,x0,loop
```

- a) 10% 
- b) 20% 
- c) 30% 
- d) Nessuna delle precedenti

#### RISOLUZIONE

- Il ciclo effettua **10 iterazioni**, di conseguenza vengono effettuate **10 predizioni**.
  - La **prima** predizione risulta in una **MISS**, dato che il bit è settato a BRANCH NOT TAKEN ma salto viene fatto.
  - Le **successive 8** predizioni risultano tutte in delle **HIT**, dato che il bit è settato a BRANCH TAKEN e il salto viene fatto.
  - L'**ultima** predizione risulta in una **MISS**, dato che il bit è settato a BRANCH TAKEN ma il salto non viene fatto.

$$ \text{Misprediction rate} = \frac{\text{numero di predizioni errate}}{\text{numero totale di predizioni}} = \frac{2}{10} = 20\% $$
