
## Note sulla DRAM

Due trasferimenti per ciclo di clock (perché DDR = Double Data Rate).

#### Burst Mode

Il concetto di **Burst Mode** nella DRAM nasce dall'osservazione che il costo di accesso non dipende solo dal trasferimento dei dati, ma soprattutto dal tempo necessario per “aprire” una riga di memoria. La DRAM è organizzata come una matrice di righe e colonne, e per leggere una parola (word) bisogna prima attivare l'intera riga corrispondente. Questo passaggio comporta un tempo di latenza significativo, detto row access time o tRCD (Row to Column Delay). Se si effettuano accessi casuali e sparsi, ogni volta occorre aprire una riga diversa, pagando continuamente questo costo iniziale.

Il **Burst Mode** è una strategia per sfruttare al massimo l'apertura di una riga: una volta che la riga è stata caricata nei buffer interni della DRAM, si possono leggere in sequenza più parole consecutive (burst di dati) senza dover riaprire altre righe. In questo modo il costo di apertura si ammortizza su più dati. Per esempio, se una riga contiene 8 parole e ne leggo tutte in sequenza, il tempo di accesso complessivo per ciascuna parola è molto inferiore rispetto a fare 8 letture sparse in righe diverse.

Questa logica è strettamente legata al funzionamento delle cache. Le cache non memorizzano una singola parola alla volta, ma intere **linee di cache** (cache lines), tipicamente di 32 o 64 byte. Quando il processore chiede un dato che non è in cache, la memoria principale invia un blocco di dati consecutivi sfruttando proprio il burst mode della DRAM. Così si minimizza l'impatto della latenza iniziale e si aumenta la probabilità che, nei prossimi accessi, il dato richiesto sia già in cache senza dover tornare in DRAM.

#### Row Buffer Locality

La **row buffer locality** è il principio secondo cui, quando si accede più volte a dati che si trovano nella stessa riga di DRAM già aperta, non serve riattivarla. Questo significa che se il processore o il controller di memoria riescono a pianificare gli accessi in modo da sfruttare la riga già caricata nel *row buffer* interno del chip DRAM, si evita il costo di apertura e si ottiene un accesso molto più veloce. In pratica, è un po' come quando lasci un cassetto aperto perché sai che devi prendere più cose da lì: eviti di aprirlo e chiuderlo ogni volta. Quando invece si cambia riga, il controller deve prima chiudere quella attuale (*precharge*) e poi aprire la nuova, pagando la latenza aggiuntiva. Molti algoritmi di scheduling della DRAM cercano quindi di riordinare le richieste per massimizzare la *row buffer locality*.

```
DRAM Bank

  +---+---+---+---+---+
  |   |   |   |   |   | DRAM Row Buffer
  +---+---+---+---+---+
    ^   ^   ^   ^   ^
    |   |   |   |   |
O---|---|---|---|---|-- DRAM Row
    |   |   |   |   |
O---|---|---|---|---|--
    |   |   |   |   |
O---|---|---|---|---|--
    |   |   |   |   |
O---|---|---|---|---|--
    |   |   |   |   |
O---|---|---|---|---|--
    |   |   |   |   |
```

- Quando viene richiesta la lettura di un dato, se esso si trova nella riga caricata nel Row Buffer, allora sono fortunato e lo ottengo con maggiore facilità. Altrimenti dovrò aprire una nuova riga.

#### Prefetch

Il **prefetch** è una tecnica che si affianca al burst mode per aumentare il throughput. Poiché i chip DRAM moderni sono molto più lenti rispetto alla frequenza con cui la CPU può consumare i dati, il chip DRAM, una volta aperta la riga, legge internamente più parole in parallelo e le mette in coda per essere inviate in sequenza. Questo avviene anche quando la CPU ha richiesto solo una parte di quelle parole. In sostanza, il prefetch anticipa il lavoro del processore, cercando di avere già pronti i dati che probabilmente verranno richiesti subito dopo. Nei moduli DDR (Double Data Rate), il prefetch interno è uno dei motivi per cui si ottengono trasferimenti così ampi per singola attivazione di riga.

#### Considerazione Burst Mode, Row Buffer Locality e Prefetch

