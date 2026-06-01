
#### QUESITO

Si scriva in assembly RISC-V una funzione `revert` che prende in ingresso due stringhe (array di caratteri) `str` e `reverse` e copi in reverse la stringa `str` al contrario.

Ad esempio, se str contiene la stringa "*Pippo*", la funzione mette in `reverse` la stringa "*oppiP*". Specificamente, il codice C della funzione da realizzare è il seguente:

```c
char *revert (char *str, char *reverse) 
{ 
    int i = 0;
    int l = strlen (str);
    
    while (str[i] != '\0')
    {
        reverse[l-1-i]= str[i];
        i++;
    }

    reverse[l] = '\0';

    return reverse;
}
```

Implementare la funzione rispettando le convenzioni sull'utilizzo dei registri per le chiamate a funzione. Gestire opportunamente lo stack nel rispetto della calling convention RISC-V.

Si ricorda che la funzione `strlen` ha la seguente sintassi e semantica:

```c
size_t strlen(const char *s);
```

SEMANTICA: La funzione `strlen()` calcola la lunghezza della stringa `s`, (inteso come il numero di caratteri dell'array puntato da `s`) escluso il terminatore `'\0'`.
Si ricorda anche che il tipo `size_t` è equivalente al tipo int in termini di dimensioni in bytes.

NON occorre implementare la funzione `strlen`, solo invocarla rispettando le convenzioni sull'utilizzo dei registri per le chiamate a funzione.

#### RISOLUZIONE

```asm

// x10 = str
// x11 = rev

revert:
    // Allocate
    addi x2, x2, -16    // Allocate stack
    sd x20, 0(x2)       // Save s4 (per str)    // ARGUMENT
    sd x21, 8(x2)       // Save s5 (per rev)    // ARGUMENT

    // Store arguments
    add x20, x0, x10    // x20 = str
    add x21, x0, x11    // x21 = rev

    // Call function
    jal x1, strlen      // Call strlen
    add x30, x0, x10    // x30 = l
    addi x31, x30, -1   // x31 = l - 1

    // Restore arguments
    add x10, x0, x20    // x10 = str
    add x11, x0, x21    // x11 = rev

    // Deallocate
    ld x20, 0(x2)       // Restore s4
    ld x21, 8(x2)       // Restore s5
    addi x2, x2, 16     // Deallocate stack

    add x5, x0, x0      // i = 0
LOOP:
    add x6, x5, x10     // x6 = str + (i * 1)
    lb x6, 0(x6)        // x6 = str[i]
    
    beq x6, x0, END     // Goto END if (str[i] == 0)

    sub x7, x31, x5     // x7 = l - 1 - i
    add x7, x7, x11     // x7 = rev + (l - 1 - i)
    sb x6, 0(x7)        // rev[l-1-i] = str[i]

    addi x5, x5, 1      // i ++
    jal x0, LOOP        // Goto LOOP
END:
    add x18, x30, x11   // x18 = rev + (l * 1)
    sw x0, 0(x18)       // rev[l] = '\0'

    jalr x0, 0(x1)      // Return to caller
```
