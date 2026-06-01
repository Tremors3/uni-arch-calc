
#### QUESITO

Assumendo che ci sia un array 

```C 
int arr[6] = {3, 1, 4, 1, 5, 9}
```

il cui primo elemento risiede all’indirizzo 0xBFFFFF00, e che questo indirizzo sia  memorizzato nel registro s0:

- a) Dire cosa fa il seguente frammento di programma assembly. Si noti che l’istruzione `SLTI rd, rs1, imm` (set less than immediate) mette il valore 1 nel registro rd se rs1 è minore dell’immediato, altrimenti ci mette il valore 0.

```
    add t0, x0, x0      # i = 0
loop:
    slti t1, t0, 6      # t1 = (i < 6) ? 1 : 0
    beq t1, x0, end     # Goto END if (t1 == 0)
    slli t2, t0, 2      # t2 = (i * 4)
    add t3, s0, t2      # t3 = arr + (i * 4)
    lw t4, 0(t3)        # t4 = arr[i]
    sub t4, x0, t4      # t4 = - arr[i]
    sw t4, 0(t3)        # arr[i] = - arr[i]
    addi t0, t0, 1      # i++
    jal x0, loop        # Goto LOOP
end:
```

#### RISOLUZIONE

- Il programma rimpiazza ciascun elemento dell'array con il proprio negato.
- Risultato:
    ```C 
    int arr[6] = {-3, -1, -4, -1, -5, -9}
    ```
