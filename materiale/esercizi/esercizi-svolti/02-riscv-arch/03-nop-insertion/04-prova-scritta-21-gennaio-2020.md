#### QUESITO

Si consideri il seguente programma assembly RISC-V. Supponendo di eseguire il codice su una versione della pipeline a cinque stadi che non gestisce i data hazards: 

```asm
ld   x28, 8(x10) 
addi x28, x28, -10 
sd   x28, 8(x10)   
sub  x15, x12, x11   
ld   x13, 4(x15) 
or   x13, x15, x13 
add  x2, x6, x7 
ld   x12, 0(x2) 
add  x6, x2, x12  
```

- a. si inseriscano delle NOP per garantirne il funzionamento corretto.
- b. assumendo che la pipeline sia già piena quando si esegue la prima istruzione, si dica quanti cicli impiega a eseguire questo codice.
- c. si riordini, se possibile, il codice per rimuovere eventuali NOP
- d. si dica quanti cicli impiega il codice riordinato a eseguire

#### RISOLUZIONE

- a:

    ```asm
    ld   x28, 8(x10)
    nop
    nop
    addi x28, x28, -10
    nop
    nop 
    sd   x28, 8(x10)
    sub  x15, x12, x11
    nop
    nop
    ld   x13, 4(x15)
    nop
    nop
    or   x13, x15, x13
    add  x2, x6, x7
    nop
    nop
    ld   x12, 0(x2)
    nop
    nop
    add  x6, x2, x12
    ```

- b: **21 cicli, mentre se si considera la pipeline inizialmente vuota allora sono 21 + 4 = 25 cicli.**

- c:

    ```asm
    ld   x28, 8(x10)
    sub  x15, x12, x11
    add  x2, x6, x7
    addi x28, x28, -10
    ld   x13, 4(x15)
    ld   x12, 0(x2) 
    sd   x28, 8(x10)
    or   x13, x15, x13
    add  x6, x2, x12
    ```

- d: **9 cicli, mentre se si considera la pipeline inizialmente vuota allora sono 9 + 4 = 13 cicli.**
