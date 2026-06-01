#### QUESITO

Si consideri la seguente sequenza di istruzioni, e si supponga che venga eseguita su un’unità di elaborazione dotata di pipeline a cinque stadi.

```asm
add  x15, x12, x11 
ld   x13, 4(x15) 
ld   x12, 0(x2) 
or   x13, x15, x13 
sd   x13, 0(x15) 
```

Inserire opportunamente delle NOP per assicurare la corretta esecuzione del codice, supponendo che non ci siano né propagazione né rilevamento degli hazard. Si dica se è possibile riordinare il codice per minimizzare il numero di NOP richieste.

#### RISOLUZIONE

```asm
add  x15, x12, x11
nop
nop
ld   x13, 4(x15)
ld   x12, 0(x2)
nop
or   x13, x15, x13
nop
nop
sd   x13, 0(x15)
```

- **Riordinare il codice non comporta una diminuizione del numero di nop.**
