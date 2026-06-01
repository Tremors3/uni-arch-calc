Si scriva una funzione sumSquare che prende in ingresso 
un intero n e ritorna la somma mostrata sotto. Se n è non 
positivo la funzione ritorna 0

$$ n^2 + (n-1)^2 + (n-2)^2 + \dots + 1^2 $$

Si assuma di avere a disposizione una funzione square che 
prende in ingresso un intero e restituisce il suo quadrato. 
Implementare sumSquare usando square come subroutine.

```C
int sumSquare(int n) {
    int sum = 0;
    for(; n > 0; n--) {
        sum += square(n);
    }
    return sum;
}
```

```asm
sumSquare:
    addi x2, x2, 12     # Allocate stack
    sw x1, 0(x2)        # Save ra
    sw x8, 4(x2)        # Save s0 (n)
    sw x9, 8(x2)        # Save s1 (sum)

    add x8, x0, x10     # s0 = n
    add x9, x0, x0      # s1 = sum
LOOP:
    bge x0, x9, ENDL    # Goto ENDL if (n <= 0)
    add x10, x0, x8     # 1° Arg = n
    jal x1, square      # Call square procedure
    addi x9, x9, x10    # sum += square(n)
    addi x8, x8, -1     # n--
    jal x0, LOOP        # Goto LOOP
ENDL:
    addi x10, x0, x8    # ret = sum
    
    lw x1, 0(x2)        # Restore ra
    lw x8, 4(x2)        # Restore s0
    lw x9, 8(x2)        # Restore s1
    addi x2, x2, 12     # Deallocate stack

    jalr x0, 0(x1)      # Return to caller
```