
### QUESITO

Una CPU RISC-V 32bit usa una L1 cache direct mapped grande 256B e con linee da 8 word. Quali affermazioni sono vere? 

- a) Ogni linea può ospitare 2^19 diversi indirizzi  
- b) A cache fredda due accessi successivi agli indirizzi 0x0020 e 0x0033 generano rispettivamente una compulsory miss e una hit 
- c) A seguito degli accessi al punto b) due nuovi accessi agli indirizzi 0x0000 e 0x2021 generano rispettivamente una compulsory miss e una conflict miss 
- d) A seguito degli accessi al punto b) e c) un nuovo accesso all’indirizzo 0x14 genera una compulsory miss 

#### RISOLUZIONE

Parametri della Cache:

- Indirizzo: 32 bit (RISC-V 32).
- Cache size: 256 B.
- Linea: 8 word = 8 × 4 B = 32 B.
- Numero Linee: 256 / 32 = 8 linee.

Quindi la cache ha:

- Offset = $\log_2(32) = 5$ bit.
- Index = $\log_2(8) = 3$ bit.
- Tag = $32 - 5 - 3 = 24$ bit.

Risposte:

- a. **FALSA** $-$ Per ogni indice fisso posso mappare $2^{\text{tag}} = 2^{24}$ blocchi diversi, quindi non $2^{19}$.

- b. **VERA**
    - 0x0020 = 0000 0000 |001|0 0000 → la cache è vuota, quindi si genera una **compulsory miss**.
    - 0x0033 = 0000 0000 |001|1 0011 → appartiene alla stessa linea già caricata in cache, quindi è **una hit**.

- c. **VERA**
    - 0x0000 = 0000 0000 |000|0 0000 → nuova linea (indice diverso, non ancora caricata), quindi **compulsory miss**.
    - 0x2021 = 0010 0000 |001|0 0001 → stesso indice della linea già occupata da 0x0020, ma con tag diverso → **conflict miss**.

- d. **FALSA**
    - 0x14   = 0000 0000 |000|1 0100 → ricade nella linea di indice 000 con tag 0x0, che è già stata caricata da 0x0000 → Risulta quindi **una hit**, non una compulsory miss.

---

### QUESITO

6. Una cache 4-way set associative con campo index e campo offset da 5 bit 
- a) È quattro volte più grande di una cache direct mapped con analoghi campi index e offset 
- b) Richiede meno logica di comparazione rispetto ad una cache direct mapped analoga 
- c) A parità di dimensioni ha miss rate medio più basso rispetto ad una cache direct mapped 
- d) A parità di dimensioni ha miss rate medio più basso rispetto ad una cache fully associative 

#### RISOLUZIONE

Risposte:

- a) **VERA** $-$ 4-way set associative ha 4 linee per set, quindi 4× più grande di una direct-mapped con stesso numero di set.
- b) **FALSA** $-$ Serve confrontare 4 tag per set, più logica rispetto a direct-mapped (1 sola comparazione).
- c) **VERA** $-$ Maggiore associatività riduce i conflict miss, quindi miss rate più basso rispetto a direct-mapped.
- d) **FALSA** $-$ Fully associative minimizza i conflict miss, quindi miss rate più basso della 4-way.

---

### QUESITO

7. La Memory Management Unit 
- a) Accelera in hardware la fase di page table walk 
- b) Sfrutta una piccola cache locale per ricordare le traduzioni più recenti 
- c) Contiene tutte le traduzioni per ogni pagina del virtual address space 
- d) Ospita la page table 

#### RISOLUZIONE

Risposte:

- a) **VERA** $-$ La MMU è hardware e accelera la page table walk.
- b) **VERA** $-$ La MMU usa il TLB (Translation Lookup Buffer) per memorizzare le traduzioni più recenti.
- c) **FALSA** $-$ La MMU non contiene tutte le traduzioni, solo quelle necessarie per la traduzione rapida.
- d) **FALSO** $-$ La page table risiede in DRAM, non nella MMU.

---

### QUESITO

8. L’architettura di Harvard 
- a) Evita per costruzioni alcuni tipi di structural hazards 
- b) È tipicamente implementata al primo livello della gerarchia di cache 
- c) È tipicamente implementata all’ultimo livello della gerarchia di cache 
- d) È meno costosa da implementare rispetto all’architettura di Von Neumann

#### RISOLUZIONE

Risposte:

- a) **VERA** $-$ In Harvard, istruzioni e dati risiedono in memorie fisicamente separate, evitando alcuni structural hazards.
- b) **VERA** $-$ L’architettura Harvard è tipica del primo livello di cache (L1).
- c) **FALSA** $-$ Nei livelli successivi di cache si usa quasi sempre Von Neumann.
- d) **FALSO** $-$ Harvard è più costosa, perché richiede due cache (L1) separate e sincronizzate.

---
