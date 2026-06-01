
### QUESITO

Si assuma che x11 contenga 11 e x12 contenga 22. Supponendo di eseguire il codice sottostante su una versione della pipeline a cinque stadi RISC-V che non gestisce i data hazards (il programmatore deve gestirli esplicitamente inserendo delle NOP), si dica che valore hanno alla fine i registri x13, x14 e x15. Se questi valori sono diversi da quelli attesi, si mostri come occorre modificare il codice per ottenere i risultati corretti. Si assuma che il register file sia scritto durante la prima metà di un ciclo e letto durante la seconda metà (quindi ciò che viene scritto nello stadio WB a un dato ciclo è visibile nello stesso ciclo nello stadio ID).

```c
# x11 = 11
# x12 = 22

addi x11, x12, 5
add  x13, x11, x12
addi x14, x11, 15
add  x15, x11, x11
```

### RISOLUZIONE

#### Codice non corretto:

```c
addi x11, x12, 5        |     | x11 = 11, x12 = 22 |     |     | x11 = 27 |
add  x13, x11, x12            |     | x11 = 11, x12 = 22 |     |     | x13 = 16 |
addi x14, x11, 15                   |     | x11 = 11, x12 = 22 |     |     | x14 = 26 |
add  x15, x11, x11                        |     | x11 = 27, x12 = 22 |     |     | x14 = 54 |
```

#### Codice corretto:

```c
addi x11, x12, 5        |     | x11 = 11, x12 = 22 |     |     | x11 = 27 |
nop                           |     |                    |     |     | x11 = 27 |
nop                                 |     |                    |     |     | x11 = 27 |
add  x13, x11, x12                        |     | x11 = 27, x12 = 22 |     |     | x13 = 49 |
addi x14, x11, 15                               |     | x11 = 27, x12 = 22 |     |     | x14 = 42 |
add  x15, x11, x11                                    |     | x11 = 27, x12 = 22 |     |     | x14 = 54 |
```
