
#### QUESITO

Si consideri il seguente stralcio di codice assembly RISC-V

```asm
.globl main
.data
    arr: .word 10, 3, 4, 2, 1
    n: .word ??? 
.text
main:
    la t0, arr
    la t1, n
    lb t1, 0(t1)
    lw t2, 0(t0)
ciclo:
    addi t1, t1, -1
    beq t1, zero, exit
    slli t3, t1, 2
    add t3, t0, t3
    lw t3, 0(t3)
    sub t2, t2, t3 
    j ciclo
exit:
```

Sapendo che il valore contenuto nel registro t2 al termine del programma è 10, dire che valore ha la variabile n. 
**Motivare la risposta**.

#### RISOLUZIONE

- Perchè il risultato rimanga invariato 10, il ciclo non deve compiere iterazioni.
- Perchè il ciclo non compia iterazioni il valore di n deve essere 1.
- Risposta:
    
    $$ n = 1 $$