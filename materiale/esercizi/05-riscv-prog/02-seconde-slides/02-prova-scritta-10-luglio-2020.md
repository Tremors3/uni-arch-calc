
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
fun:  addi s0, zero, 0      // s0 = 0
 addi s1, zero, 1           // s1 = 1
 add t0, zero, a0           // t0 = n (a0)
loop: beq s0, t0, exit      // Goto exit if (s0 == t0)
 add s1, s1, s1             // s1 = s1 + s1
 addi s0, s0, 1             // s0++
 jal zero, loop             // Goto loop
exit: add a0, zero, s1      // a0 (result) = s1
 jalr zero, 0(ra)           // Return to caller
```

Assumento che n = 3, s1 incrementerà in questo modo: 1, 2, 4, 8. 
Cioè **`2^n`**.