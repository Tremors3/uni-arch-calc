
## `Differenza architetturale tra CISC (Complex) e RISC (Reduced Instruction Set Computer)`

La differenza principale sta nel:

1. Le CPU CISC possono effettuare operazioni **direttamente con la memoria centrale (data memory)**;

    ```
    +-----+
    | CPU |----------------+
    +-----+                |
       |                   |
       |                   |
       v                   v
    +-----+         +------------+
    | ReF |         | MEM (DRAM) |
    +-----+         +------------+
    ```

2. Le CPU RISC invece possono effettuare operazioni **solamente con il register file**.

    Per questo motivo le CPU RISC possiedono un **modulo Load/Store** che consente il **caricamento nel register file** dei dati presenti nella **memoria centrale (DRAM)**.

    ```
    +-----+    +-----+
    | CPU |    | L/S |
    +-----+    +-----+
       |          |
       |          |
       v          |
    +-----+       |       +------------+
    | ReF |<------+------>| MEM (DRAM) |
    +-----+               +------------+
    ```

---

## `Percorso Critico e Frequenza di Clock nel Datapath Risc-V`

Nel corso dell'apprendimento delle reti logiche, le abbiamo sempre considerate **istantanee**: fornendo degli input, si ottenevano immediatamente gli output. In realtà, i circuiti fisici non sono istantanei, poiché **il segnale elettrico impiega un tempo finito per propagarsi**. Questo introduce **ritardi di propagazione** che devono essere gestiti con attenzione nel progetto di una CPU.

### Datapath

Nel **Datapath non pipelined**, un'istruzione deve attraversare l'**intero circuito** (dalla fase di *Fetch* fino al *WriteBack*) **in un solo ciclo di clock**. Per evitare errori causati dai ritardi, il **periodo del clock** (cioè la sua durata) deve essere sufficientemente lungo da coprire **tutto il tempo di propagazione massimo** necessario. Di conseguenza, la **frequenza di clock** dev'essere **bassa**. Questo, però, rallenta l'intera CPU.

Il **percorso critico** rappresenta proprio questo: è il cammino più lungo, in termini di tempo, che un segnale deve percorrere **tra due registri consecutivi**. È il percorso più lento all'interno del circuito, ed è proprio lui che **limita la massima frequenza di clock possibile**.

Infatti:
- Se il **percorso critico** è lungo $\rightarrow$ il **ciclo di clock** dev'essere lungo $\rightarrow$ la **frequenza** sarà bassa.
- Se accorciamo il percorso critico $\rightarrow$ possiamo **aumentare la frequenza di clock**.

Ma come si accorcia il percorso critico se il datapath è complesso?

### Pipelined Datapath

La risposta è: **spezzando il datapath** in più segmenti, e **inserendo dei registri tra una fase e l'altra**.

In particolare, suddividiamo l'esecuzione di un'istruzione nelle sue **5 fasi**:

1. *Fetch*
2. *Decode*
3. *Execute*
4. *Memory*
5. *WriteBack*

A ciascuna di queste fasi inseriamo un **registro intermedio**, in modo che il segnale non debba più attraversare l'intero datapath in un unico ciclo.

Ora, il **percorso critico è il più lungo tra i tratti che separano due registri adiacenti** (es. tra Decode e Execute, oppure Execute e Memory). Di conseguenza, possiamo **accorciare il ciclo di clock** e quindi **aumentare la frequenza** rispetto alla versione non pipelined.

### Importante da ricordare

- Il **pipelining non riduce il tempo totale di esecuzione di una singola istruzione**. Ogni istruzione impiega comunque 5 cicli (uno per ciascuna fase).

- Tuttavia, consente di **eseguire più istruzioni contemporaneamente**, ciascuna in una fase diversa. È qui che nasce il **guadagno prestazionale**.

