# Quarto Appello 10 set 2025

## Risoluzione Esercizi

### 1. \[5pt\] - **Esercizio Datapath Pipelined**

#### Quesito

Scrivere, se esiste, una possibile sequenza di 5 istruzioni che produca i seguenti valori dei segnali di controllo di una pipeline RISC-V:

- PCSrc = 1
- RegWrite = 1
- Write Register = 00101
- AluSrc = 1
- Alu CTRL = 0000
- MemRead = 0
- MemWrite = 0
- MemToReg = 1

NON limitarsi a fornire una sequenza di istruzioni, ma spiegare dettagliatamente il perchè delle scelte. Se una sequenza possibile non esiste spiegare dettagliatamente il perchè.

#### Risoluzione

| Fase | Istruzione       | Motivazione |
|------|------------------|-------------|
| WB   | ld x5, 0(x10)    | MemToReg = 1, Write Register = 00101 = 5 (x5) |
| MEM  | beq x8, x9, LBL  | MemRead = MemWrite = 0, PCSrc = 1 (expression is true) |
| EXEC | andi x28, x28, 8 | Alu CTRL = 0000 (AND), AluSrc = 1 (immediate used) |
| ID   | or x18, x19, x20 | Any |
| IF   | sb x9, 3(x11)    | Any |

In questo caso i segnali di controllo accesi non sono in conflitto tra loro. Ricordiamo che alcuni segnali sono mutualmente esclusivi. Ad esempio: MemRead, MemWrite e PCSrc.

---

### 2. \[6pt\] - **Programmazione RISC-V**

#### Quesito

Implementare in assembly RISCV (32 bit) la funzione C `strcpy`

```C
char *strcpy(char *dst, const char *src);
```

che copia `src` (stringa sorgente), incluso il carattere `null` finale, nell'ubicazione specificata da `dst` (stringa destinazione).
La funzione `strcpy()` opera su stringhe con fine `null`. Gli argomenti della stringa per la funzione devono contenere un carattere `null` (`\0`) che contrassegna la fine della stringa. Non viene eseguito alcun controllo di lunghezza. La funzione `strcpy()` restituisce un puntatore alla stringa copiata (`dst`).

Il carattere `null` viene codificato in ASCII col valore numerico $0$. Gestire correttamente lo stack come da calling convention, così come il passaggio dei parametri di ingresso e di uscita sui registri appropriati. Scrivere la funzione **`main`** che invoca **`strcpy`**, mostrando anche l'allocazione degli array sul segmento dati statico del file ELF.

#### Risoluzione

- **Versione con indici**:

    Per prima cosa strutturiamo l'algoritmo in linguaggio C:

    ```C
    char *strcpy(char *dst, const char *src) {
        int i = 0;
        for (; src[i] != '\0'; i++)     // Copio finchè non incontro il terminatore di stringa di src
            dst[i] = src[i];            // Effettuo la copia ad ogni iterazione
        dst[i] = '\0';                  // Adesso i == len(src), quindi setto il terminatore
        return dst;
    }
    ```

    Ora traduciamolo in linguaggio assembly RISC-V, ricordandoci di scrivere anche il main:

    ```asm
    .global main
    .data
        dst: .string "dst"
        src: .string "src"
    .text
    main:
        la x10, dst         # Arg 1° = dst
        la x11, src         # Arg 2° = src
        jal x1, strcpy      # Call strcpy procedure

        li x10, 0           # Set exit value 0
        li x17, 93          # Exit syscall code
        ecall               # Call Exit syscall

    # x10 = dst
    # x11 = src
    strcpy:
        add x29, x0, x0     # i = 0
    LOOP:
        add x5, x29, x11    # x5 = src + i
        lbu x5, 0(x5)       # x5 = src[i]
        beq x5, x0, ENDL    # Goto ENDL if (src[i] == '\0')

        add x6, x29, x10    # x6 = dst + i
        sb x5, 0(x6)        # dst[i] = src[i]

        addi x29, x29, 1    # i++
        jal x0, LOOP        # Goto LOOP
    ENDL:
        addi x7, x29, x10   # x7 = dst + i
        sb x0, 0(x7)        # dst[i] = '\0'

        jalr x0, 0(x1)      # Return to caller
    ```