Insieme, queste tecniche creano un flusso ottimizzato: il **burst mode** sfrutta l'apertura della riga per trasferire più parole consecutive, la **row buffer locality** riduce il numero di aperture necessarie, e il **prefetch** fa sì che i dati siano pronti e disponibili con il minimo tempo morto. Questo è anche il motivo per cui i sistemi informatici, sia lato hardware che lato software, cercano di accedere alla memoria in modo sequenziale piuttosto che casuale: è una questione di sfruttare al massimo la struttura interna della DRAM.

#### DRAM banking

Il **DRAM banking** è una tecnica di organizzazione interna della memoria principale pensata per aumentare il parallelismo e ridurre l'impatto della latenza di accesso. L'idea di base è che la DRAM non sia un blocco monolitico, ma sia suddivisa in più **banchi** (banks), ognuno indipendente dagli altri. Ogni banco ha la propria matrice di celle di memoria e il proprio **row buffer**, quindi può aprire una riga e servirla senza dover aspettare che un altro banco finisca la sua operazione.

Se due richieste arrivano per dati che si trovano in banchi diversi, può soddisfarle in parallelo, sovrapponendo i tempi di apertura di una riga in un banco con il trasferimento dati da un altro banco. In questo modo il throughput complessivo aumenta perché si sfruttano più canali di accesso interni alla DRAM.

Al contrario, se tutte le richieste puntano allo stesso banco, le operazioni si accodano: ogni cambio di riga richiede prima la chiusura (precharge) e poi l'apertura (activate) della nuova, causando tempi morti. Qui entra in gioco anche la **row buffer locality**: se più richieste puntano alla stessa riga nello stesso banco, basta aprirla una sola volta e le letture successive sono immediate. Se invece puntano a righe diverse nello stesso banco, si perde tempo in operazioni di precharge/activate.

```
DRAM subdivided in Banks

    I/O Devices ------+       +------ CPU
                      |       |
                      v       v
        64 bits access points
+----XXX-----XXX-----XXX-----XXX----+
|     |       |       |       |     |
|   +-+-+   +-+-+   +-+-+   +-+-+ <--- Row Buff(s)
|   | | |   | | |   | | |   | | |   |
|   +-+-+   +-+-+   +-+-+   +-+-+   |
|     |       |       |       |     |
|   +-+-+   +-+-+   +-+-+   +-+-+ <--- Bank
|   | | |   | | |   | | |   | | |   |
|   +-+-+   +-+-+   +-+-+   +-+-+   |
|   | | |   | | |   | | |   | | |   |
|   +-+-+   +-+-+   +-+-+   +-+-+   |
|   | | |   | | |   | | |   | | |   |
|   +-+-+   +-+-+   +-+-+   +-+-+   |
|   | | |   | | |   | | |   | | |   |
|   +-+-+   +-+-+   +-+-+   +-+-+   |
+-----------------------------------+
```

- Se in un dato momento più attori richiedono di leggere dati contenuti nella DRAM, se i dati si trovano su banchi diversi, come mostrato in figura, allora le letture possono avvenire nello stesso ciclo, in parallelo; altrimenti, se i dati si trovano nello stesso banco, dovrò effettuare più aperture di righe in diversi cicli, sempre che i dati non si trovino all'interno della stessa riga e quindi salvati all'interno del row buffer di quel banco. In quest'ultimo caso avviene solo una prima apertura della riga mentre le successive letture avverranno direttamente sul Row Buffer.

- Il DRAM banking è una forma di **parallelismo a livello di memoria** che **non si vede direttamente dall'esterno**, ma che è fondamentale per garantire che la memoria riesca a tenere il passo con la velocità del processore e delle periferiche moderne.

#### DRAM Bandwith definition

La **bandwidth** della DRAM è la quantità di dati che può essere trasferita dalla memoria principale al processore (o viceversa) nell'unità di tempo. Si misura in **byte al secondo** (o in GB/s nelle memorie moderne) e dipende sia dalle caratteristiche fisiche della DRAM sia dall'architettura del sistema.

$$ \text{Bandwidth} = \text{Frequenza di trasferimento} \times \text{Ampiezza dei Bus} \times \text{Trasferimenti per ciclo} $$

