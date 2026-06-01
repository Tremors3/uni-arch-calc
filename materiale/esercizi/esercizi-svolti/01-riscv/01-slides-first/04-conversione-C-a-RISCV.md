
#### Quesito:

Si converta il seguente frammento di codice C in assembly RISC-V:

```c
// s0 -> int * p = intArr;
// s1 -> a;
*p = 0;
int a = 2;
p[1] = p[a] = a;
```

#### Soluzione:

```asm
sw zero, 0(s0)
addi s1, zero, 2
sw s1, 4(s0)
slli t0, s1, 2
add t0, t0, s0
sw s1, 0(t0)
```

**Ricorda:**

1) Per accedere in riscv all'N-esimo elemento di un array:
    
    ```
    Offset  = Indice (numero) * Dimensione Singolo Elemento (bytes)
    Address = Base address (bytes) + Offset (bytes)
    ```