- **Versione alternativa con puntatori**:

    ```C
    char *strcpy(char *dst, const char *src) {
        char *Tdst = dst;

        do {
            *Tdst++ = *src;
        } while (*src++ != '\0');

        return dst;
    }
    ```

    ```asm
    # x10 = dst
    # x11 = src
    strcpy:
        add x30, x0, x10    # x30 = dst
    WHILE:
        lbu x5, 0(x11)      # x5 = *src
        sb x5, 0(x30)       # *dst = x5
        
        beq x5, x0, ENDW    # Goto ENDW if (*src == '\0')

        addi x11, x11, 1    # src++
        addi x30, x30, 1    # dst++
        jal x0, WHILE       # Goto WHILE
    ENDW:
        jalr x0, 0(x1)      # Return to caller
    ```

---

### 3. \[5pt\] - **Esercizio Cache**

#### Quesito

Si consideri una cache che usa 8 bit per il campo offset e 8 bit per il campo index.

- a) Quanto è grande la cache se si considera un design direct mapped e uno 4-way set associative?

- b) Scegliando la tipologia di cache al punto precedente che risulta essere più grande, scrivere una sequenza di richieste d'accesso che produce, in sequenza:
    1. una cold cache miss,
    2. una hit,
    3. una cold cache miss,
    4. una conflict miss.

- c) Scrivere uno stralcio di codice C che, per la tipologia di cache di cui al punto b), produce sistematicamente il 50% di cache miss.

- d) Come cambia la miss rate se lo stesso codice è eseguito su una cache fully associative?

#### Risoluzione

- a) Calcolo dimensione delle cache:
    - $ \text{Line size} = 2^{\text{offset}} = 2^8 = 256 \text{ bytes} $
    - $ \text{Line numb.} = 2^{\text{index}} = 2^8 = 256 \text{ lines} $
    - $ \text{Direct Mapped Size} = 256 \text{ lines} \times 256 \text{ bytes} = \mathbf{64} \textbf{ KB} $
    - $ \text{4-way Set Associative Size} = 256 \text{ lines} \times 256 \text{ bytes} \times 4 \text{ ways} = 64 \text{ KB} \times 4 \text{ ways} = \mathbf{256} \textbf{ KB} $

- b) La tipologia di cache che risulta essere più grande è la **4-way set associative** (ben 4 volte più grande della DM).
    
    Sequenza di richieste:
    ```C
    1. 0x0000A --> 0000 | 0000 0000 | 0000 1010 --> cold cache miss
    2. 0x1000B --> 0001 | 0000 0000 | 0000 1011 --> cold cache miss
    3. 0x2000C --> 0010 | 0000 0000 | 0000 1100 --> cold cache miss
    4. 0x0000D --> 0000 | 0000 0000 | 0000 1101 --> hit
    5. 0x3000E --> 0011 | 0000 0000 | 0000 1110 --> cold cache miss
    6. 0x4000F --> 0100 | 0000 0000 | 0000 1111 --> conflict miss
    ```

- c) Codice C che genera 50% di cache miss:
    
    ```C
    sum += array[0];                // hit
    sum += array[(i % 256) * 256];  // miss
    ```

    - La prima istruzione accede sempre allo stesso indirizzo, che viene caricato in cache alla prima iterazione e rimane lì grazie alla politica LRU (Least Recently Used), quindi tutti gli accessi successivi saranno hit.

    - La seconda istruzione invece accede ogni volta a un indirizzo diverso (spostandosi di 256 byte a ogni iterazione), quindi accede a un blocco di cache diverso. Nei primi accessi si verificheranno cold misses. Successivamente, quando la cache si riempie, si inizieranno a verificare conflict misses.

    - Su ogni coppia di accessi, uno sarà un hit e l’altro un miss, portando ad un 50% di cache miss.

- d) Su una cache fully associative sufficientemente grande, la miss rate scenderebbe a 0%, poiché tutte le linee utilizzate possono essere mantenute senza conflitti.

---

### 4. \[6pt\] - **Traduzione del codice RISC-V**

#### Quesito

Dato il seguente programma RISC-V

```asm
MAIN:
    li a0, 10
    jal ra, SUM

SUM:
    addi sp, sp, -8
    sd s0, 0(sp)
    li s0, 0
FOR:
    add s0, s0, a0
    addi a0, a0, -1
    blt zero, a0, FOR

    ld s0, 0(sp)
    addi sp, sp, 8
    ret
```

Si codifichino le istruzioni in formato binario e quindi esadecimale.

#### Risoluzione