In altre parole, la bandwidth rappresenta la **capacità di flusso massimo** che la DRAM può fornire, ma la vera prestazione dipende dall'efficienza con cui il controller di memoria e il software riescono a sfruttare questa capacità.

---

## Tipologie di Memorie Cache

#### Directly Mapped Cache

Nella **Directly Mapped Cache**, ogni indirizzo di memoria principale può essere mappato in **una sola posizione specifica** della cache. Questo avviene tramite una funzione di mappatura molto semplice, di solito usando alcuni bit dell'indirizzo per determinare l'*indice* della linea di cache.

- Il vantaggio è che l'hardware è minimale: basta un solo comparatore per verificare se la linea contiene il blocco richiesto (controllo del *tag*).

- Lo svantaggio è che se due indirizzi diversi mappano sulla stessa linea, si creano **conflitti di mapping**: ogni volta che si accede a uno si rimpiazza l'altro, causando *cache thrashing* e riducendo l'efficienza, soprattutto con accessi poco locali o in scenari con frequenti cambi di contesto.

#### Fully Associative Cache

La **Fully Associative Cache**, invece, non impone nessun vincolo su dove un blocco può essere collocato: un dato può essere messo in **qualsiasi linea della cache**. Questo elimina completamente i conflitti di mapping, a vantaggio dell'efficienza d'uso delle celle.

- Il problema è che per sapere se il dato è in cache bisogna confrontare il *tag* del blocco richiesto con il *tag* di **ogni linea della cache**: questo richiede un **comparatore per ogni linea** e un sistema di ricerca più complesso, aumentando il costo e la complessità hardware.

#### Set-Associative Cache

La **Set-Associative Cache** è la via di mezzo tra la semplicità della **Directly Mapped** e la flessibilità della **Fully Associative**.

L'idea è suddividere la cache in più **insiemi** (***sets***), ognuno contenente un piccolo numero di linee (tipicamente 2, 4, 8). Un blocco di memoria principale viene mappato in **un solo insieme specifico**, determinato da alcuni bit dell'indirizzo, ma **all'interno di quell'insieme può essere collocato in qualsiasi linea disponibile**.

- Questo approccio **riduce i conflitti tipici della Directly Mapped**, perché se due blocchi finiscono nello stesso insieme non devono per forza sostituirsi a vicenda: ci sono più linee disponibili per contenerli.
- Allo stesso tempo, **l'hardware è meno costoso rispetto a una Fully Associative**, perché la ricerca del blocco avviene solo tra le linee di un singolo insieme, non su tutta la cache.

Per esempio:

- In una **2-way set associative cache**, ogni insieme ha 2 linee: se due blocchi finiscono nello stesso insieme, possono convivere finché non serve spazio per un terzo blocco nello stesso insieme.

- In una **4-way set associative cache**, ogni insieme ha 4 linee, riducendo ulteriormente i conflitti.

La scelta del numero di vie (*ways*) è un compromesso: più vie riducono i conflitti e aumentano il tasso di hit, ma richiedono più comparatori e più complessità nei meccanismi di sostituzione (come LRU o Random).

La set-associative è oggi lo schema più comune nelle CPU moderne, perché offre un buon equilibrio tra **prestazioni** ed **efficienza hardware**, riducendo le penalizzazioni da *cache thrashing* senza raggiungere i costi elevati di una Fully Associative.

---

## Cache e Indirizzi

### Cosa contiene l'Indirizzo di memoria

