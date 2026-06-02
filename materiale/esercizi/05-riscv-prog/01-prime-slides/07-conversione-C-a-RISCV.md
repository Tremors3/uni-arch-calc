
#### Quesito:

Si converta il seguente frammento di codice C in assembly RISC-V:

```c
// s0 -> n, s1 -> sum
// assume n > 0 to start
for (int sum = 0; n > 0; n--) 
{
    sum += n;
}
```

#### Soluzione:

```asm
    addi s1, zero, 0     # sum = 0 (accumulatore)
loop:
    bge zero, s0, exit   # se sum <= 0 salta a exit
    add s1, s1, s0       # sum += n
    addi s0, s0, -1      # n -= 1
    jal zero, loop       # salto incondizionato a loop
exit:
```

**Ricorda:**

1) Qui: `jal` significa **salta all'etichetta loop** e **salva l'indirizzo di ritorno nel registro specificato**.

    Il **primo operando** (`zero`) è il registro di destinazione, cioè dove salvare il return address (il PC successivo). Usando `zero` (cioè `x0`), dici al processore di non salvare l'indirizzo di ritorno, perché **`x0` è sempre zero e non può essere modificato**.
    
    In pratica: è un **salto incondizionato puro**, senza effetti collaterali.
