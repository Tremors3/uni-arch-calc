
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
        reverse[l-1-i] = str[i];
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

```
# x10 = str
# x11 = rev
revert:
    addi x2, x2, -12    # Allocate stack
    sw x1, 0(x2)        # Save ra
    sw x20, 4(x2)       # Save s4   (str)
    sw x21, 8(x2)       # Save s5   (rev)

    add x20, x0, x10    # x20 = str
    add x21, x0, x11    # x21 = rev

    jal x1, strlen      # x10 = strlen(str)
    add x30, x0, x10    # x30 = strlen(str) 

    add x10, x0, x20    # x10 = str
    add x11, x0, x21    # x11 = rev

    lw x1, 0(x2)        # Restore ra
    lw x20, 4(x2)       # Restore s4
    lw x21, 8(x2)       # Restore s5
    addi x2, x2, 12     # Deallocate stack

    add x29, x0, x0     # i = 0
WHILE:
    slli x5, x29, 2     # x5 = (i * 4)
    add x5, x5, x10     # x5 = str + (i * 4)
    lw x5, 0(x5)        # x5 = str[i]

    bge x5, x0, END     # Goto END if (str[i] == '\0')

    addi x6, x29, 1     # x6 = i + 1
    sub x6, x30, x6     # x6 = l - i - 1
    slli x6, x6, 2      # x6 = (l - i - 1) * 2
    add x6, x6, x10     # x6 = str + (l-i-1) * 2
    sw x5, 0(x6)        # str[l-i-1] = str[i]

    addi x29, x29, 1    # i++
    jal x0, WHILE       # Continue WHILE
END:
    slli x7, x30, 2     # x7 = (l * 2)
    add x7, x7, x10     # x7 = str + (l * 2)
    sw x0, 0(x7)        # str[l] = '\0'

    # ret val already x10

    lw x1, 0(x2)        # restore ra
    lw x20, 4(x2)       # Restore s4
    lw x21, 8(x2)       # Restore s5
    addi x2, x2, 12     # Deallocate stack

    jalr x0, 0(x1)      # return to caller
```