- `li a0, 10 `$\rightarrow$ `addi x10, x0, 10`
    - 0000|0000|1010| 0000|0 000| 0101|0 001|0011
    - 0x00A0 0513

- `jalr ra, sum` $\rightarrow$ 1 avanti $\rightarrow$ 1 $\cdot$ 4 = 4 $\rightarrow$ 4 >> 1 = 2 (in 20 bit) $\rightarrow$ `jal x1, 0x00002`
    - 0000|0000|0100|0000|0000 0000|1 110|1111
    - 0x004 000EF

- `addi sp, sp, -8` $\rightarrow$ `addi x2, x2, 0xFF8` = 1111|1111|1000
    - 1111|1111|1000| 0001|0 000| 0001|0 001|0011
    - 0xFF81 0113

- `sd s0, 0(sp)` $\rightarrow$ `sd x8, 0(x2)`
    - 0000|000 0|1000| 000 1|0011| 0000|0 010|0011
    - 0x0081 3023

- `li s0, 0` $\rightarrow$ `addi x8, x0, 0`
    - 0000|0000|0000| 0000|0 000| 0100|0 001|0011
    - 0x0000 0413

- `add s0, s0, a0` $\rightarrow$ `add x8, x8, x10`
    - 0000|000 0|1010| 0100|0 000| 0100|0 011|0011
    - 0x00A4 0433

- `addi a0, a0, -1` $\rightarrow$ `addi x10, x10, 0xFFF` = 1111|1111|1111
    - 1111|1111|1111| 0101|0 000| 0101|0 001|0011
    - 0xFFF5 0513

- `blt zero, a0, FOR` $\rightarrow$ 2 indietro $\rightarrow$ -2 $\cdot$ 4 = -8 $\rightarrow$ -8 >> 1 = -4 (in 12 bit) $\rightarrow$ `blt x0, x10, 0xFFC`
    - 1111|111 0|1010| 0000|0 100| 1100|1 110|0011
    - 0xFEA0 4CE3

- `ld s0, 0(sp)` $\rightarrow$ `ld x8, 0(x2)`
    - 0000|0000|0000| 0001|0 011| 0100|0 000|0011
    - 0x0001 3403

- `addi sp, sp, 8` $\rightarrow$ `addi x2, x2, 8`
    - 0000|0000|1000| 0001|0 000| 0001|0 001|0011
    - 0x0081 0113

- `ret` $\rightarrow$ `jalr x0, 0(x1)`
    - 0000|0000|0000| 0000|1 000| 0000|0 110|0111
    - 0x0000 8067

---

### 5. \[5pt\] - **Calcolo Missprediction Rate & Inserimento Nop**

#### Quesito

Si consideri il programma dell'esercizio 4 su una pipeline RISC-V:

- a) Assumendo che la pipeline abbia logica di forwarding e dynamic branch prediction **a un bit** inizialmente settato a **BRANCH TAKEN**, dire qual è la misprediction rate;

- b) Assumento che la pipeline NON abbia logica di forwarding modificare il programma opportunamente per evitare hazards.

#### Risoluzione

- a) Calcolo della misprediction rate:

    - 10 iterazioni totali (numero predizioni):
        - 1° predizione $\rightarrow$ Hit;
        - 2°-9° predizione $\rightarrow$ Tutte Hit;
        - 10° predizione $\rightarrow$ Miss.

    $$ \text{Miss Pred. Rate} = \frac{\text{Misses}}{\text{Total Predictions}} = \frac{1}{10} = 10\% $$

- b) Aggiunta di NOP al programma:

    ```asm
    MAIN:
        li a0, 10
        jal ra, SUM

    SUM:
        addi sp, sp, -8
        NOP
        NOP
        sd s0, 0(sp)
        li s0, 0
        NOP
        NOP
    FOR:
        add s0, s0, a0
        addi a0, a0, -1
        NOP
        NOP
        blt zero, a0, FOR

        ld s0, 0(sp)
        addi sp, sp, 8
        ret
    ```

### 6. \[6pt\] - **Progettazione Rete Logica Sequenziale**

#### Quesito

Descrivere e sintetizzare una rete con tre ingressi a, b, c e un'uscita z. L'uscita è sempre zero, tranne quando si presenta una sequenza di tre stati di ingresso consecutivi aventi le seguenti caratteristiche:

- primo stato ingresso:     `a=b, c=0`
- secondo stato incresso:   `a!=b, c=0`
- terzo stato ingresso:     `a=b, c=1`

