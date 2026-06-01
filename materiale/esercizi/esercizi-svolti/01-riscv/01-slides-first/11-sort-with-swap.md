#### Quesito:

Scrivi una funzione non-leaf sort in Risc-V assembly che riordini gli elementi di un array, e una funzione leaf swap che scambia due elementi adiacenti dello stesso array. La funzione swap è chiamata dalla funzione sort per effettuare gli scambi.

#### Soluzione:

```C
void swap(long long int *a, int j) {
    long long int temp = a[j];
    a[j] = a[j+1];
    a[j+1] = temp;
}

void sort(long long int* a, int n) {
    
    for (int i = 0; i < n; i++)
        for (int j = i - 1;
            (j >= 0) && (a[j] > a[j+1]); 
            j--) 
        {
            swap(a, j)
        }
}
```

```asm
# x10 = a
# x11 = j
# x6  = temp
swap:
    slli x5, x11, 3         # x5 = j * 8
    add x5, x5, x10         # x5 = a + (j * 8)
    ld x6, 0(x5)            # x6 (temp) = a[j]
    ld x7, 8(x5)            # x7 = a[j+1]
    sd x7, 0(x5)            # a[j] = a[j+1]
    sd x6, 8(x5)            # a[j+1] = x6 (temp)
    jalr x0, 0(x1)          # Return to caller

# x10 = a
# x11 = n
# x19 = i
# x20 = j
sort:
    # ------ Saving registers ---------------------------
    addi sp, sp, -40        # Allocate 40 bytes
    # ------ Registers saved for the RA -----------------
    sd x1, 32(sp)           # Save ra
    # ------ Registers saved for COUNTERS ---------------
    sd x19, 24(sp)          # Save s3
    sd x20, 16(sp)          # Save s4
    # ------ Registers saved for PARAMETERS -------------
    sd x21, 8(sp)           # Save s5
    sd x22, 0(sp)           # Save s6

    # ------ Mooving Parameters -------------------------
    mv x21, x10             # Move parameter a in x21
    mv x22, x11             # Move parameter n in x22
    
    # ------ Outer Loop ---------------------------------
    add x19, x0, x0         # i = 0
L1:
    bge x19, x22, L1END     # Goto L1END if (i >= n)

    # ------ Inner Loop ---------------------------------
    addi x20, x19, -1       # j = i - 1
L2:
    blt x20, x0, L2END      # Goto L2END if (j < 0)
    slli x5, x20, 3         # x5 = j * 8
    add x5, x5, x21         # x5 = a + (j * 8)
    ld x6, 0(x5)            # x6 = a[j]
    ld x7, 8(x5)            # x7 = a[j+1]
    bge x7, x6, L2END       # Goto L2END if (a[j] <= a[j+1])

    # ------ Setup Params and Call ----------------------
    mv x10, x21             # Move first parameter a in x10
    mv x11, x22             # Move second parameter n in x11
    jal x1, swap            # Calling swap

    # ------ Inner Loop ---------------------------------
    addi x20, x20, -1       # j -= 1
    jal x0, L2              # Goto L2
L2END:

    # ------ Outer Loop ---------------------------------
    addi x19, x19, 1        # i += 1
    jal x0, L1              # Goto L1
L1END:

    # ------ Restoring Registers ------------------------
    ld x1, 32(sp)           # Restore ra
    ld x19, 24(sp)          # Restore s3
    ld x20, 16(sp)          # Restore s4
    ld x21, 8(sp)           # Restore s5
    ld x22, 0(sp)           # Restore s6
    addi sp, sp, 40         # Deallocate 40 bytes

    # ------ Procedure Return ---------------------------
    jalr x0, 0(x1)          # Return to caller
```

**Ricorda:**

1) Prima di cominciare a scrivere codice assembly, riscrivesi e studiare tutta la **procedura in linguaggio C**. Poi successivamente tradurre il C in assembly.

2) Prima di ogni procedura scriversi una **legenda** che associa registro-variabile in C.

3) Studiare dei **commenti** di default da inserire a fianco delle istruzioni.

4) Le **condizioni di *if* e *for*** possono contenere delle concatenazioni di espressioni separate da **AND *&&*** oppure **OR *||***. A seconda dei casi è bene studiare come progettare le condizioni.

    - Nel caso dei **&&** (AND) è più facile perchè si sfrutta la cortocircuitazione logica.
    - Nel caso dei **||** (OR) invece si debbono creare una sequenza di if-else.

5) **Studiare la nomenclatura x0-x31 dei registri** invece di utilizzare quelli semplici. Questo comporterà un vantaggio nella traduzione delle istruzioni. Perchè i registri x0-x31 posso tradurli direttamente in binario; mentre registri come t0-6, s0-11 e a0-a7 devo prima tradurli nel corrispettivo formato x0-x31 e poi in binario (richiede un passaggio in più). 

6) Per capire il numero di registri saved dovemo utilizzare e quindi dobbiamo salvare nello stack, basta osservare il codice C:

    - Il **registro x1 (Return Address)** va salvato quando la procedura fa una chiamata ad un'altra procedura. (1 saved register)

    - Gli **registri x10, x11, ..., x17 (Procedure Parameters)** vanno salvati nel caso la procedura intende fare una chiamata ad una sotto procedura. (1-7 saved registers)

    - I **Contatori (i, j, ...) di cicli che contengono chiamate a funzione** vanno salvati perchè se inseriti in variabili temporanee potrebbero essere sovrascritti da delle sotto procedure. (n saved registers)

    - I **valori di ritorno x10, x11 di una funzione** potrebbe essere necessario salvarli perchè vengono persi se effettuiamo molteplici chiamate a funzione sequenzialmente. Tutte le funzioni scriverebbero loro risultato in x10 sovrascrivendolo ogni volta. (1-2 saved registers)

    - In generale **tutti i registri che devono permanere prima e dopo una chiamata a funzione** vanno inseriti in dei registri saved. (m saved registers)

7) Le procedure solitamente sono divise in diverse sezioni riconoscibili, quali:

    1) **Saving Registers**: Alloco spazio nello stack. E salvo i registri nello stack.

    2) **Move Parameters**: sposto gli argomenti in registri saved.

    3) **Procedure Body**:

        - Può contenere loop (for, while), loop innestati, if statements.

    4) **Procedure Calling**:

        1) Inserisci nei registri dei parametri (x10, x11) gli argomenti;
        2) Chiama la funzione inserendo il Return Address in x1;
        3) Salva il risultato x10 in un registro saved.

    5) **Save Return Value**: Salvo il valore di ritorno della procedura ll'interno del registro x10 (a0),

    6) **Restoring Registers**: Reimposto i valori originali dei saved registers. E reimposto lo stack pointer.

    7) **Procedure return**: Ritorno alla procedura chiamante
