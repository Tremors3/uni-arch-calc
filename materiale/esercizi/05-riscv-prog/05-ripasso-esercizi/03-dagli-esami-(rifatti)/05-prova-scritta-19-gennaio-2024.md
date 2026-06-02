
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
short int max(short int *arr, int size);
short int min(short int *arr, int size);
short int avg(short int *arr, int size);
```

Gestire opportunamente lo stack delle singole funzioni.

#### RISOLUZIONE

```C
short int max(short int *arr, int size) {
    int max = arr[0];
    for (int i = 1; i < size; i++)
        if (arr[i] > max)
            max = arr[i];
    return max;
}

short int min(short int *arr, int size) {
    int min = arr[0];
    for (int i = 1; i < size; i++)
        if (arr[i] < min)
            min = arr[i];
    return min;
}

short int avg(short int *arr, int size) {
    if (size == 0) return 0;
    int sum = 0;
    for (int i = 0; i < size; i++)
        sum += arr[i];
    return sum / size;
}

short int range(short int *arr, int size) {
    return (max(arr) - min(arr) - avg(arr))
}
```

```asm
# x10 = arr
# x11 = size
max:
    lh x30, 0(x10)          # max = arr[0]
    addi x29, x0, 1         # i = 1
maxLOOP:
    bge x29, x11, minENDL   # Goto maxENDL if (i >= size)

    slli x5, x29, 1         # x5 = i * 2
    add x5, x5, x10         # x5 = arr + (i * 2)
    lh x5, 0(x5)            # x5 = arr[i]
    
    blt x30, x5, maxENDIF   # Goto maxENDIF if (arr[i] <= size)
    add x30, x0, x5         # max = arr[i]
maxENDIF:
    add x29, x29, 1         # i++
    jal x0, maxLOOP         # Goto maxLOOP
maxENDL:
    add x10, x0, x30        # x10 (ret val) = max
    jalr x0, 0(x1)

# x10 = arr
# x11 = size
min:
    lh x30, 0(x10)          # min = arr[0]
    addi x29, x0, 1         # i = 1
minLOOP:
    bge x29, x11, minENDL   # Goto minENDL if (i >= size)

    slli x5, x29, 1         # x5 = (i * 2)
    add x5, x5, x10         # x5 = arr + (i * 2)
    lh x5, 0(x5)            # x5 = arr[i]

    bge x5, x30, minENDIF   # Goto minENDIF if (arr[i] >= min)
    add x30, x0, x5         # min = arr[i]
minENDIF:
    add x29, x29, 1         # i++
    jal x0, minLOOP         # Goto minLOOP
minENDL:
    add x10, x0, x30        # x10 (ret val) = min
    jalr x0, 0(x1)          # Return to caller

# x10 = arr
# x11 = size
avg:
    bne x11, x0, CHKED_DIV0 # Goto CHKED_DIV0 if (size != 0)
    xor x10, x0, x0         # x10 (ret val) = 0
    jalr x0, 0(x1)          # Return to caller
CHKED_DIV0:
    add x30, x0, x0         # sum = 0
    add x29, x0, x0         # i = 0
avgLOOP:
    bge x29, x11, avgENDL   # Goto avgENDL if (i >= size)

    slli x5, x29, 1         # x5 = (i * 2)
    add x5, x5, x10         # x5 = arr + (i * 2)
    lh x5, 0(x5)            # x5 = arr[i]
    add x30, x30, x5        # sum += arr[i]

    addi x29, x29, 1        # i++
    jal x0, avgLOOP         # Goto avgLOOP
avgENDL:
    div x10, x30, x11       # x10 (ret val) = sum / size
    jalr x0, 0(x1)          # Return to caller

# x10 = arr
# x11 = size
range:
    addi x2, x2, -16        # Allocate stack
    sw x1, 0(x2)            # Save ra
    sw x8, 4(x2)            # Save s0   (res)
    sw x20, 8(x2)           # Save s4   (arr)
    sw x21, 12(x2)          # Save s5   (size)

    add x20, x0, x10        # x20 = arr
    add x21, x0, x11        # x21 = size

    jal x1, max             # x10 = max(arr, size)
    add x8, x0, x10         # res = max(arr, size)

    add x10, x0, x20        # Arg1 = arr
    add x11, x0, x21        # arg2 = size
    jal x1, min             # x10 = min(arr, size)
    sub x8, x8, x10         # res = max(arr, size) - min(arr, size)
    
    add x10, x0, x20        # Arg1 = arr
    add x11, x0, x21        # arg2 = size
    jal x1, avg             # x10 = avg(arr, size)
    sub x10, x8, x10        # x10 (ret val) = max(arr, size) - min(arr, size) - avg(arr, size)

    lw x1, 0(x2)            # Restore ra
    lw x8, 4(x2)            # Restore s0
    lw x20, 8(x2)           # Restore s4
    lw x21, 12(x2)          # Restore s5
    addi x2, x2, 16         # Deallocate stack

    jalr x0, 0(x1)          # Return to caller
```
