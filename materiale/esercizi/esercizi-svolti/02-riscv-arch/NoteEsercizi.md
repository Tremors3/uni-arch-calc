
## Note Esercizio Datapath Pipelined

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

---

## Note Esercizio Calcolo del CPI Medio

1. **Costruzione Rapida della tabella**

    - Scrivere solo le istruzioni essenziali in forma abbreviata (evitare gli argomenti delle istruzioni).
    - Per i branch, indicare la label di destinazione in forma abbreviata (`beq l1` $\rightarrow$ loop_1, `beq l2` $\rightarrow$ loop_2), e:
        - Esito reale (*Taken* / *Not taken*)
        - Stato del predittore prima della valutazione
        - Hit o Miss

    - Mantenere solo le colonne essenziali:
        - **Indice istruzione**: per contare il numero totale di istruzioni.
        - **Istruzione (forma breve)**: per verificare rapidamente la correttezza dell’esercizio.
        - **Branch Taken/Not Taken**: indica se il salto è stato eseguito (Taken) o meno (Not Taken) (solo per le istruzioni di branch).
        - **Predittore (1 o 2 bit)**: stato e previsione del predittore (solo per le istruzioni di branch).
        - **Hit/Miss**: risultato della previsione del predittore (solo per le istruzioni di branch).

2. **Predittore a 2 bit**

    - Stati: **T2** $\leftrightarrow$ **T1** $\leftrightarrow$ **N1** $\leftrightarrow$ **N2**
    - Tre errori consecutivi sono necessari per passare da *strongly taken* (T2) a *strongly not taken* (N2).
    - Lo stato viene aggiornato **dopo** la valutazione del branch.

3. **Conteggio hit/miss**

    - Contare separatamente il numero di predizioni corrette (hit) e sbagliate (miss).
    - Usare questi valori per calcolare **misprediction rate** e, in base ai cicli per tipo di istruzione, il **CPI medio**.
