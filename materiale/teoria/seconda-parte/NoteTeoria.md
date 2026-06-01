## Operazioni di Store in RISC-V: comprensione dell'indirizzamento e del significato dell'offset

In RISC-V, le istruzioni di store servono a scrivere un valore da un registro generale verso una locazione di memoria.
La forma generale di una store è:

```
<store> rs2, offset(rs1)
```

Ad esempio l'istruzione:

```
sd x5, 64(x20)      # a[8] = temp
```

In questo caso si tratta di un'istruzione `sd` (**StoreDouble**) che memorizza il il valore nel registro `x5` come una **Double Word** da 8 byte (64 bit). Il registro `x20` tiene l'indirizzo del primo elemento dell'array. Mentre 64 indica l'**Offset in byte** dal quel primo elemento. Dato che ciascun elemento dell'array è una **Double Word** (8 byte), allora l'indice dell'elemento in cui si scrive è **64 / 8 = 8**. L'indice è dunque 8 e quindi si tratta del nono elemento. Possiamo accedere agli altri elementi in questo modo:

Possiamo anche iterare un array composto da elementi di **Singole Word** da 4 byte (32 bit). E possiamo anche iterare l'array in modo hard coded in questo modo:

```
sd x5, 0(x20)      # a[0] = temp
sd x5, 4(x20)      # a[1] = temp
sd x5, 8(x20)      # a[2] = temp
sd x5, 16(x20)     # a[3] = temp
sd x5, 32(x20)     # a[4] = temp
```

Notare come in questo caso incrementiamo solamente di 4 bytes perchè in questo esempio il singolo elemento è una **Single Word** (4 bytes) e non più una **Double Word** (8 bytes).





---





## Operazioni di Store in RISC-V: cosa succede nella CPU?

Avendo una istruzione store del tipo:

```
<store> rs2, offset(rs1)
```

Otteniamo il seguente schema semplificato:

```
RS2 +---------------------------------------------------+ Value
    |                                                   |
+----------+        ________                    +-------|-------+
|          |  RS1   |       \                   |       |       |
| Register |--------|        \                  |       |       |
|   File   |        |         \                 |       |       |
|          |        \          \                |       |       |
|          |         \          |    Points     |-------|-------|  Memory
+----------+          |   ALU   |-------------> |       x       | Location
                     /          |               |---------------|
                    /          /                |               |
                    |         /                 |     DRAM      |
            +-------|        /                  |               |
            |       |_______/                   +---------------+
            64
```

Si nota come il registro `RS1` viene preso e sommato all'**offset 64** tramite una ALU.
L'ALU è settata ad **ADD-IMMEDIATE** e sommerà l'indirizzo di base contenuto in `RS1` con l'offset `64` (immediate).
Poi il valore del registro `RS2` **sovrascrive** il valore presente nell'area di memoria **puntata dal risultato dell'operazione precedente**.





---





## Il problema delle Branch Instructions (Long Jumps)

Le **branch** hanno un **immediate** di soli **12 bit**. Di conseguenza non sono in grado di fare salti molto grandi. Esiste un limite alla grandezza che l'offset può assumere, considerando anche che l'offset può essere sia positivo, sia negativo. Quindi **esiste un limite al numero di istruzioni che una Branch Instruction può saltare**, a partire dal Program Counter (PC) attuale.

---

## Come funzionano le Jump and Link

**Le JAL**:

```
jal rd, offset
```

Esegue un **salto relativo**: salta all'indirizzo `PC + offset` e **salva l'indirizzo di ritorno** (`PC + 4`) nel registro `rd`.
L'offset è a **20 bit**, quindi permette salti fino a ±1 MB. Usata per chiamate a label conosciute, cioè salti diretti.

Esempio:
```
jal x1, funzione   # x1 = PC + 4, salto all'etichetta "funzione"
```

**Le JALR**:

```
jalr rd, offset(rs1)
```
Esegue un **salto indiretto**: **calcola l'indirizzo di destinazione** come `rs1 + offset`, *forza il bit meno significativo a 0* (per allineamento), e salta lì.
**Salva l'indirizzo di ritorno** `(PC + 4) in rd`. Usata per chiamate dinamiche o ritorni da funzione.

Esempio:
```
jalr x1, 0(x5)     # x1 = PC + 4, salta all'indirizzo contenuto in x5
```

---

## Come JALR risolve il problema delle Branch (Long Jumps)