Ad esempio, le sequenze di stati di ingresso 000, 100, 001 e 110, 010, 001 mandano alta l'uscita della rete.

Dire se conviene utilizzare un automa di Mealy o Moore, motivando chiaramente la risposta.
Ricavare la specifica degli stati, il diagramma di transizione, le tabelle di verità e le forme minime per le reti di stato futuro e delle uscite. Disegnare il circuito finale.

#### Risoluzione

Tabella degli inputs:

| a | b | c |
|---|---|---|
| 0 | 0 | 0 |
| 0 | 0 | 1 |
| 0 | 1 | 0 |
| 0 | 1 | 1 |
| 1 | 0 | 0 |
| 1 | 0 | 1 |
| 1 | 1 | 0 |
| 1 | 1 | 1 |

Tabella di codifica degli stati:

| S | $s_1$ $s_0$ | Significato   |
|---|:-----------:|:-------------:|
| A | 0 0         | Inizio        |
| B | 0 1         | "000" e "110" |
| - | 1 0         | /             |
| C | 1 1         | "010" e "100" |

Dal momento che si tratta di un semplice caso di riconoscimento di pattern utilizziamo l'automa di Mealy, che ci consente di risparmiare uno stato.

```txt
              others                    
 +--------------------------------+
 | +--------------+               |
 v v              |               |
+---+  000,110  +---+ 010,100   +---+
| A |---------->| B |---------->| C |
+---+           +---+           +---+
  ^          001,111/Z=1          |
  +-------------------------------+
```

Tabella di verità, con stati passati e futuri:

| S | $s_1$ $s_0$ | a b c | S | $S_1$ $S_0$ | Z |
|---|:-----------:|:-----:|---|:-----------:|---|
| A | 0 0         | 0 0 0 | B | 0 1         | 0 |
| A | 0 0         | 0 0 1 | A | 0 0         | 0 |
| A | 0 0         | 0 1 0 | A | 0 0         | 0 |
| A | 0 0         | 0 1 1 | A | 0 0         | 0 |
| A | 0 0         | 1 0 0 | A | 0 0         | 0 |
| A | 0 0         | 1 0 1 | A | 0 0         | 0 |
| A | 0 0         | 1 1 0 | B | 0 1         | 0 |
| A | 0 0         | 1 1 1 | A | 0 0         | 0 |
| B | 0 1         | 0 0 0 | A | 0 0         | 0 |
| B | 0 1         | 0 0 1 | A | 0 0         | 0 |
| B | 0 1         | 0 1 0 | C | 1 1         | 0 |
| B | 0 1         | 0 1 1 | A | 0 0         | 0 |
| B | 0 1         | 1 0 0 | C | 1 1         | 0 |
| B | 0 1         | 1 0 1 | A | 0 0         | 0 |
| B | 0 1         | 1 1 0 | A | 0 0         | 0 |
| B | 0 1         | 1 1 1 | A | 0 0         | 0 |
| - | 1 0         | 0 0 0 | - | - -         | - |
| - | 1 0         | 0 0 1 | - | - -         | - |
| - | 1 0         | 0 1 0 | - | - -         | - |
| - | 1 0         | 0 1 1 | - | - -         | - |
| - | 1 0         | 1 0 0 | - | - -         | - |
| - | 1 0         | 1 0 1 | - | - -         | - |
| - | 1 0         | 1 1 0 | - | - -         | - |
| - | 1 0         | 1 1 1 | - | - -         | - |
| C | 1 1         | 0 0 0 | A | 0 0         | 0 |
| C | 1 1         | 0 0 1 | A | 0 0         | 1 |
| C | 1 1         | 0 1 0 | A | 0 0         | 0 |
| C | 1 1         | 0 1 1 | A | 0 0         | 0 |
| C | 1 1         | 1 0 0 | A | 0 0         | 0 |
| C | 1 1         | 1 0 1 | A | 0 0         | 0 |
| C | 1 1         | 1 1 0 | A | 0 0         | 0 |
| C | 1 1         | 1 1 1 | A | 0 0         | 1 |

Tabelle di Karnaugh

