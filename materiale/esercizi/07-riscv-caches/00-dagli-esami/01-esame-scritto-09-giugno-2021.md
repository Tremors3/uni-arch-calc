
#### QUESITO

Una CPU RISC-V 32bit usa una L1 cache direct mapped grande 256B e con linee da 8 word. Quali affermazioni sono vere?

- a) Ogni linea può ospitare 2^19 diversi indirizzi
- b) A cache fredda due accessi successivi agli indirizzi 0x0020 e 0x0033 generano rispettivamente una compulsory miss e una hit
- c) A seguito degli accessi al punto b) due nuovi accessi agli indirizzi 0x0000 e 0x2021 generano rispettivamente una compulsory miss e una conflict miss
- d) A seguito degli accessi al punto b) e c) un nuovo accesso all’indirizzo 0x14 genera una compulsory miss

#### RISOLUZIONE

Parametri della cache:

- Indirizzo: 32 bit (RISC-V 32).
- Cache size: 256 B.
- Linea: 8 word = 8 $\times$ 4 = 32 B.
- Numero linee: 256 / 32 = 8 linee.
- Offset di linea: $\log_2 (32)$ = 5 bit.
- Indice: $\log_2 (8)$ = 3 bit.
- Tag: 32 - 5 - 3 = 24 bit.

Risposte:

- a. **FALSA** $-$ Per ogni indice fisso posso mappare $2^{\text{tag}} = 2^{24}$ blocchi diversi, quindi non $2^{19}$.

- b. **VERA**
    - 0x0020 = 0000 0000 |001|0 0000 $\rightarrow$ la cache è vuota, quindi si genera una compulsory miss.
    - 0x0033 = 0000 0000 |001|1 0011 $\rightarrow$ appartiene alla stessa linea già caricata in cache, quindi è una hit.

- c. **VERA**
    - 0x0000 = 0000 0000 |000|0 0000 $\rightarrow$ nuova linea (indice diverso, non ancora caricata), quindi compulsory miss.
    - 0x2021 = 0010 0000 |001|0 0001 $\rightarrow$ stesso indice della linea già occupata da 0x0020, ma con tag diverso → conflict miss.

- d. **FALSA**
    - 0x14   = 0000 0000 |000|1 0100 $\rightarrow$ ricade nella linea di indice 000 con tag 0x0, che è già stata caricata da 0x0000 → Risulta quindi una hit, non una compulsory miss.

#### NOTE

Regola veloce (per fare in esame senza scrivere tutto):

- **Indice = `(indirizzo / size_linea) mod num_linee`**.
- **Tag = `(indirizzo / size_linea) / num_linee`**.
- **Offset = `(indirizzo mod size_linea)`**.

Sezioni dell'indirizzo:

```
|  Tag  |  Indice  |  Offset  |
```
