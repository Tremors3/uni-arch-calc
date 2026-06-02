Si converta il seguente frammento di codice C in assembly 
RISC-V

```C
// s0 -> n, s1 -> sum
// assume n > 0 to start
for (int sum = 0; n > 0; n--) {
    sum += n;
}
```

```asm
add x28, x0, x0         # sum = 0
LOOP:
    bge x0, x8, ENDL    # Goto ENDL if (n <= 0)
    add x28, x28, x8    # sum += n
    addi x8, x8, -1     # n--
    jal x0, LOOP        # Goto LOOP
ENDL:
    ...
```