- Tabelle per $s_1$ settato a zero ($s_1 = 0$)

    - Tabella per $S_{1,s_1=0}$:

        | $\mathbf{s_0}$, a \ b, c   | 0 0 | 0 1 | 1 1 | 1 0 |
        |:--------------------------:|:---:|:---:|:---:|:---:|
        | 0 0                        |  0  |  0  |  0  |  0  |
        | 0 1                        |  0  |  0  |  0  |  0  |
        | 1 1                        |  1  |  0  |  0  |  0  |
        | 1 0                        |  0  |  0  |  0  |  1  |

        $ S_{1,s_1=0} = (s_0 \cdot a \cdot \bar{b} \cdot \bar{c}) + (s_0 \cdot \bar{a} \cdot b \cdot \bar{c}) $

    - Tabella per $S_{0,s_1=0}$:

        | $\mathbf{s_0}$, a \ b, c   | 0 0 | 0 1 | 1 1 | 1 0 |
        |:--------------------------:|:---:|:---:|:---:|:---:|
        | 0 0                        |  1  |  0  |  0  |  0  |
        | 0 1                        |  0  |  0  |  0  |  1  |
        | 1 1                        |  1  |  0  |  0  |  0  |
        | 1 0                        |  0  |  0  |  0  |  1  |

        $ S_{0,s_1=0} = (\bar{s_0} \cdot \bar{a} \cdot \bar{b} \cdot \bar{c}) + (\bar{s_0} \cdot a \cdot b \cdot \bar{c}) + (s_0 \cdot a \cdot \bar{b} \cdot \bar{c}) + (s_0 \cdot \bar{a} \cdot b \cdot \bar{c}) $


    - Tabella per $Z_{s_1=0}$:

        | $\mathbf{s_0}$, a \ b, c   | 0 0 | 0 1 | 1 1 | 1 0 |
        |:--------------------------:|:---:|:---:|:---:|:---:|
        | 0 0                        |  0  |  0  |  0  |  0  |
        | 0 1                        |  0  |  0  |  0  |  0  |
        | 1 1                        |  0  |  0  |  0  |  0  |
        | 1 0                        |  0  |  0  |  0  |  0  |

        $ Z_{s_1=0} = 0 $

- Tabelle per $s_1$ settato a uno ($s_1 = 1$)

    - Tabella per $S_{1,s_1=1}$:

        | $\mathbf{s_0}$, a \ b, c   | 0 0 | 0 1 | 1 1 | 1 0 |
        |:--------------------------:|:---:|:---:|:---:|:---:|
        | 0 0                        |  -  |  -  |  -  |  -  |
        | 0 1                        |  -  |  -  |  -  |  -  |
        | 1 1                        |  0  |  0  |  0  |  0  |
        | 1 0                        |  0  |  0  |  0  |  0  |

        $S_{1,s_1=1} = 0 $

    - Tabella per $S_{0,s_1=1}$:

        | $\mathbf{s_0}$, a \ b, c   | 0 0 | 0 1 | 1 1 | 1 0 |
        |:--------------------------:|:---:|:---:|:---:|:---:|
        | 0 0                        |  -  |  -  |  -  |  -  |
        | 0 1                        |  -  |  -  |  -  |  -  |
        | 1 1                        |  0  |  0  |  0  |  0  |
        | 1 0                        |  0  |  0  |  0  |  0  |

        $S_{0,s_1=1} = 0 $

    - Tabella per $Z_{s_1=1}$:

        | $\mathbf{s_0}$, a \ b, c   | 0 0 | 0 1 | 1 1 | 1 0 |
        |:--------------------------:|:---:|:---:|:---:|:---:|
        | 0 0                        |  -  |  -  |  -  |  -  |
        | 0 1                        |  -  |  -  |  -  |  -  |
        | 1 1                        |  0  |  0  |  1  |  0  |
        | 1 0                        |  0  |  1  |  0  |  0  |

        $Z_{s_1=1} = (\bar{a} \cdot \bar{b} \cdot c) + (a \cdot b \cdot c) $

Notiamo che per ogni variabile di uscita della rete, cioè $S_1$, $S_2$ e $Z$, sono state ricavate due espressioni distinte, corrispondenti ai due casi del valore della variabile più significativa dello stato attuale, $s_1$.

Per selezionare l’espressione corretta da utilizzare impieghiamo un **multiplexer a due ingressi** per ogni variabile. Ogni multiplexer prende in ingresso i due valori calcolati dalle sottoreti corrispondenti ai due casi $s_1 = 0$ e $s_1 = 1$, e sceglie quale uscita fornire in base al valore di $s_1$.

![Rete Logica](2025-09-10%20-%20Quarto%20appello%20-%20Rete%20Logica.jpg)

---
