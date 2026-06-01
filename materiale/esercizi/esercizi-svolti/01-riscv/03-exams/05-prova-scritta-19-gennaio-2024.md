
#### QUESITO

Scrivere un programma assembly RISC-V che implementi una funzione C, chiamata `range`, avente la seguente intestazione:

```c
short int range(short int *arr, int size);
```

La funzione prende in ingresso un array di interi `arr` un intero `size` che rappresenta il numero di elementi dell'array. La funzione calcola e ritorna il seguente valore:

```c
rng = (max(arr[]) - min(arr[]) - avg(arr[]));
```

dove `max`, `min` e `avg` sono tre funzioni che ritornano, rispettivamente: (i) il massimo tra gli elementi dell'array; (ii) il minimo tra gli elementi dell'array; (iii) la media tra gli elementi dell'array, ovvero:

$$ avg(arr[i], size) = \frac{\sum_{i=0}^{size-1} arr[i]}{size} $$

Scrivere quindi le funzioni `min`, `max` e `avg`, considerando la seguente signature C:

```c
short int max(short int arr, int size);
short int min(short int arr, int size);
short int avg(short int *arr, int size);
```

Gestire opportunamente lo stack delle singole funzioni.

#### RISOLUZIONE

**Codice C**:

```c
short int max(short int arr, int size) {
    short int _max = arr[0];
    for (int i = 1; i < size; i++)
        if (arr[i] > _max)
            _max = arr[i]
    return _max;
}

short int min(short int arr, int size) {
    short int _min = arr[0];
    for (int i = 1; i < size; i++)
        if (arr[i] < _min)
            _min = arr[i]
    return _min;
}

short int avg(short int *arr, int size) {
    short int sum = 0;
    for(int i = 0; i < size; i++)
        sum += arr[i];
    return sum / size;
}

short int range(short int *arr, int size) {
    return max(arr, size) - min(arr, size) - avg(arr, size);
}
```

**Codice Risc-V**:
 
```asm
// x10 = arr
// x11 = size

range:
    addi x2, x2, -24    // Allocate stack
    sd x1, 0(x2)        // Save ra
    sd x20, 8(x2)       // Save s4
    sd x21, 16(x2)      // Save s5

    add x20, x0, x10    // x20 = arr
    add x21, x0, x11    // X11 = size

    jal x1, max         // Call max
    add x5, x0, x10     // x5 = max()

    add x10, x0, x20    // Set 1° arg (arr)
    add x11, x0, x21    // Set 2° arg (size)
    jal x1, min         // Call min
    add x6, x0, x10     // x6 = min()

    add x10, x0, x20    // Set 1° arg (arr)
    add x11, x0, x21    // Set 2° arg (size)
    jal x1, avg         // Call avg
    add x7, x0, x10     // x7 = avg()

    sub x5, x5, x6      // x5 = max - min
    sub x5, x5, x7      // x5 = max - min - avg

    add x10, x0, x5     // x10 = rng

    ld x1, 0(x2)        // Save ra
    ld x20, 8(x2)       // Save s4
    ld x21, 16(x2)      // Save s5
    addi x2, x2, 24     // Deallocate stack

    jalr x0, 0(x1)      // Return to caller

// x10 = arr
// x11 = size

max:
    lh x31, 0(x10)      // max = arr[0]
    addi x29, x0, 1     // i = 1
MAXL:
    bge x29, x11, MAXE  // Goto MAXE if (i >= size)
    slli x5, x29, 1     // x5 = i * 2
    add x5, x5, x10     // x5 = arr + (i * 2)
    lh x5, 0(x5)        // x5 = arr[i]
    addi x29, x29, 1    // i++
    bge x31, x5, MAXL   // Goto MAXL if (arr[i] <= max)
    add x31, x0, x5     // max = arr[i]
    jal x0, MAXL        // Goto MAXL
MAXE:
    add  x10, x0, x31   // x10 = max
    jalr x0, 0(x1)      // Return to Caller

// x10 = arr
// x11 = size

min:
    lh x31, 0(x10)      // min = arr[0]
    addi x29, x0, 1     // i = 1
MINL:
    bge x29, x11, MINE  // Goto MINE if (i >= size)
    slli x5, x29, 1     // x5 = i * 2
    add x5, x5, x10     // x5 = arr + (i * 2)
    lh x5, 0(x5)        // x5 = arr[i]
    addi x29, x29, 1    // i++
    bge x5, x31, MINL   // Goto MINL if (arr[i] >= min)
    add x31, x0, x5     // min = arr[i]
    jal x0, MINL        // Goto MINL
MINE:
    add x10, x0, x31    // x10 = min
    jalr x0, 0(x1)      // Return to Caller

// x10 = arr
// x11 = size

avg:
    add x31, x0, x0     // sum = 0
    add x29, x0, x0     // i = 0
AVGL:
    bge x29, x11, AVGE  // Goto AVGE if (i >= size)
    slli x5, x29, 1     // x5 = i * 2
    add x5, x5, x10     // x5 = arr + (i * 2)
    lh x5, 0(x5)        // x5 = arr[i]
    add x31, x31, x5    // sum += arr[i]
    addi x29, x29, 1    // i++
    jal x0, AVGL        // Goto AVGL
AVGE:
    div x10, x31, x11   // x10 = sum / size
    jalr x0, 0(x1)      // Return to Caller
```

**Ricorda**:

- Molto spesso uso `addi` (add immediate) anche quando devo **sommare due registri**. **NON VA BENE**! Devo ricordarmi di usare `add`.
