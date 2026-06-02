
Scrivi una funzione in assembly Risc-V che riceve in ingresso la stringa str e la inverta. Scrivi anche il Main che chiama la funzione con una string allocata nel segmento di dati statici.

```C
void swapchar(char *a, char *b) {
    temp = a[0];
    a[0] = b[0];
    b[0] = temp;
}

char* revstr(char* str, int size) {
    for (int i = 0; i < size / 2; i++)
        swapchar(&str[i], &str[size - 1 - i]);
    return str;
}
```

```asm
# x10 = *a
# x11 = *b
swapchar:
    lbu x5, 0(x10)      # temp1 = str[i]
    lbu x6, 0(x11)      # temp2 = str[size - 1 -i]
    sb x6, 0(x10)       # str[i] = temp2
    sb x5, 0(x11)       # str[size - 1 - i] = temp 1
    jalr x0, 0(x1)      # Return to caller

# x10 = *str
# x11 = size
revstr:
    addi x2, x2, -40    # Allocate stack
    sd x1, 0(x2)        # Save ra
    sd x18, 8(x2)       # Save s2
    sd x19, 16(x2)      # Save s3
    sd x20, 24(x2)      # Save s4
    sd x21, 32(x2)      # Save s5

    add x20, x0, x10    # x20 = str
    addi x21, x11, -1   # x21 = size - 1

    srli x18, x11, 1    # x18 = size / 2
    add x19, x0, x0     # i = 0
LOOP:
    bge x19, x18, ENDL  # Goto ENDL if (i >= size / 2)

    add x10, x20, x19   # Arg1 = str + i
    sub x11, x21, x19   # temp = size - 1 - i
    add x11, x11, x20   # Arg2 = str + (size - 1 - i)
    jal x1, swapchar    # Call swapchar procedure

    addi x19, x19, 1    # i++
    jal x0, LOOP        # Goto LOOP
ENDL:
    add x10, x0, x20    # ret val = &str

    ld x1, 0(x2)        # Restore ra
    ld x18, 8(x2)       # Restore s2
    ld x19, 16(x2)      # Restore s3
    ld x20, 24(x2)      # Restore s4
    ld x21, 32(x2)      # Restore s5
    addi x2, x2, 40     # Deallocate stack

    jalr x0, 0(x1)      # Return to caller
```
