
#### QUESITO

Programma assembly:

```asm
0x4000 L1: beq  x8, x0, L2
0x4004     add  x9, x18, x10
0x4008     sb   x11, 0(x9)
0x400C     addi x18, x18, 1
0x4010     jal  x0, L1
0x4014 L2: jalr x0, 0(x1)
```

Si modifichi il programma assembly fornito. considerando i valori iniziali:

- a0 (x10) = 0x8000
- a1 (x11) = 0x9000
- a2 (x12) = 8

Si immagini di eseguire il programma così modificato su una CPU RISCV dotata di **data cache** 2-way associative con 2 bit di INDEX e 4 bit di OFFSET.

Qual è il miss rate risultante per la **cache dati**?

#### RISOLUZIONE

Modifica programma esercizio 2:

```asm
0x3FFC     add  x18, x0, x0     # i = 0
0x4000 L1: bge  x18, x12, L2    # Goto L2 if i >= 8
0x4004     add  x9, x18, x10    # x9 = arr1 + (i * 1)
0x4008     add  x8, x18, x11    # x8 = arr2 + (i * 1)
0x400C     lb   x8, 0(x8)       # x8 = arr2[i]
0x4010     sb   x8, 0(x9)       # arr1[i] = arr2[i]
0x4014     addi x18, x18, 1     # i++
0x4018     jal  x0, L1          # Goto L1
0x401C L2: jalr x0, 0(x1)       # Return to Caller
```

Parametri della Cache:

- Tipo: 2 way.
- Indirizzo: 32 bit.
- Index: 2 bit → ci sono 4 set.
- Offset: 4 bit → Linea: 2^4 = 16 Byte.

Calcolo numero accessi totali:

- Numero di iterazioni: 8.
- Numero di accessi per iterazione 2.
- Totale accessi: 8 * 2 = 16.

Controllo utilizzo cache 1° iterazione:

- 0x8000 = 1000 0000 00|00| 0000 → **compulsory miss**
- 0x9000 = 1001 0000 00|00| 0000 → **compulsory miss**

Controllo utilizzo cache 2°-8° iterazione:

- 0x800X = 1000 0000 00|00| XXXX → **hit**
- 0x900X = 1001 0000 00|00| XXXX → **hit**

Calcolo del missrate:

- Totale: 16
- Hits:   14
- Misses: 1 + 1 = 2

$$ \text{Data Cache Miss Rate} = \frac{\text{Total Misses}}{\text{Total Data Accesses}} = \frac{2}{16} = 12.5\% $$