Quando la CPU emette un indirizzo (64 bit nell'esempio), la cache lo scompone in:

- **OFFSET**: quanti byte dentro la **linea di cache** (o *block*). Se la linea è di $\mathbf{M}$ byte, servono $\mathbf{\log_2 M}$ bit. L'OFFSET permette di estrarre il byte/parola esatta all'interno della linea.

- **INDEX** (o **SET INDEX**): seleziona **quale insieme/linea** consultare.

    - **Direct-mapped**: l'INDEX sceglie l'unica linea possibile. Se ci sono $\mathbf{N}$ linee totali, servono $\mathbb{\log_2 N}$ bit.

    - **Set-associative**: l'INDEX seleziona **l'insieme**; dentro l'insieme ci sono più linee (le *ways*). Se ci sono $\mathbf{S}$ insiemi, servono $\mathbf{\log_2 S}$ bit.

    - **Fully-associative**: **non c'è INDEX** perché qualunque blocco può stare in qualunque linea; tutti i confronti si fanno sul TAG.

- **TAG**: i bit rimanenti. Identifica **quale blocco di memoria** tra i molti che potrebbero trovarsi in quella linea/insieme è effettivamente presente.

In formula, per una cache set-associativa:

$$ \text{TAG bits} = \text{Addr bits} - \log_2 (M) - \log_2 (S) $$

### Cosa contiene la linea di cache

Ogni linea (o ciascuna delle linee dentro un set) memorizza:

- **Valid bit**: indica se il contenuto è valido.
- **TAG**: per sapere se la linea corrisponde all'indirizzo richiesto (match del TAG).
- **Dati**: $\mathbf{M}$ byte della linea.
- (Facoltativi) **Dirty bit**, bit di **coerenza** (MESI/MOESI), contatori per la **sostituzione** (LRU/Pseudo-LRU), ecc.

Questi bit non **provengono dall'indirizzo**: sono metadati conservati insieme alla linea.

---

## Write-Through e Write-Back

Il concetto di **Write-Through** e **Write-Back** riguarda il comportamento della cache quando il processore **scrive** un dato che è già presente nella cache (un *write hit*).

### Write-Through

Nel **write-through**, quando si modifica un dato in cache, la modifica viene **immediatamente propagata anche alla memoria principale**. Questo garantisce che cache e memoria siano sempre coerenti, evitando problemi di inconsistenza. Tuttavia, il rovescio della medaglia è che **ogni scrittura diventa più lenta**, perché deve attraversare anche il percorso verso la DRAM, che ha latenza molto più alta rispetto alla cache.

Per ridurre questo impatto si introduce il **write buffer**: una piccola coda che memorizza temporaneamente i dati da scrivere in memoria. In questo modo la CPU può continuare ad eseguire istruzioni senza aspettare che la scrittura verso la DRAM sia completata. Si hanno stall solo se il write buffer è pieno (ad esempio in scenari di scritture molto ravvicinate).

### Write-Back

Nel **write-back**, invece, quando si modifica un dato in cache, la modifica **resta solo nella cache** e si segna la linea come **dirty** (*sporca*). Il dato verrà scritto in memoria **solo quando quella linea di cache dovrà essere rimpiazzata** (replacement). Questo riduce notevolmente il numero di scritture in memoria e quindi migliora le prestazioni, specialmente in scenari dove lo stesso dato viene aggiornato più volte di seguito: con write-through ogni aggiornamento andrebbe in DRAM, mentre con write-back basta una sola scrittura finale al momento del rimpiazzo.

Anche nel write-back si usa spesso un **write buffer**, ma con una funzione diversa: serve a permettere che il blocco sporco venga scritto in memoria **in background**, così la CPU può caricare subito il nuovo blocco che lo sostituisce senza aspettare che il vecchio venga salvato.

---

## Problema della Coerenza delle Cache (cache coherence)

Quando due (o più) CPU hanno copie dello stesso dato nelle proprie cache L1 e una di loro lo modifica, il rischio è che l'altra continui a usare una **copia vecchia** (*stale data*), generando risultati errati. Anche se il processore che scrive aggiorna subito la DRAM (write-through) o la aggiorna al momento del write-back, questo non basta: l'altra CPU potrebbe continuare a leggere dalla propria cache senza mai accorgersi della modifica.

#### Come si risolve: protocolli di coerenza

Il problema viene risolto con **protocolli di coerenza della cache**, che stabiliscono regole per far sì che tutte le copie di un dato siano **sincronizzate**. Nei sistemi multiprocessore moderni si usano principalmente protocolli basati su **snooping** o basati su **directory**.

### Snooping

Nel **snooping**, tutte le cache sono collegate a un **bus di comunicazione comune** (o a un'interconnessione coerente). Ogni cache “ascolta” (snoop) le operazioni fatte dalle altre CPU.

Quando una CPU scrive un dato:
- Se un'altra cache ha una copia di quel dato, riceve un segnale di invalidazione o aggiornamento.
- **Invalidazione**: la cache marca quella linea come **invalid** (il bit “valid” diventa 0). Alla prossima lettura, dovrà andare a prendere la copia aggiornata (dalla memoria o dalla cache che ha la versione più recente).
- **Aggiornamento**: la cache riceve direttamente il nuovo valore e aggiorna la propria linea.

### Directory-based

In architetture con molti core, il traffico di snooping diventerebbe eccessivo. In questi casi si usa un **directory-based protocol**: un'unità centrale (directory) tiene traccia di quali cache hanno copie di ogni blocco.

Quando un core scrive:
- La directory invia messaggi solo alle cache che hanno la copia, per invalidare o aggiornare.
- Questo riduce il traffico rispetto allo snooping, ma aggiunge complessità.

### Esempio: protocollo MESI

Il **MESI** (Modified, Exclusive, Shared, Invalid) è uno dei protocolli più comuni. Ogni linea di cache ha uno stato:

- **M** (Modified): linea modificata, copia in memoria non aggiornata.
- **E** (Exclusive): copia uguale alla memoria, presente solo in questa cache.
- **S** (Shared): copia uguale alla memoria, presente in più cache.
- **I** (Invalid): linea non valida.

Se una CPU ha una linea in stato **S** e un'altra CPU scrive su quella linea:

1. La CPU che scrive invia un messaggio di invalidazione.
2. La linea nelle altre cache passa a stato **I**.
3. Alla prossima lettura, queste cache dovranno recuperare il dato aggiornato.

- 💡 **Nota importante**: Questo meccanismo funziona indipendentemente dal fatto che sia write-back o write-through, perché i protocolli MESI/ MOESI/ MSI gestiscono la coerenza tra le cache private e la memoria condivisa. Senza di essi, i dati vecchi rimarrebbero nella L1 dell'altra CPU, generando errori.

---

## Replacement Policy

La **replacement policy** indica **come la cache sceglie quale linea sostituire** quando deve caricare un nuovo blocco di dati e la linea destinata è già occupata. La strategia dipende molto dal tipo di cache.

Se la cache è **directly mapped**, non c'è scelta: ogni blocco di memoria ha **una sola possibile linea** nella cache dove può andare. Se quella linea è già occupata, la vecchia linea viene sostituita senza alternative.

Se invece la cache è **set-associative** (cioè ogni set contiene più linee), la cache ha diverse possibilità di sostituzione. Qui entrano in gioco diverse strategie:

1. **Prefer non-valid entry**: se nel set c'è almeno **una linea non valida** (cioè vuota o non inizializzata), la cache la utilizza subito. In questo caso non è necessario sostituire nessuna linea “utile”.

2. **Least Recently Used (LRU)**: se tutte le linee sono valide, la cache sostituisce quella che **non è stata usata da più tempo**. Questo metodo cerca di mantenere in cache i dati più “attivi”, riducendo i cache miss. Per cache poco associative (2-way o 4-way), è facile da implementare. Per cache con alta associatività, il tracking del “tempo dall'ultimo uso” diventa complicato e costoso.

3. **Random**: quando tutte le linee sono valide, si sceglie **una linea a caso** da sostituire. Anche se sembra meno intelligente, nei casi di alta associatività funziona quasi quanto LRU, perché con molti blocchi ogni linea ha probabilità simile di essere riutilizzata o meno.

---

## Blocking Optimization

Il termine **software optimization via blocking** (a volte chiamato anche **loop blocking** o **loop tiling**) è una tecnica utilizzata per **migliorare l'uso della cache** e ridurre i cache miss durante l'esecuzione di algoritmi che accedono a grandi strutture dati, come matrici.

L'idea di base è che, nelle cache, i dati vengono caricati in **blocchi contigui** (linee di cache). Se accediamo ripetutamente a dati sparsi in memoria, molti di questi accessi causeranno miss perché la cache dovrà continuamente sostituire le linee già caricate. Questo è costoso.

Con **blocking**, si riscrivono i loop in modo da **lavorare su sotto-blocchi** (**“tiles”**) **di dati** che **entrano interamente nella cache**. In questo modo, una volta che un blocco di dati è caricato, il programma può accedere a tutti gli elementi di quel blocco **prima che venga sostituito**, massimizzando la località spaziale e temporale.

- L'obiettivo del blocking è far sì che **ogni dato caricato in cache venga utilizzato il più possibile prima di essere sostituito**.

---