Ad esempio, dopo un primo periodo di "riempimento" della pipeline, possiamo avere **fino a 5 istruzioni in esecuzione simultanea**: una nella fase di **Fetch**, una in **Decode**, una in **Execute**, una in **Memory** e una in **WriteBack**. Questo consente di **completare un'istruzione per ogni ciclo di clock**, sfruttando al massimo la frequenza più alta.

### Note

- Il **percorso critico** è il tratto più lento (in termini di ritardo) tra due registri.
- La sua durata determina il **tempo minimo di un ciclo di clock** $\rightarrow$ quindi la **frequenza massima** della CPU.
- Il **datapath non pipelined** ha un percorso critico lungo $\rightarrow$ frequenza bassa.
- Il **pipelining** spezza il datapath in fasi e riduce il percorso critico $\rightarrow$ frequenza più alta.
- Il pipelining **non velocizza una singola istruzione**, ma **aumenta il throughput** della CPU (più istruzioni completate in meno tempo).

---

## `Structural Hazard`

Nel **datapath pipelined**, più istruzioni sono in esecuzione contemporaneamente, ciascuna in una fase diversa. Tuttavia, possono verificarsi conflitti quando **due fasi diverse richiedono lo stesso componente hardware nello stesso ciclo di clock**. Questo tipo di conflitto prende il nome di **hazard strutturale**.

### Conflitto tra Instruction Memory e Data Memory

