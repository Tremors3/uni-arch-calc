
#### QUESITO

Assumendo che ci sia un array int arr[6] = {3, 1, 4, 1, 5, 9} il cui primo 
elemento risiede all’indirizzo 0xBFFFFF00, e che questo indirizzo sia 
memorizzato nel registro s0:

- a) Dire cosa fa il seguente frammento di programma assembly. Si noti che l’istruzione `SLTI rd, rs1, imm` (set less than immediate) mette il valore 1 nel registro rd se rs1 è minore dell’immediato, altrimenti ci mette il valore 0.

```
 add t0, x0, x0
loop: slti t1, t0, 6
 beq t1, x0, end
 slli t2, t0, 2
 add t3, s0, t2
 lw t4, 0(t3)
 sub t4, x0, t4
 sw t4, 0(t3)
 addi t0, t0, 1
 jal x0, loop
end:
```

#### RISOLUZIONE

```
 add t0, x0, x0         // t0 = 0
loop: slti t1, t0, 6    // (t0 < 6) ? t1 = 1 : t1 = 0
 beq t1, x0, end        // Goto end if (t1 == 0)
 slli t2, t0, 2         // t2 = t0 * 4
 add t3, s0, t2         // t3 = t2 + s0     (array element address)
 lw t4, 0(t3)           // t4 = array[i]
 sub t4, x0, t4         // t4 = -t4         (calcola il negato)
 sw t4, 0(t3)           // array[i] = t4
 addi t0, t0, 1         // t0++
 jal x0, loop           // Goto loop
end:
```

Si esce dal ciclo quando t1 == 0. Considerando che t1 è uguale a zero quando
t0 diventa uguale o maggiore di 6. t0 viene incrementato di 1 ad ogni iterazione.

**Lo stralcio di codice Rimpiazza ciscun elemento dell'array con il proprio negato.**