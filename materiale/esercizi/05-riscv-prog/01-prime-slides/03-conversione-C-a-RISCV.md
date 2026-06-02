
#### Quesito:

Si converta il seguente frammento di codice C in assembly RISC-V:

```c
// s0 -> a, s1 -> b
// s2 -> c, s3 -> z
int a = 4, b = 5, c = 6, z;
z = a + b + c + 10;
```

#### Soluzione:

```asm
addi s0, zero, 4
addi s1, zero, 5
addi s2, zero, 6
add  s3, s0, s1
add  s3, s3, s2
addi s3, s3, 10
```

**Ricorda:**

1) Se vuoi inizializzare un registro ad un immediato a scelta, devi sfruttare il registro x0 (zero) ed un'operazione come la addi (add immediate):

    ```
    addi a0, zero, 100
    ```
