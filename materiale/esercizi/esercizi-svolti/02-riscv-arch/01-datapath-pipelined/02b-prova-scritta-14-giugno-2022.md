#### [LINK FIGURA](05a-prova-scritta-14-giugno-2022.png)

#### QUESITO

Si consideri il programma assembly RISC-V dell’esercizio 4. Considerando il diagramma della pipeline RISC-V single-cycle indicare quanto valgono i segnali di controllo cerchiati in figura quando l’ultima istruzione (la jr ra, si trova in fase di fetch).

#### RISOLUZIONE

| IF      | ID             | EX             | MEM            | WB             |
|---------|----------------|----------------|----------------|----------------|
| `jr ra` | `blt t0,t2,li` | `addi t0,t0,1` | `blt t1,t2,lj` | `addi t1,t1,1` |

Segnali di controllo:
- PCSrc = 0                 # L'istruzione in fase di WB è una branch ma la condizione è falsa
- RegWrite = 1              # L'istruzione in fase di WB scrive su registro
- Write register = t1       # L'istruzione in fase di WB scrive sul registro t1
- ALU control = 0010        # L'istruzione in fase di WB è una ADDI
- ALUSrc = 1                # L'istruzione in fase di WB usa un immediato
- MemWrite = 0              # L'istruzione in fase di WB non scrive su memoria
- MemReed = 0               # L'istruzione in fase di WB non legge da memoria
- MemToReg = 0              # L'istruzione in fase di WB non scrive il valorre letto da memoria
