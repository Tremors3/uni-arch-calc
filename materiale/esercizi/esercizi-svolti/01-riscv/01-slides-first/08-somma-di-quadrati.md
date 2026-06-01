
#### Quesito:

Si scriva una funzione sumSquare che prende in ingresso 
un intero n e ritorna la somma mostrata sotto. Se n è non 
positivo la funzione ritorna 0

```c
n^2 + (n-1)^2 + n-2^2 + ... + 1^2
```

Si assuma di avere a disposizione una funzione square che 
prende in ingresso un intero e restituisce il suo quadrato. 
Implementare sumSquare usando square come subroutine.

#### Soluzione:

**In C**

```c
int sumSquare(int n) {
    int sum = 0;
    for (; n > 0; n-- ) {
        sum += square(n);
    }
    return sum;
}
```

**In RiscV:**

```asm
sumSquare:
    addi sp, sp, -12    # Make space for three words in the stack
    sw ra, 0(sp)        # Store ra
    sw s0, 4(sp)        # Store s0
    sw s1, 8(sp)        # Store s1

    add s0, zero, a0    # Set s0 equal to the parameter n
    add s1, zero, zero  # Set s1 (accumulator) equal to 0
loop:
    bge zero, s0, end   # Branch if s0 is not positive
    add a0, zero, s0    # Set a0 to the value in s0, setting up
                        # args for call to function square
    jal ra, square      # Call the function square
    add s1, s1, a0      # Add the returned value into s1
    addi s0, s0, -1     # Decrement s0 by 1
    jal zero, loop      # Jump back to the loop label
end:
    add a0, zero, s1    # Set a0 to s1, the desired return value

    lw ra, 0(sp)        # Restore ra
    lw s0, 4(sp)        # Restore s0
    lw s1, 8(sp)        # Restore s1
    addi sp, sp, 12     # Free space in the stack
    jr ra
```

**Ricorda:**

1) Stai molto **attento alle condizioni dei loop**. Ricorda che in RISCV la condizione deve far uscire dal loop! Al contrario del C, nel quale la condizione è posta per far continuare il loop.

2) Ricordati di **allocare spazio nello stack** e di salvare le variabili saved (s0-s11) che utilizzi nello stack prima di utilizzarle effettivamente. Successivamente ricordati di **disallocarlo** e ritornare al punto precedente la chiamata.

    ```
    fun:
        addi sp, sp, -12    # Make space for three words in the stack
        sw ra, 0(sp)        # Store ra
        sw s0, 4(sp)        # Store s0
        sw s1, 8(sp)        # Store s1
    body:
        ...
    end:
        add a0, zero, ...   # Set a0 to s1, the desired return value
        lw ra, 0(sp)        # Restore ra
        lw s0, 4(sp)        # Restore s0
        lw s1, 8(sp)        # Restore s1
        addi sp, sp, 12     # Free space in the stack
        jr ra
    ```

3) Per **chiamare una subroutine** (funzione) basta usare l'istruzione jal ed indicare il registro x1 (ra) come destinazione del PC. Il risultato lo troveremo in a0.

    ```
    addi a0, zero, s0   # Setto l'argomento alla funzione
    jal ra, square      # Chiamo la funzione
    addi s0, zero, a0   # Salvo il risultato in un registro
    ```
