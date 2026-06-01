
## Note sulla virtual memory

Normalmente, la memoria virtuale viene organizzata in **pagine** di dimensione standard, e la dimensione più comune è 4 KB. Questo significa che sia lo spazio di indirizzi virtuale sia quello fisico sono divisi in blocchi di 4096 byte. Esistono anche pagine di dimensione diversa (pagine grandi da 2 MB o 1 GB), ma il formato standard rimane 4 KB.

Per quanto riguarda **l’associatività della DRAM**, quello che intendi è riferito alla **mappatura delle pagine virtuali sulla memoria fisica**. Nella cache, spesso non si usa associatività completa perché costerebbe troppo in termini di hardware e comparatori. Ma nella memoria virtuale, invece, si usa proprio l’associatività completa: **qualsiasi pagina virtuale può essere collocata in qualsiasi frame della memoria fisica**. Questo è fondamentale perché la memoria fisica è molto più grande della cache e non possiamo permetterci di limitare le scelte, altrimenti avremmo troppi conflitti e sprechi.

Il concetto di **page fault** è centrale: si verifica quando un processo tenta di accedere a una pagina che non è presente nella memoria fisica. In quel momento il sistema operativo deve intervenire: individua che la pagina richiesta è su disco (tipicamente nello swap file o swap partition), sceglie un frame fisico in cui caricarla (eventualmente liberandone uno, se la RAM è piena), e poi aggiorna le strutture di traduzione (come la page table) in modo che il processo possa continuare. Durante questo tempo il processo è sospeso, perché il disco ha tempi di accesso milioni di volte più lenti della DRAM.

Infatti, l’operazione più costosa in assoluto è proprio questa: **trasferire una pagina da disco a DRAM**. Mentre un accesso in DRAM richiede nanosecondi, un accesso a disco magnetico richiede millisecondi, e anche con un SSD siamo comunque nell’ordine delle microsecondi, cioè molto più lento della RAM. Per questo motivo, i sistemi operativi e i compilatori fanno di tutto per minimizzare i page fault, cercando di prevedere quali pagine saranno necessarie e mantenendo in RAM quelle più “calde” (ossia più usate di recente).

---

## Perchè è stata introdotta la virtual memory

1. All’inizio, quando i primi calcolatori usavano solo la **memoria fisica** (RAM), questa era molto limitata. Ogni programma doveva essere caricato interamente in RAM per poter essere eseguito, e quindi si era fortemente vincolati alla quantità di memoria disponibile. La **memoria virtuale** nasce proprio per superare questo vincolo: grazie al meccanismo di paging, **il sistema operativo fa credere a ogni processo di avere a disposizione uno spazio di indirizzi molto più grande della memoria fisica realmente installata**. La parte di memoria non immediatamente usata può essere temporaneamente conservata su disco (swap), caricata solo quando serve. In questo modo si ottiene l’illusione di avere una RAM “più grande” di quella fisica.

2. Oltre a questo vantaggio “quantitativo”, la virtual memory ha introdotto un beneficio qualitativo cruciale: **l’isolamento dei processi**. Senza memoria virtuale, i programmi avrebbero visto direttamente gli indirizzi fisici, con il rischio che uno andasse a scrivere o leggere nelle aree di memoria appartenenti a un altro. Con la virtual memory invece ogni processo vede uno spazio di indirizzi virtuale privato e indipendente, tradotto poi dal sistema operativo e dall’hardware (tramite la MMU) in indirizzi fisici. Questo meccanismo garantisce sicurezza, stabilità e protezione implicita, perché un processo non può accedere arbitrariamente alla memoria di un altro. È un pilastro del multitasking moderno.

3. Infine, la virtual memory è diventata un **elemento essenziale nella virtualizzazione** e negli hypervisor. Quando creiamo una macchina virtuale, dobbiamo dare l’illusione che quella macchina abbia a disposizione un proprio spazio di memoria indipendente, senza che vada a interferire con le altre macchine virtuali o con l’host. La virtual memory permette di mappare e rimappare facilmente gli indirizzi, realizzando più livelli di astrazione (ad esempio: guest virtual address → guest physical address → host physical address). Senza questo concetto, la virtualizzazione come la conosciamo oggi non sarebbe possibile.

---

## Quando eseguo un programma C, quali indirizzi vengono utilizzati, virtuali o fisici?

Quando esegui un programma in **C** in **user-space**, tutti gli indirizzi che il programma vede e usa sono **indirizzi virtuali**. È la **MMU** (Memory Management Unit) che si occupa di tradurli in indirizzi fisici, in modo trasparente al programma.

Anche in **kernel-space**, di norma il sistema operativo lavora ancora con indirizzi virtuali, ma con una mappatura speciale e privilegiata che gli consente accesso diretto all’hardware e alla memoria fisica. In alcuni casi particolari (driver, DMA, gestione dispositivi), il kernel deve effettivamente gestire indirizzi fisici, ma per la maggior parte del codice continua a usare indirizzi virtuali.

- Quindi: **user-space** = *sempre virtuali*, **kernel-space** = *virtuali con eccezioni* dove serve l’accesso diretto alla memoria fisica.

---

## Dove e quando avviene la traduzione degli indirizzi virtuali in indirizzi fisici?

La **traduzione degli indirizzi virtuali in fisici** avviene **all’interno del processore**, tramite la **Memory Management Unit (MMU)**. Quando la CPU genera un indirizzo virtuale (derivante da istruzioni in esecuzione), questo viene intercettato dalla MMU, che consulta il **TLB (Translation Lookaside Buffer)**, una piccola cache specializzata che mantiene le traduzioni più recenti da virtuale → fisico.

Se la traduzione è presente nel TLB, l’indirizzo fisico viene ottenuto subito (hit). Se invece manca (miss), la MMU deve consultare la **page table** in memoria, con il supporto del sistema operativo. In questo caso può esserci anche un **page fault** se la pagina non risiede in RAM ma su disco.

Per quanto riguarda le cache, qui sta il dettaglio sottile:

- Alcune architetture usano **cache virtual-indexed**, **virtual-tagged** (VIPT, VIVT), dove la cache L1 lavora direttamente con indirizzi virtuali per ridurre la latenza.

- Altre usano **cache fisiche** (PIPT, PIVT), che lavorano con indirizzi fisici già tradotti.

- Nella pratica moderna, la **L1** dati è spesso **virtual-indexed** ma **physical-tagged** (**VIPT**): l’accesso avviene velocemente con parte dell’indirizzo virtuale, ma il confronto finale dei tag avviene con l’indirizzo fisico per evitare aliasing (due virtual address che mappano lo stesso dato fisico).

Dalla **L2 in poi** le cache sono quasi sempre basate su indirizzi fisici, perché lì la latenza è meno critica e la coerenza deve essere garantita tra più core/processori.

- 👉 Quindi, la traduzione avviene **tra L1 e L2**, tramite la MMU e il TLB, ma l’esatta posizione può variare in base al design (VIPT, PIPT, ecc.).

---
