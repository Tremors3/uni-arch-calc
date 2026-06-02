
#### QUESITO

Si consideri una cache che usa 4 bit per il campo offset e 4 bit per il campo index. Ipotizzando di aver già letto l’indirizzo 0x0000, quali affermazioni sono vere (spiegare il ragionamento per arrivare alla risposta)? 

- a) Se eseguire letture agli indirizzi 0x0114, 0x0308, 0x1005 produce tutte conflict miss allora la cache è direct mapped 
- b) Se la stessa sequenza di letture del punto a) produce tutte cold cache miss allora la cache è set-associative, con almeno 4 vie 
- c) Se la stessa sequenza di letture del punto a) produce due cold cache miss e una conflict miss allora la cache è 2-way set-associative 
- d) Se la cache è 2-way set-associative la sua dimensione è 1KB 

#### RISOLUZIONE

Parametri della Cache:

- Offset = 4 bit → ogni linea è 16 Byte.
- Index = 4 bit → ci sono 16 set.
- Tag = 32 - 4 - 4 = 24 bit.

Quindi la cache ha:

- DM    → 1 linea per set → 16 × 1 × 16 = 256 B.
- 2-way → 2 linee per set → 16 × 2 × 16 = 512 B.
- 4-way → 4 linee per set → 16 × 4 × 16 = 1024 B (1 KB).

Risposte:

- a) **FALSA**
    - I primi due accessi risultano in **compulsory miss**, mentre gli ultimi due accessi risultano in **cache miss**. → Non sono tutte conflict miss.
      - 0x0000 = 0000 0000 | 0000 | 0000
      - 0x0114 = 0000 0001 | 0001 | 0100
      - 0x0308 = 0000 0011 | 0000 | 1000
      - 0x1005 = 0001 0000 | 0000 | 0101

- b) **VERA**
    - In una 4-way set associative ci sono 4 linee per set. 
    - I 3 indirizzi 0x0000, 0x0308, 0x1005 hanno tag diversi ma trovano posto tutti nello stesso set. 
    - L'indirizzo 0x0114 invece ha indice diverso rispetto agli altri 3 e trova posto in un altro set.
    - Risultato: **4 compulsory miss**, nessun conflict.
    - Per evitare conflict servono $\geq$ **3 linee per set**, quindi almeno una **4-way**.

- c) **VERA**
    - In una 2-way set associative ci sono 2 linee per set.
    - Primo accesso (0x0000)   → Set 0 → **compulsory miss**.
    - Secondo accesso (0x0114) → Set 1 → **compulsory miss**.
    - Terzo accesso (0x0308)   → Set 0 → altro tag, seconda linea → **compulsory miss**.
    - Quarto accesso (0x1005)  → Set 0 → set pieno, altro tag, rimpiazzo → **conflict miss**.

- d) **FALSA** $-$ Per una 2-way: $16 \text{ set} \times 2 \text{ vie} \times 16 \text{ B} = 512 \text{ B} \neq 1024 \text{ B}$.
