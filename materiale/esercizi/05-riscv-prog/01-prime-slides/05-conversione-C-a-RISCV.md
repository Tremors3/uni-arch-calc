
#### Quesito:

Si converta il seguente frammento di codice C in assembly RISC-V:

```c
// s0 -> a, s1 -> b 
int a = 5, b = 10;
if(a + a == b) {
 a = 0;
} else {
 b = a - 1;
}
```

#### Soluzione:

```asm
_main:
    addi s0, zero, 5
    addi s1, zero, 10
    add t0, s0, s0
    bne t0, s1, _else
    xor s0, zero, zero
    beq zero, zero, _exit
_else:
    addi s1, s0, -1
_exit:
```

**Ricorda:**

1) Se voglio tradurre una condizione if-else da linguaggio C a RISC-V,
allora devo invertire la condizione:

    ```
    oper1 <  oper2  -->  oper1 >= oper2  :  bge
    oper1 >  oper2  -->  oper2 >= oper1  :  bge
    oper1 <= oper2  -->  oper2 <  oper1  :  blt
    oper1 >= oper2  -->  oper1 <  oper2  :  blt
    oper1 == oper2  -->  oper1 != oper2  :  beq
    oper1 == oper2  -->  oper1 != oper2  :  bne
    ```

2) Se voglio inizializzare un registro a zero posso farlo in diversi modi.
   Ma il metodo consigliato dal prof usa lo XOR tra x0 e x0:

    ```
    xor s0, zero, zero
    and s0, zero, zero
    addi s0, zero, 0
    ...
    ```
