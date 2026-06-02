
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

- a0 (x10) = 0x0040000
- a1 (x11) = 0x0040010
- a2 (x12) = 16

Si immagini di eseguire il programma così modificato su una CPU RISCV dotata di **instruction cache** 2-way associative con 2 bit di INDEX e 4 bit di OFFSET.

Qual è il miss rate risultante per la **cache istruzioni**?

#### RISOLUZIONE

Modifica programma esercizio 2:

```asm
0x3FFC     add  x18, x0, x0     # i = 0
0x4000 L1: bge  x18, x12, L2    # Goto L2 if i >= 16
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

Controllo utilizzo cache prima del ciclo:

- 0x3FFC = 0011 1111 11|11| 1100 → **compulsory miss**

Controllo utilizzo cache 1° iterazione:

- 0x4000 = 0100 0000 00|00| 0000 → **compulsory miss**
- 0x4004 = 0100 0000 00|00| 0100 → **hit**
- 0x4008 = 0100 0000 00|00| 1000 → **hit**
- 0x400C = 0100 0000 00|00| 1100 → **hit**
- 0x4010 = 0100 0000 00|01| 0000 → **compulsory miss**
- 0x4014 = 0100 0000 00|01| 0100 → **hit**
- 0x4018 = 0100 0000 00|01| 1000 → **hit**

Controllo utilizzo cache 2°-16° iterazione:

- 0x4000 = 0100 0000 00|00| 0000 → **hit**
- 0x4004 = 0100 0000 00|00| 0100 → **hit**
- 0x4008 = 0100 0000 00|00| 1000 → **hit**
- 0x400C = 0100 0000 00|00| 1100 → **hit**
- 0x4010 = 0100 0000 00|01| 0000 → **hit**
- 0x4014 = 0100 0000 00|01| 0100 → **hit**
- 0x4018 = 0100 0000 00|01| 1000 → **hit**

Controllo utilizzo cache fuori dal ciclo:

- 0x4000 = 0100 0000 00|00| 0000 → **hit**
- 0x401C = 0100 0000 00|01| 1100 → **hit**

Quindi:

- Totale istr = 1 + 7 * 16 + 2 = 115
- Totale hits = 112.
- Totale miss = 3.

$$ \text{Instruction Cache Miss Rate} = \frac{\text{Total Misses}}{\text{Total Instructions}} = \frac{3}{115} \approx 0.026 = 2.6\% $$
