
#### QUESITO

Si consideri una cache che usa 8 bit per il campo offset e 4 bit per il campo index. Ipotizzando di aver già letto l’indirizzo 0x0100, quali affermazioni sono vere (spiegare il ragionamento per arrivare alla risposta)? 

- a) Se eseguire letture agli indirizzi 0x0114, 0x0308, 0x1105 produce due conflict miss e una cold cache miss allora la cache è direct mapped 
- b) Se la stessa sequenza di letture del punto a) produce tutte cold cache miss allora la cache è set-associative, con almeno 4 vie 
- c) Se la stessa sequenza di letture del punto a) produce due cold cache miss e una conflict miss allora la cache è 2-way set-associative 
- d) Se la cache è direct mapped la sua dimensione è 4KB

#### RISOLUZIONE

Parametri della Cache:

- Offset = 8 bit → ogni linea è 256 B.
- Index = 4 bit → ci sono 16 insiemi.
- Tag = 32 - 8 - 4 = 20 bit.

Quindi la cache ha:

- DM    → 1 linea per set → 256 × 1 × 16 = 4096 Byte = 4 KB.
- 2-way → 2 linee per set → 256 × 2 × 16 = 8192 Byte = 8 KB.
- 4-way → 4 linee per set → 256 × 4 × 16 = 16384 Byte = 16 KB.

Risposte:

- a) **FALSA**
    - Le tre ultime letture producono una hit, una compulsory miss e una conflict miss.
        - 0x0100 = 0000 | 0001 | 0000 0000 → compulsory miss
        - 0x0114 = 0000 | 0001 | 0001 0100 → hit
        - 0x0308 = 0000 | 0011 | 0000 1000 → compulsory miss
        - 0x1105 = 0001 | 0001 | 0000 0101 → conflict miss

- b) **FALSA**
    - Con una 2-way set associative cache avremmo:
        - 0x0100 → compulsory miss
        - 0x0144 → hit
        - 0x0308 → compulsory miss
        - 0x1105 → compulsory miss
    - Tralasciando la hit, le altre letture sono tutte compulsory miss e la cache è 2-way set associative.

- c) **FALSA** $-$ Come mostrato dal punto precedente.

- d) **VERA** $-$ Per una DM: $256 \text{ set} \times 1 \text{ vie} \times 16 \text{ B} = 4 \text{ KB}$.
