
| Register(s)    | Alt.   | Description                                  |
|----------------|--------|----------------------------------------------|
| x0             | zero   | The zero register                            |
| x1             | ra     | The return address register                  |
| x2             | sp     | The stack pointer                            |
| x5-x7, x28-x31 | t0-t6  | The temporary registers                      |
| x8-x9, x18-x27 | s0-s11 | The saved registers                          |
| x10-17         | a0-a7  | The argument registers (a0-a1 return values) |

#### Quesito:

In RISC-V ci sono due modi di rappresentare i registri.
Si convertano le seguenti istruzioni da un formato all’altro.

1. add s0, zero, a1
2. or x18, x1, x30

#### Soluzione:

1. add x8, x0, x11
2. or s2, ra, t5
