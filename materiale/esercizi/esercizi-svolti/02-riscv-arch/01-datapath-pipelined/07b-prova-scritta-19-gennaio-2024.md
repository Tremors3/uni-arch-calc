
#### [LINK FIGURA](12a-prova-scritta-19-gennaio-2024.png)

#### QUESITO

Scrivere una possibile sequenza di 5 istruzioni che produca i seguenti valori dei segnali di controllo di una pipeline RISC-V:

- PCSrc = 1
- RegWrite = 1
- Write Register = 1
- ALUSrc = 1
- ALU CTRL = 0110
- MemRead = 0
- MemWrite = 1
- MemToReg = 1

#### RISOLUZIONE

```
WB:  ld x1, 0(x20)          # MemToReg = 1, RegWrite = 1, Write Register = 1
MEM: sd x7, 0(x2)           # MemRead = 0, MemWrite = 1                         (in conflitto con la successiva...)
MEM: beq x20, x21, LBL2     # PCSrc = 1                                         (...in conflitto con la precedente)
EX:  sub x5, x20, x22       # ALU CTRL = 0110 (sub)                             (in conflitto con la successiva...)
EX:  addi x8, x9, x28       # ALUSrc = 1 (IMM/LBL)                              (...in conflitto con la precedente)
ID:  and x5, x30, x31       # Any instruction
IF:  or x6, x31, x30        # Any instruction
```

| IF                | ID                 | EX                 | MEM                  | WB              |
|-------------------|--------------------|--------------------|----------------------|-----------------|
| `or x6, x31, x30` | `and x5, x30, x31` | `sub x5, x20, x22` | `beq x20, x21, LBL2` | `ld x1, 0(x20)` |
| //                | //                 | `addi x8, x9, x28` | //                   | //              |
| //                | //                 | //                 | `sd x7, 0(x2)`       | //              |

## Note

Alcuni segnali sono mutualmente esclusivi, come:

- ALU CTRL = 0110 (sub) e ALUSrc = 1;
- MemWrite/MemRead = 1 e PCSrc = 1.

In questi casi si scelgono due istruzioni che rispettano i rispettivi segnali e si fa notare che i segnali sono in conflitto.