Se devo effettuare un salto molto lungo (offset elevato) allora i 12 bit messi a disposizione dalle istruzione branch (SB type) non bastano.
Per effettuare salti lunghi si può fare in questo modo:

```
lui x5, 20BPS
addi x5, x5, 12BMS
jalr zero, offset(x5)
```

Se devo effettuare un long jump (salto con immediate a 32 bit) lo costruisco tramite le istruzioni:
1) **lui** (**Load Upper Immediate**): per i *20 bit più significativi* (20BPS).
2) Istruzioni come la **Addi** (**Add Immediate**): che consentono di scrivere i *12 bit meno significativi* (12BMS).
3) Successivamente passare il registro ad una **JALR** (**Jump And Link Register**) che salterà all'indirizzo contenuto nel registro.





---





## Come funziona il Program Counter

Il **Program Counter (PC)** indica l'indirizzo in byte dell'istruzione corrente. Considerando che ciascuna *codifica delle istruzioni ISA RISC-V è di 4 byte (32 bit)* allora il **PC incrementerà di 4 byte ad ogni istruzione che viene eseguita**. Come mostrato al seguente esempio:

| PC (HEX)  | INST  |
|-----------|-------|
| 0000      | INST1 |
| ...       | ...   |
| 0004      | INST2 |
| 0008      | INST3 |
| 000C      | INST4 |
| 0010      | INST5 |
| ...       | ...   |

Otteniamo il seguente schema semplificato:

```
                +-------------------------------------------------------+
                |                                                       |
                |         ________                    +---------+       |
                |         |       \                   |         |       |
                +-------->|        \          +------>| Program |-------+
                          |         \         |       | Counter |
                          \          \        |       |         |
                           \          |       |       |         |
             __            |   ALU    |-------+       |         |
            |  \           /          |               |         |
      4 --->|   \         /          /                |         |
            | M  |        |         /                 |         |
            | U  |------->|        /                  |         |
            | X  |        |_______/                   +---------+
 offset --->|   /
            |__/
             |
             |
            sel
```

Come si denota dalla figura il *multiplexer* decide se incrementare il Program Counter di **4 byte oppure sommargli l'offset**. Ricordiamo che l'offset è espresso in bytes anchesso e puè essere **positivo oppure negativo** a seconda che la label si trovi dopo o prima del PC attuale.

---

## LABEL e Program Counter

Una **label** (etichetta) è un **nome simbolico** che rappresenta un **indirizzo di memoria** nel codice. Viene usata per rendere il programma più leggibile, in particolare con salti e chiamate di funzione.

Quando il codice viene assemblato, la label viene risolta in un indirizzo assoluto di memoria. Poi:

1) Il Program Counter (**PC**) contiene l'indirizzo dell'**istruzione corrente**.
2) Le **istruzioni di salto** calcolano la *differenza tra l'indirizzo della label e l'indirizzo successivo (PC + 4)*, cioè un **offset** relativo.
3) Questo **offset** viene codificato all'interno dell'istruzione (con campo `immediate`), in base al formato (tipicamente 12 o 20 bit).

    $$ \text{PC}_\text{new} = (\text{PC + 4}) + \text{OFFSET} $$

**Esempio: salto condizionato**

```
beq x1, x2, LABEL
```

Supponi che `LABEL` si trovi **16 byte prima dell'istruzione corrente** (quindi a *PC - 16*). Allora l'istruzione `beq` conterrà un **offset di -16**, che verrà sommato a **PC + 4** per ottenere il prossimo indirizzo di salto.





---





## Tabella di conversione: indice → offset in byte

| Dimensione elemento | Abbreviazione| Byte per elemento | Shift equivalente | Significato                |
|---------------------|--------------|-------------------|-------------------|----------------------------|
| **Byte**            | `b`          | 1 byte            | `index << 0`      | Nessun shift: 1 $x$ indice |
| **Halfword**        | `h`          | 2 byte            | `index << 1`      | Shift a sinistra di 1 bit  |
| **Word**            | `w`          | 4 byte            | `index << 2`      | Shift a sinistra di 2 bit  |
| **Doubleword**      | `dw`         | 8 byte            | `index << 3`      | Shift a sinistra di 3 bit  |

**Nota**

In Assembly RISC-V, *gli offset nelle istruzioni di load/store sono sempre espressi in byte*.
Se stai **accedendo a un array**, devi **moltiplicare l’indice per la dimensione di ciascun elemento**, oppure usare il **corrispondente shift a sinistra** per efficienza.