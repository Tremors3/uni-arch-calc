
#### QUESITO

Si consideri il seguente programma C:

```c
clear1 (int array[], int size) { 
    int i; 
    for (i = 0; i < size; i+= 1) 
        array[i] = 0; 
} 
```

a. Si scriva il corrispondente programma assembly RISC-V, assumendo che gli argomenti vengano forniti in x10 e x11.

b. Si consideri un datapath privo di logica di rilevamento degli hazard, di stallo e di forwarding. Si modifichi manualmente il programma perché esegua correttamente su tale datapath.

#### RISOLUZIONE

a. Si scriva il corrispondente programma assembly RISC-V, assumendo che gli argomenti vengano forniti in x10 e x11:

```asm
# x10 = array
# x11 = size

clear1:
    add x29, x0, x0         # i = 0
FORL:
    slli x5, x29, 2         # x5 = i * 4
    addi x5, x5, x10        # x5 = array + (i * 4)
    sw x0, 0(x5)            # array[i] = 0
    addi x29, x29, 1        # i++
    blt x29, x11, FORL      # Goto FORL while (i < size)
```

b. Si consideri un datapath privo di logica di rilevamento degli hazard, di stallo e di forwarding. Si modifichi manualmente il programma perché esegua correttamente su tale datapath.

```asm
clear1:
    add x29, x0, x0         # i = 0
    nop
    nop
FORL:
    slli x5, x29, 2         # x5 = i * 4
    nop
    nop
    addi x5, x5, x10        # x5 = array + (i * 4)
    nop
    nop
    sw x0, 0(x5)            # array[i] = 0
    addi x29, x29, 1        # i++
    nop
    nop
    blt x29, x11, FORL      # Goto FORL while (i < size)
```

- Le istruzioni `add`, `slli` e `addi` **scrivono tutte su un registro**. In assenza di una logica per la gestione dei data hazard, è necessario inserire **due istruzioni `nop`** dopo ciascuna di esse per garantire il corretto avanzamento della pipeline.
