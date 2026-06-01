#### QUESITO

Un branch predictor cerca di predire il comportamento dei salti durante l’esecuzione del programma. Un predictor a 1 bit sfrutta un buffer (tabella di predizione dei salti) con una sola locazione di memoria, quindi può memorizzare solo lo stato dell’ultimo salto. Si consideri un ciclo che contiene un salto condizionato che viene eseguito nove volte di seguito, ma non la decima volta. Qual è l’accuratezza di questo predittore?

- **a)** 80%
- **b)** 90%
- **c)** 100%
- **d)** Nessuna delle precedenti

#### RISOLUZIONE

```
Hits = 0

Hits + 0:   Miss  1° time
Hits + 1:   Hit   2° time
. . .
Hits + 1:   Hit   9° time
Hits + 0:   Miss 10° time

Hits = 8
Total = 10
Accuracy = Hits / Total = 8 / 10 = 80%
```

- **`a)`: 80%, perchè sbaglia la predizione della prima e dell'ultima iterazione!**
