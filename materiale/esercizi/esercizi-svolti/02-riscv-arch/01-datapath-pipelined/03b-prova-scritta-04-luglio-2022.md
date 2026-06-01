
#### [LINK FIGURA](06a-prova-scritta-4-luglio-2022.png)

#### QUESITO

Si consideri il programma assembly RISC-V dell’esercizio 4. Considerando il diagramma della pipeline RISC-V single-cycle indicare quanto valgono i segnali di controllo cerchiati in figura quando l’ultima istruzione, la 'jalr zero,ra', si trova in fase di fetch.

ATTENZIONE: Si deve considerare il flusso di esecuzione dinamico del programma, non la sequenza statica di istruzioni. Si ragioni su quali istruzioni vengono eseguite prima della jalr per riempire la pipeline. 

#### RISOLUZIONE

| IF             | ID               | EX            | MEM            | WB            |
|----------------|------------------|---------------|----------------|---------------|
| `jalr zero,ra` | `beq s0,zero,L2` | `sb a1,0(s1)` | `add s1,a2,a0` | `jal zero,L1` |

Segnali di controllo:
- PCSrc = 0                 # In fase di MEM non c'è un'istruzione di salto
- RegWrite = 0              # L'istruzione in WB non scrive su registro
- Write register = XXXXX    # L'istruzione in WB non scrive su registro
- ALU control = 0010        # L'istruzione in EX richiede una somma
- ALUSrc = 1                # L'istruzione in EX utilizza l'immediato
- MemWrite = 0              # L'istruzione in MEM non scrive su memoria
- MemReed = 0               # L'istruzione in MEM non legge da memoria
- MemToReg = X              # L'istruzione in WB non scrive su registro

#### NOTE

1. **Ricostruire il flusso dinamico**
    
    Non basta guardare la sequenza statica di istruzioni: bisogna seguire l’esecuzione reale, considerando i salti presi o non presi.

    Si parte dall’ultima istruzione richiesta (`jalr zero, ra`) e si risale all’**indietro** nel programma, seguendo i branch e le jump per capire quali istruzioni la precedono immediatamente in esecuzione.

    Esempio:
    ```asm
    L1:  add  s1,s2,a0   # 4°
         sb   a1,0(s1)   # 3°
         beq  s0,zero,L2 # 2°
         addi s2,s2,1
         jal  zero,L1    # 5°
    L2:  jalr zero,ra    # 1°
    ```

    Le istruzioni vanno inserite nella pipeline nell’**ordine inverso** rispetto alla numerazione del flusso, in modo da avere la situazione nei cinque stadi al momento voluto.

2. **Determinare PCSrc**

    Per capire se **PCSrc** è 0 o 1, bisogna guardare l’istruzione in **MEM**:
    - Se è un branch/jump e la condizione è vera, PCSrc = 1
    - Altrimenti PCSrc = 0
