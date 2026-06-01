#### QUESITO

Si consideri il seguente stralcio di codice RISC-V, scritto per eseguire su una pipeline priva di logica di detection dei data hazards e forwarding: 

```asm
slli t0,t0,2
nop
nop
add t0,t0,x10
add t1,x11,x12
sub t2,x13,x14
nop
nop
mul t1,t1,t2
nop
nop
add t1,t0,t1
ld  t2,0(t0)
nop
nop
sd  t2,0(t1)
```

- a) Il codice esegue in 20 cicli (considerando la pipeline inizialmente vuota)
- b) È possibile riordinare il codice per ridurre il numero di NOP. Così facendo si riduce il numero di cicli a 16
- c) Se eseguito su una pipeline dotata di logica di detection e forwarding dei data hazards il codice non richiede NOP
- d) Non è possibile riordinare il codice per ridurre il numero di NOP

#### RISOLUZIONE

- a) **VERO** $-$ In una pipeline senza hazard detection e forwarding, il codice originale impiega **20 cicli**. La prima istruzione richiede 5 cicli per riempire la pipeline.

- b) **VERO** $-$ Riordinando le istruzioni è possibile ridurre le `nop` e scendere a **16 cicli**:
  
    ```asm
    slli t0,t0,2        #  5
    add t1,x11,x12      #  6
    sub t2,x13,x14      #  7
    add t0,t0,x10       #  8
    nop                 #  9
    mul t1,t1,t2        # 10
    ld  t2,0(t0)        # 11
    nop                 # 12
    add t1,t0,t1        # 13
    nop                 # 14
    nop                 # 15
    sd  t2,0(t1)        # 16
    ```

- c) **FALSO** $-$ Con hazard detection e forwarding, resta comunque un **load-use hazard** tra `ld t2,0(t0)` e `sd t2,0(t1)`, che richiede una `nop`. Tuttavia, nel codice riordinato del punto $b$, è possibile eliminare tutte le `nop`.

- d) **FALSO** $-$ Il riordino del punto $b$ dimostra che i `nop` si possono ridurre.
