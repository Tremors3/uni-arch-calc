
#### QUESITO

Si consideri il diagramma della pipeline RISC-V single-cycle indicato in figura. Sapendo che i segnali di controllo cerchiati in rosso valgono 

- PCSrc = 1
- RegWrite = 1
- Write register = 10
- ALUSrc = 1
- ALU control = 0110
- MemWrite = 1
- MemRead = 0
- MemtoReg = 1

dire che istruzioni si trovano nei vari stadi della pipeline, ove possibile. Per ogni istruzione si fornisca il massimo livello di dettaglio possibile (es., in certi casi si potrà solo dire a che classe appartiene una istruzione, in altri si potrà identificare esattamente l’istruzione. In alcuni casi non si potrà dire niente sui registri utilizzati dall’istruzione, in altri sì; etc.). 

#### RISOLUZIONE

- **IF**: non determinabile
- **ID**: non determinabile
- **EX**:
    - Il segnale ALUSrc = 1 indica che l’operando B dell’ALU proviene da un immediato.
    - Il segnale ALU control = 0110 imposta l’ALU sull’operazione di sottrazione (SUB).
    - Questo suggerisce che si tratta di una istruzione `beq rs1, rs2, LBL` del tipo `BRANCH`
- **MEM (caso 1)**:
    - Il segnale PCSrc = 1 indica che il PC verrà aggiornato in base a un branch.
    - Questo suggerisce che in MEM vi sia un’istruzione di salto condizionato `BRANCH`.
    - (In conflitto con la successiva)
- **MEM (caso 2)**:
    - Il segnale MemWrite = 1 e MemRead = 0 indica un’operazione di scrittura in memoria, quindi un’istruzione di tipo `STORE`.
    - (In conflitto con la precedente)
- **WB**:
    - Il bit MemtoReg è pari ad 1 quindi si tratta di una istruzione che scrive su registro destinazione il valore ottenuto da memoria. L'istruzione sarà una `LOAD`.