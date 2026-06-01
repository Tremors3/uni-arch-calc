
#### QUESITO

Si consideri il seguente stralcio di codice assembly RISCV:

```
fun:  addi s0, zero, 0
 addi s1, zero, 1
 add t0, zero, a0
loop: beq s0, t0, exit
 add s1, s1, s1
 addi s0, s0, 1
 jal zero, loop
exit: add a0, zero, s1
 jalr zero, 0(ra)
```

e si assuma che corrisponda all’implementazione 
di una funzione la cui interfaccia C è:
    
    int fun (int n);

Cosa ritorna la funzione?

#### RISOLUZIONE

```
fun:  
    addi s0, zero, 0    # i = 0
    addi s1, zero, 1    # sum = 1
    add t0, zero, a0    # temp = n
loop: 
    beq s0, t0, exit    # Goto exit if (i == n)
    add s1, s1, s1      # sum *= 2
    addi s0, s0, 1      # i++
    jal zero, loop      # Goto loop
exit: 
    add a0, zero, s1    # res = sum
    jalr zero, 0(ra)    # Return to caller
```

- Il codice esegue n iterazioni.
- Per ogni iterazione la variabile sum viene moltiplicata per 2.
- Esempio, con n = 3, abbiamo: sum = 1, 2, 4, 8
- In pratica stiamo calcolando:
    $$ res = 2^n $$