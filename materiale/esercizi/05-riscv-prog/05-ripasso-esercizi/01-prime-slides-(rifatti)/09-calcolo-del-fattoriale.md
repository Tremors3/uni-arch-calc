
Scrivi una funzione assembly Risc-V che calcoli il fattoriale:

!5 = 120 = 1 * 2 * 3 * 4 * 5

Sequenziale

```C
int fact(int n) {
    int result = 1;
    for (; n > 0; n--) {
        result *= n;
    }
    return result;
}
```

```asm
fact:
    addi x28, x0, 1     # res = 1
LOOP:
    bge x0, x10, ENDL   # Goto ENDL if (n <= 0)
    mul x28, x28, x10   # res *= n
    addi x10, x10, -1   # n--
    jal x0, LOOP        # Goto LOOP
ENDL:
    add x10, x0, x28    # x10 = res
    jalr x0, 0(x1)      # Return to caller
```

Ricorsiva

```C
int fact(int n) {
    if (n <= 0)
        return n;
    return n * fact(n - 1);
}
```

```asm
# x10 = n
fact:
    blt x0, x10, RECUR  # Goto RECUR if (n > 0)
    addi x10, x0, x10   # x10 = n
    jal x0, END         # Goto END
RECUR:
    addi x2, x2, -8     # Allocate stack
    sw x1, 0(x2)        # Save ra
    sw x8, 4(x2)        # Save s0 (n)

    addi x8, x0, x10    # s0 = n

    addi x10, x8, -1    # 1° Arg = n - 1
    jal x1, fact        # Call fact procedure
    mul x10, x8, x10    # x10 = n * fact(n-1)

    lw x1, 0(x2)        # Restore ra
    lw x8, 4(x2)        # Restore s0
    addi x2, x2, 8      # Deallocate stack
END:
    jalr x0, 0(x1)      # Return to caller
```