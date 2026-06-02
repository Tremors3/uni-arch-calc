#### [LINK FIGURA](03a-prova-scritta-09-giugno-2021.png)

#### QUESITO

relativo all’esecuzione del seguente stralcio di codice assembly:

```asm
ld   x10,40(x1)
sub  x11,x2,x3
add  x12,x3,x4
ld   x13,48(x1)
add  x14,x5,x6
```

Dire quanto valgono i segnali cerchiati in figura, motivando chiaramente le risposte.

#### RISOLUZIONE

| IF              | ID              | EX              | MEM             | WB              |
|-----------------|-----------------|-----------------|-----------------|-----------------|
| `add x14,x5,x6` | `ld x13,48(x1)` | `add x12,x3,x4` | `sub x11,x2,x3` | `ld x10,40(x1)` |

Segnali di controllo:
- PCSrc = 0                 # In fase di MEM non c'è una istruzione di salto
- RegWrite = 1              # L'istruzione in fase di WB scrive su registro
- Write Register = x10      # L'istruzione in fase di WB scrive sul registro x10
- ALU control = 0010        # L'istruzione in fase di EX è una ADD
- ALUSrc = 0                # L'istruzione in fase di EX non usa immediato
- MemWrite = 0              # L'istruzione in fase di MEM non scrive su memoria
- MemReed = 0               # L'istruzione in fase di MEM non legge da memoria
- MemToReg = 1              # L'istruzione in fase di WB scrive il valore letto da memoria
