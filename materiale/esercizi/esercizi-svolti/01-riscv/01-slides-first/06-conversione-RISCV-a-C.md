
#### Quesito:

Si converta il seguente frammento di codice C in assembly RISC-V:

```asm
addi s0, zero, 0
    addi s1, zero, 1
    addi t0, zero, 30
loop:
    beq s0, t0, exit
    add s1, s1, s1
    addi s0, s0, 1
    jal zero, loop
exit:

```

#### Soluzione:

```c
int s1 = 1;
for (int s0 = 0, s0 < 30, s0++) {
    s1 *= 2;
}
```

**Ricorda:**

1) Nella traduzione da RISCV a C si possono omettere alcuni passaggi per semplificare il codice C. 
   
   In questo caso infatti nella soluzione non viene istanziata la variabile t0 e assegnato l'immediato 30, ma il 30 viene messo direttamente come upper bound del ciclo. 
   
   In'oltre si possono applicare delle trasformazioni come:
    
    ```
    add s0, s0, s0  -->  s0 *= 2
    ```
