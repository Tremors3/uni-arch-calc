
#### Quesito:

Si assuma di avere un array in memoria così inizializzato:

```c
int* arr = {1,2,3,4,5,6,0}
```

Si assuma che l’indirizzo base dell’array risieda in s0. Cosa fanno i seguenti frammenti di codice? Si assuma che i frammenti eseguano in sequenza.

```asm
a)  lw t0, 12(s0)

b)  slli t1, t0, 2
    add t2, s0, t1
    lw t3, 0(t2)
    addi t3, t3, 1
    sw t3, 0(t2)

c)  lw t0, 0(s0)
    xori t0, t0, 0xFF
    addi t0, t0, 1
```

#### Soluzione:

**Soluzione quesito a)**

```
Spiegazione testuale:

    Stiamo andando a caricare all'interno del registro temporaneo t0 il quarto valore a partire dall'indirizzo dell'array, quindi il numero 4;

    Ricorda:                word = 32 bit = 4 bytes
    Se l'offset è di 12:    12 (offset bytes) / 4 (dim. elem. bytes) = 3 (indice tre)

Traduzione in linguaggio C:

    lw t0, 12(s0)   # t0 = arr[3];
```

**Soluzione quesito b)**

```
Spiegazione testuale:

    Stiamo recuperando il quarto elemento Intero (Word = 4 byte = 32 bit) dell' array "arr" e immettendolo nel registro t3. Successivamente incrementiamo di 1 il numero presente in t3 e lo sovrascriviamo al quarto elemento dell' array.

    Ricorda: Moltiplichiamo l'indice (dell'elemento) per il numero di bytes che compongono ciascun elemento dell'array. L'array in questo caso è intero (una word, 4 bytes). Per moltiplicare l'indice t0 per 4 basta sciftarlo di 2 verso sinistra (log_2(4) = 2); Ottenuto l'offset lo si va a sommare all'indirizzo di base dell'array arr.

Traduzione in C:

    t0 = 4              # ottenuto dal quesito a
    slli t1, t0, 2      # t1 = t0 * 4   = 4 * 4 = 16
    add t2, s0, t1      # t2 = arr + t1 = &arr[4]
    lw t3, 0(t2)        # t3 = arr[4]
    addi t3, t3, 1      # t3 = t3 + 1
    sw t3, 0(t2)        # arr[4] = t3

Traduzione concisa in C:

    arr[4] = arr[4] + 1;
```

**Soluzione quesito c)**

```
Spiegazione testuale

    Stiamo effettuando il Complemento a 2 del primo elemento dell'array (1). Questo mettendo a XOR l'elemento 1 con una maschera di 8 uni (0xFF), e successivamente incrementando il risultato di 1.

Traduzione in C:

    lw   t0, 0(s0)      # t0 = arr[0] = 00000001 =  1
    xori t0, t0, 0xFF   # t0 ^= 0xFF  = 11111110 = -2
    addi t0, t0, 1      # t0 += 1     = 11111111 = -1
```
