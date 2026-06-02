
Traduci in assembly Risc-V le seguenti due funzioni C che implementano un algoritmo di sorting applicabile ad array.

```C
void swap(long long int arr[], int j) {
    long long int temp;
    temp = arr[j];
    arr[j] = arr[j+1];
    arr[j+1] = temp;
}

long long int* sort(long long int arr[], int size) {
    for (int i = 0; i < size - 1; i++)
        for (int j = 0; j < size - 1 - i; j++)
            if (arr[j] > arr[j+1])
                swap(arr, j);
    return arr;
}
```

```asm
# x10 = arr
# x11 = j
swap:
    slli x5, x11, 3
    add x5, x5, x10
    ld x6, 0(x5)
    ld x7, 8(x5)
    sd x7, 0(x5)
    sd x6, 8(x5)
    jalr x0, 0(x1)

# x10 = arr
# x11 = size
sort:
    addi x2, x2, -40
    sd x1, 0(x2)
    sd x18, 8(x2)
    sd x19, 16(x2)
    sd x20, 24(x2)
    sd x21, 32(x2)

    add x20, x0, x10
    addi x21, x11, -1

    add x19, x0, x0
L1:
    bge x19, x21, ENDL1
    add x18, x0, x0
L2:
    sub x5, x21, x19
    bge x18, x5, ENDL2

    slli x5, x18, 3
    add x5, x5, x20

    ld x6, 0(x5)
    ld x7, 8(x5)
    bge x7, x6, SKIPSWAP
    add x10, x0, x20
    add x11, x0, x18
    jal x1, swap
SKIPSWAP:
    addi x18, x18, 1
    jal x0, L2
ENDL2:
    addi x19, x19, 1
    jal x0, L1
ENDL1:
    add x10, x0, x20

    ld x1, 0(x2)
    ld x18, 8(x2)
    ld x19, 16(x2)
    ld x20, 24(x2)
    ld x21, 32(x2)
    addi x2, x2, 40

    jalr x0, 0(x1)
```