Le istruzioni di tipo **Load**/**Store** accedono alla **Data Memory** durante la loro fase **MEM**.
Allo stesso tempo, la CPU deve **prelevare (fetch)** la prossima istruzione dalla **Instruction Memory**.

In un'architettura di **Von Neumann**, **instruction memory e data memory coincidono** (sono unificate). Questo significa che **non è possibile accedere contemporaneamente alla memoria per leggere un'istruzione e per leggere/scrivere un dato**.

Ne consegue un **hazard strutturale**: il **fetch** della prossima istruzione deve **aspettare** che la fase **MEM** dell'istruzione corrente sia completata.

#### Schema concettuale (Von Neumann)
```
                    (IM) Fetch
+-----+    +-----+ /           
| CPU |    | MEM |              
+-----+    +-----+ \           
   |          |     (DM) Load/Store
   +----------+
   1 unico bus
```

### Architettura Harvard

**Nell'architettura Harvard**, la **Instruction Memory (IM)** e la **Data Memory (DM)** sono **fisicamente separate**, permettendo alla CPU di accedere contemporaneamente a entrambe.
Questa separazione consente il **pipelining efficiente**, eliminando il conflitto strutturale tra le fasi **IF** e **MEM**.

#### Schema concettuale (Harvard):
```
Fetch              Load/Store
+----+    +-----+    +----+
| IM |    | CPU |    | DM |
+----+    +-----+    +----+
  |         | |         |
  +---------+ +---------+
       2 bus separati
```

### Architettura mista (Von Neumann + Harvard)

Nella pratica, molte CPU moderne adottano una **gerarchia di memoria ibrida**:

- La **cache più vicina alla CPU** (`L1`, `L2`) è spesso organizzata secondo il modello **Harvard** (cache separata per istruzioni e dati), per **massimizzare il parallelismo** e ridurre i conflitti.

- I **livelli di memoria più lontani** (`L2`, `L3`, `RAM`) seguono una struttura più simile a **Von Neumann**, condividendo lo spazio per istruzioni e dati.

- A seconda delle scelte architetturali, la cache di **secondo livello** (`L2`) può essere progettata come **separata** per istruzioni e dati, **oppure unificata**.

- È importante notare che il problema dello **Structural Hazard** non si limita solo alla memoria principale o alla cache L1: **può verificarsi a qualsiasi livello della gerarchia di memoria**, ogni volta che più unità della CPU tentano di accedere contemporaneamente a una risorsa condivisa.

Questa **soluzione ibrida** rappresenta un compromesso efficace tra i due modelli, combinando i vantaggi dell'**alta efficienza nell'esecuzione pipelined** (tipica dell'architettura Harvard) con altre esigenze progettuali, come la **condivisione della memoria** e una **gestione più flessibile delle risorse**, caratteristiche dell'architettura di Von Neumann.

---

## `Data Hazard`

### Contare i cicli di esecuzione in un programma RISC-V pipelined

Per calcolare con precisione il **numero di cicli di clock necessari all'esecuzione di un programma** su una CPU RISC-V con datapath pipelined, bisogna considerare diversi fattori:

1. **Riempimento iniziale della pipeline**

    - All'avvio dell'esecuzione, la **pipeline è vuota**. 
    
    - La prima istruzione attraverserà **tutte le 5 fasi** (Fetch, Decode, Execute, Memory, WriteBack), quindi richiederà **5 cicli** per essere completata.
    
    - Tuttavia, a partire dalla seconda istruzione, il **pipelining entra a regime**: ogni nuova istruzione inizia ad essere eseguita a ogni nuovo ciclo, sfruttando il parallelismo tra le fasi.
    
    Quindi:
    - **Prima istruzione**: `5 cicli`
    - **Istruzioni successive**: `1 ciclo ciascuna` (in assenza di stall o hazard)
    - **Cicli totali ideali**: $\textbf{\# Istruzioni} + 4$

2. **Forwarding (bypass) dei dati**

    La CPU RISC-V utilizza **forwarding (o bypass)** per **ridurre i Data Hazard** tra istruzioni consecutive. Questo meccanismo consente di **passare i risultati di un'istruzione direttamente alla successiva**, senza attendere che siano scritti nel registro.

    - Grazie al forwarding, **in molti casi non è necessario inserire istruzioni fittizie** (nop) nella pipeline, e quindi il flusso non subisce interruzioni.

3. **Data Hazard residui e gestione**

    Nonostante il forwarding, alcuni **Data Hazard** possono comunque causare **stall (ritardi)**, specialmente nei seguenti casi:

    - 🔁 **RAW (Read After Write) Hazard** (2nop/noNop): un'istruzione legge un registro subito dopo che un'altra istruzione lo ha scritto.

        ```asm
        add x19, x0, x1    ; scrive valore in x19
        sub x2, x19, x3    ; usa x19 subito dopo
        ```

        Con il forwarding, **non sarà necessario** inserire alcuno `stall` (nop), perchè il dato è già disponibile per essere utilizzato nella fase `EX` della seconda istruzione. Senza logica di forwarding sarebbe necessario inserire due istruzioni di `stall` (nop).

    - 📥 **Load-Use Hazard** (2nop/1nop): un caso particolare del RAW, in cui una istruzione di tipo load carica un valore in un registro, e l'istruzione successiva tenta di leggerlo.

        ```asm
        lw  x5, 0(x1)     ; carica valore in x5
        add x6, x5, x2    ; usa x5 subito dopo
        ```

        In questo caso, anche se è presente la logica di **forwarding**, il dato caricato da `lw` **non è ancora disponibile nella fase** `EX` dell'istruzione `add`, perché il valore dalla memoria viene ottenuto solo nella fase `MEM`.

        **Con forwarding**, questa dipendenza **non può essere risolta completamente**, e si rende necessario **inserire uno `stall`** (tipicamente una `nop`) per permettere il completamento della `lw` prima che l'`add` esegua. Senza logica di forwarding sarebbe necessario inserire due istruzioni di `stall` (nop) anzichè una.

        Per evitare lo **stall** (che riduce il throughput della CPU), è possibile **riordinare le istruzioni** inserendo **tra la `lw` e l'istruzione dipendente** un'altra istruzione **indipendente**, cioè che **non utilizzi il valore appena caricato**.

        Esempio migliorato:
        ```
        lw   x5, 0(x1)      ; carica valore in x5
        sub  x7, x3, x4     ; istruzione indipendente
        add  x6, x5, x2     ; ora il dato in x5 è pronto
        ```

        - In questo modo, la pipeline **non subisce stall** e si mantiene un **alto livello di parallelismo**, migliorando le prestazioni.

---

## `Control Hazard`

### Cos'è un Control Hazard?

Un **control hazard** si verifica quando **l'istruzione corrente** è un **branch** (salto condizionato), e la CPU **non sa ancora** se dovrà **saltare a un nuovo indirizzo** o **continuare con la prossima istruzione sequenziale**.

Nel pipelining:

- Il **fetch** della prossima istruzione avviene **prima** di sapere se il branch sarà preso o meno.
- Il **risultato del branch** viene determinato **solo nella fase `ID`** (Instruction Decode), o in alcune architetture più avanti.
- Di conseguenza, la **CPU rischia di prelevare l'istruzione sbagliata**, causando un **hazard di controllo**.

### Stall on Branch (semplice ma inefficiente)

Un approccio base è quello di **bloccare la pipeline**: si **inserisce uno `stall`** (si aspetta) fino a quando il risultato del branch è noto.

- Questo **garantisce correttezza**, ma:
- Introduce un **ritardo (penalità)** ogni volta che si incontra un branch.
- È poco efficiente nelle pipeline lunghe.

### Branch Prediction (Predizione del Branch)

Nelle **pipeline più profonde**, attendere che il branch venga risolto (anche solo di pochi cicli) può causare **penalità pesanti** in termini di performance.

La soluzione è predire l'esito del branch:
- Se la **predizione è corretta**, la pipeline prosegue senza interruzioni.
- Se è **sbagliata**, si **scartano le istruzioni errate** e si **ricomincia dal corretto indirizzo** (introducendo comunque un ritardo).

### Branch Prediction nel RISC-V Pipelined

Nel RISC-V a 5 fasi, il branch viene **risolto nella fase `ID`**. Per ridurre il ritardo:

- Si può **aggiungere hardware** per **confrontare i registri e calcolare l'indirizzo di salto già in `ID`**, il prima possibile.
- Si può anche adottare una **strategia di predizione**, ad esempio:

#### Predizione Semplice: Predict Not Taken

- Si **suppone che il branch non sarà preso**.
- La CPU esegue direttamente l'istruzione successiva nel flusso.
- Se la previsione è **giusta**, tutto ok.
- Se è **sbagliata** (il salto andava fatto), la CPU **scarta le istruzioni** già prelevate e introduce uno **stall** per correggere il flusso.

### Branch Prediction Realistica: Static vs Dynamic

1. **Static Branch Prediction**

    - **Fissa e predefinita**, basata su osservazioni generali:

        - I **salti all'indietro** (tipici nei cicli) → **di solito presi**
        - I **salti in avanti** (es. if) → **di solito non presi**

    - Non richiede molta logica, ma **non si adatta ai casi specifici**.

2. **Dynamic Branch Prediction**

    - Implementata in **hardware**.
    - Tiene **traccia della cronologia** del comportamento di ciascun branch (es. con un buffer di predizione).
    - Se un branch è stato preso molte volte di seguito, si suppone che **sarà preso anche la prossima volta**.
    - Se la predizione è sbagliata:
    - La pipeline **scarta** le istruzioni errate.
      - La **cronologia viene aggiornata** con il nuovo comportamento.
      - Questo metodo **è molto più preciso** nelle applicazioni reali e utilizzato nei processori moderni.

All'inizio dell'esecuzione di un programma, il **Dynamic Branch Predictor** non dispone ancora di una **history**: non ha informazioni pregresse sul comportamento dei branch, quindi parte "alla cieca".

Per migliorare l'accuratezza delle predizioni iniziali, è possibile **integrare informazioni statiche ottenute in fase di compilazione** (*compile-time*).

In questo approccio ibrido, il **predittore dinamico utilizza inizialmente i dati statici** (basati su analisi del flusso del programma, come direzione del salto o profili di esecuzione), e poi **aggiorna dinamicamente la sua history durante l'esecuzione**, adattandosi al comportamento effettivo del programma.

### Riepilogo Finale

| **Concetto**           | **Descrizione**                                                    |
|------------------------|--------------------------------------------------------------------|
| **Control Hazard**     | Rischio di prelevare l'istruzione sbagliata dopo un branch.        |
| **Stall on Branch**    | Si aspetta di conoscere il risultato del branch → rallenta la CPU. |
| **Branch Prediction**  | Si prova a prevedere l'esito del branch per evitare lo stall.      |
| **Predict Not Taken**  | Strategia semplice: si suppone che il branch non venga preso.      |
| **Static Prediction**  | Predizione basata su regole fisse (es. backward → taken).          |
| **Dynamic Prediction** | Predizione adattiva basata su cronologia reale dei branch.         |

---

## `Dynamic Branch Prediction`

Nelle pipeline **profonde** o **superscalari**, il costo di una branch sbagliata diventa significativo. Per ridurre il numero di stall e migliorare le prestazioni, si usa la **predizione dinamica**.

### Branch History Table (BHT)

È una **tabella di predizione** (chiamata anche Branch Prediction Buffer) che:

- È **indicizzata dall'indirizzo** delle istruzioni branch recenti.
- **Memorizza l'esito** della branch (presa o non presa).
- Quando una branch viene eseguita:
    - Si consulta la tabella per prevederne l'esito.
    - Si inizia il fetch dalla destinazione (se predetta “presa”) o dall'istruzione successiva (se “non presa”).
    - Se la predizione era **errata**, si effettua un **flush** della pipeline e si aggiorna la predizione.

### 1-Bit Predictor

Con un **predittore a 1 bit**, si cambia previsione al primo errore. Questo è insufficiente, ad esempio, nei cicli annidati:

```
outer: ...
       ...
inner: ...
       ...
       beq ..., ..., inner  ; loop interno
       ...
       beq ..., ..., outer  ; loop esterno
```

- Nell'ultima iterazione di `inner`, predice **presa** → errore.
- Nella prima iterazione successiva, predice **non presa** → altro errore.

Quindi il predittore 1-bit sbaglia due volte ogni ciclo.

### 2-Bit Predictor

Un **predittore a 2 bit** cambia stato solo dopo **due errori consecutivi**, evitando le doppie mispredizioni nei loop.

### Branch Target Buffer (BTB)

Anche se la predizione è corretta, bisogna comunque **calcolare l'indirizzo di destinazione** della branch. Per velocizzare:

- Si usa il **BTB** (*Branch Target Buffer*), una cache che memorizza gli indirizzi target delle branch.
- Viene **indicizzato dal Program Counter (PC)** al momento del fetch.
- Se la branch è **predetta *taken* e il BTB ha un hit**, si può iniziare a fare fetch **immediatamente** dall'indirizzo target, riducendo la penalità a **1 ciclo**.

---

## `Exceptions and Interrupts`

Gli **eventi inattesi** che alterano il normale flusso di esecuzione sono gestiti attraverso due meccanismi simili ma distinti:

#### Exception

- **Origina all'interno della CPU**.
- Causata da **errori** o **eventi** particolari: ad esempio *istruzioni non definite*, *divisione per zero*, *syscall*.
- Deve essere gestita dal sistema operativo per evitare comportamenti errati.

#### Interrupt

- **Proviene da periferiche esterne**, come timer o controller I/O.
- Serve per notificare la CPU che un evento esterno richiede attenzione.
- La gestione di queste situazioni deve essere progettata **senza compromettere le prestazioni** della pipeline.

### Gestione delle Exception (RISC-V)

Quando si verifica un'eccezione, la CPU:

1. **Salva il Program Counter (PC)** dell'istruzione che ha causato l'eccezione.
    - In RISC-V: nel registro **SEPC** (*Supervisor Exception PC*).

2. **Registra il motivo dell'eccezione**.
    - In RISC-V: nel registro **SCAUSE** (*Supervisor Cause*).
    - Contiene un **codice di eccezione**:
        -  `2` → opcode non definito
        - `12` → errore hardware
        - ... (altri codici possibili)

3. **Salta al gestore dell'eccezione (handler)**.
    - Indirizzo hardcoded: `0x000000001C090000`
    - Oppure, per maggior flessibilità, si usa il **vectored interrupt**.

### Vectored Interrupts (alternativa)

- Il salto al gestore avviene **in base alla causa** dell'eccezione o dell'interrupt.

- Il gestore si trova a un indirizzo calcolato sommando:
    - L'indirizzo base della tabella dei vettori
    - Un **offset specifico per la causa** (es. opcode non definito → `0b0001000000`)

- Il gestore può:
    - Gestire direttamente l'interrupt
    - Oppure **saltare a un gestore più specifico**

### Azioni del Gestore

Il gestore dell'interrupt/exception:

1. **Legge SEPC e SCAUSE** per capire la causa.

2. **Decide l'azione corretta**:

    - Se l'istruzione è **restartable**:
        - Corregge la condizione
        - Ritorna all'istruzione originale usando SEPC

    - Se **non restartable**:
        - Termina il programma
        - Registra un errore o lo segnala

| **Tipo di Istruzione** | **Definizione** | **Comportamento** |
|--------------------|-------------|---------------|
| **Restartable**        | Un'istruzione che, in caso di eccezione, può essere **rieseguita da capo** senza effetti collaterali indesiderati. | Il sistema salva il PC nell'apposito registro (`SEPC`) e, dopo la gestione, riesegue l'istruzione. |
| **Non-Restartable**    | Un'istruzione che **non può essere ripetuta** in sicurezza perché potrebbe causare comportamenti errati (es. effetti collaterali già avvenuti). | Il gestore deve **evitare la riesecuzione**: può saltare, terminare il programma, o eseguire azioni correttive personalizzate. |

### Exception e Pipeline

**Un'eccezione è un hazard di controllo**, simile a un branch predetto male. Esempio:

```
add x1, x2, x1    ; errore in fase EX
```

1. Evita che `x1` venga sovrascritto.

2. Termina le istruzioni precedenti.

3. **Svuota (flush)** l'istruzione errata e quelle successive.

4. Imposta **SEPC** e **SCAUSE**.

5. Salta al gestore.

> Le eccezioni **usano lo stesso hardware** del branch prediction per il controllo del flusso.

### Restartable Exceptions

- Alcune eccezioni permettono di **riavviare l'istruzione interrotta**:

    - La pipeline fa flush dell'istruzione.
    - Il gestore la riesegue **da zero**, partendo dall'indirizzo in SEPC.

- Questo è possibile solo se l'istruzione non ha causato effetti collaterali parziali prima dell'eccezione.

### Tabella Termini

| **Componente**                | **Descrizione** |
|-------------------------------|-----------------|
| **SEPC**                      | (*Supervisor Exception Program Counter*) – Registra il PC dell'istruzione che ha causato l'eccezione o è stata interrotta. Serve per poterla rieseguire o riportare il controllo al programma. |
| **SCAUSE**                    | (*Supervisor Cause Register*) – Indica il tipo di eccezione/interrupt (es. opcode non valido, accesso illecito, ecc.). Codificato come un numero. |
| **Handler**                   | Routine software (parte del sistema operativo) che gestisce l'eccezione o l'interrupt. |
| **Interrupt Vector Table**    | Tabella di indirizzi (base + offset) a cui saltare in caso di interrupt/exception. Usata nel meccanismo vectored. |
| **Trap Entry Point**          | Indirizzo base in memoria da cui iniziano i gestori delle eccezioni/interruzioni. In modalità semplice è fisso, in modalità vectored è configurabile. |
| **Pipeline Flush Unit**       | Componente hardware che annulla le istruzioni errate nella pipeline (come per i branch mal predetti). |
| **Privilege Level**           | Modalità di esecuzione della CPU (es. Supervisor, User). Le eccezioni generalmente elevano il privilegio al livello del sistema operativo. |
| **MEPC / UEPC**               | Come SEPC, ma per eccezioni in modalità Machine o User. RISC-V definisce livelli diversi con registri separati. |
| **MCAUSE / UCAUSE**           | Come SCAUSE, ma per altri livelli di privilegio (Machine/User). |
| **Ecall**                     | Istruzione per generare un'eccezione volontaria dal programma (es. per invocare servizi del sistema operativo). |
| **MRET / SRET / URET**        | Istruzioni per ritornare da un'eccezione (Machine/Supervisor/User). Riprendono l'esecuzione dal PC salvato. |

---

## `Exceptions Continue`

### Multiple Exceptions in Pipeline

Nelle architetture pipelined, più istruzioni sono in esecuzione contemporaneamente in fasi diverse. Di conseguenza, **potrebbero verificarsi eccezioni simultanee**.

#### Soluzione semplice:

- Gestire **solo l'eccezione della prima istruzione** (quella più "vecchia" nella pipeline).
→ Le istruzioni successive vengono **flushate**.

- Questa modalità garantisce eccezioni **precise**.

### Precise Exceptions

Un'**eccezione è precisa** se:
- Tutte le istruzioni **prima** dell'eccezione sono completamente eseguite.
- Nessuna istruzione **dopo** l'eccezione ha avuto effetto sullo stato del sistema.
- Il **Program Counter salvato** (`SEPC`) punta esattamente all'istruzione che ha causato l'eccezione.

Questa è la modalità usata in architetture come RISC-V: permette una gestione **chiara**, **ripetibile** e **sicura** delle eccezioni.

### Imprecise Exceptions

Quando l'eccezione **non è localizzabile** con precisione o **l'ordine di completamento delle istruzioni è alterato**, si parla di *eccezione imprecisa*.

→ Tipica in **pipeline complesse**, con:
- **Issuing multiplo** (più istruzioni per ciclo)
- **Completamento fuori ordine**

#### In questo caso:

- La pipeline viene **interrotta**.

- Lo stato della CPU e l'elenco delle eccezioni vengono **salvati**.

- Il **gestore software** dovrà analizzare quali istruzioni:

    - Sono completate
    - Sono parziali
    - Devono essere flushate o rieseguite

**Svantaggi**: hardware più semplice, ma **software di gestione molto più complesso**.

**Nota**: per pipeline superscalari *out-of-order*, le eccezioni **imprecise non sono gestibili in modo affidabile**.

---

## Piplined Datapath Considerations

### ⚠️ **Fallacies (False credenze)**

- “*La pipelining è semplice*”: l’idea base è semplice, ma la **gestione di dettagli complessi** (hazard, eccezioni, branch) è tutt’altro che banale.

- “*La pipelining è indipendente dalla tecnologia*”: in realtà, la **complessità e fattibilità** della pipeline dipendono fortemente dai **progressi tecnologici** (es. numero di transistor disponibili).

### ⚠️ **Pitfalls (Trappole progettuali)**

- Un'**ISA mal progettata** rende difficile implementare una pipeline efficiente.

    - Esempi: istruzioni troppo complesse (come in **VAX**, **IA-32**), modalità di indirizzamento complicate, effetti collaterali non immediati.

- Le architetture come IA-32 hanno dovuto adottare **micro-operazioni** per semplificare il pipelining.

- Le **istruzioni condizionali ritardate** e gli **slot di ritardo** (delay slots) nelle architetture avanzate possono creare **problemi di compatibilità e prestazioni**.

---

