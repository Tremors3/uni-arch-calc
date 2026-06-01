
#### QUESITO

Si consideri una cache che usa 5 bit per il campo offset e 3 bit per il campo index. Ipotizzando di aver già letto l’indirizzo 0x0000, quali affermazioni sono vere (spiegare il ragionamento per arrivare alla risposta)? 

- a) Se eseguire letture agli indirizzi 0x0114, 0x0308, 0x1005 produce tutte conflict miss allora la cache è direct mapped 
- b) Se la stessa sequenza di letture del punto a) produce tutte cold cache miss allora la cache è 4-way set-associative 
- c) Se la stessa sequenza di letture del punto a) produce una cold cache miss e due conflict miss allora la cache è 2-way set-associative 
- d) Se la cache è 4-way set-associative la sua dimensione è 1KB 

#### RISOLUZIONE

Parametri della cache:

- Offset = 5 bit → ogni linea è 32 B.
- Index = 3 bit → ci sono 8 set.
- Tag = 32 − 5 - 3 = 24 bit.

Quindi la cache ha:

- DM    → 1 linea per set → 8 × 1 × 32 = 256 B.
- 2-way → 2 linee per set → 8 × 2 × 32 = 512 B.
- 4-way → 4 linee per set → 8 × 4 × 32 = 1024 B (1 KB).

Risposte:

- a. **VERA** $-$ 
    - In una direct mapped c’è 1 sola linea per set. 
    - Dopo il primo accesso (compulsory miss), ogni nuovo tag sostituisce il precedente → tutti i successivi sono **conflict miss**.
      - 0x0000 = 0000 0000 |000|0 0000
      - 0x0114 = 0000 0001 |000|1 0100
      - 0x0308 = 0000 0011 |000|0 1000
      - 0x1005 = 0001 0000 |000|0 0101

- b. **VERA** $-$ 
    - In una 4-way set associative ci sono 4 linee per set. 
    - I 4 indirizzi hanno tag diversi ma trovano posto tutti nello stesso set. 
    - Risultato: **4 compulsory miss**, nessun conflict.

- c. **VERA** $-$ 
    - In una 2-way set associative ci sono 2 linee per set.
    - Primo accesso (0x0000) → compulsory miss.
    - Secondo accesso (0x0114) → altro tag, seconda linea → **compulsory miss**.
    - Terzo accesso (0x0308) → set pieno, altro tag, seconda linea → **conflict miss**.
    - Quarto accesso (0x1005) → nuovo tag, ancora rimpiazzo → **conflict miss**.

- d. **VERA** $-$ Per una 4-way: $8 \text{ set} \times 4 \text{ vie} \times 32 \text{ B} = 1024 \text{ B} = 1 \text{ KB}$.
