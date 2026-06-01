
#### [LINK FIGURA](11a-prova-scritta-09-giugno-2021.png)

#### QUESITO

Si consideri il seguente diagramma single-cycle.

Relativo all’esecuzione del seguente stralcio di codice assembly: 

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
- PCSrc = 0     $\rightarrow$ in fase di MEM non sta eseguendo una BRANCH.
- RegWrite = 1  $\rightarrow$ in fase di WB sta eseguendo una istruzione che scrive su registro.
- Write register = x10  $\rightarrow$ in fase di WB sta eseguendo una istruzione che scrive sul registro x10.
- ALU control = 0010    $\rightarrow$ in fase di EX sta eseguendo una ADD.
- ALUSrc = 0    $\rightarrow$ in fase di EX l'istruzione non usa immediato.
- MemWrite = 0  $\rightarrow$ in fase di MEM l'istruzione non scrive in memoria
- MemReed = 0   $\rightarrow$ in fase di MEM l'istruzione non legge da memoria
- MemtoReg = 1  $\rightarrow$ in fase di WB l'istruzione scrive il valore letto da memoria nella fase precedente.