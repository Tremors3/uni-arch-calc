Si converta il seguente frammento di codice C in assembly 
RISC-V

```C
// s0 -> a, s1 -> b
// s2 -> c, s3 -> z
int a = 4, b = 5, c = 6, z;
z = a + b + c + 10;
```

```asm
addi x8, x0, 4      # a = 4
addi x9, x0, 5      # b = 5
addi x18, x0, 6     # c = 6
addi x19, x18, 10   # z = c + 10
add x28, x28, x9    # z += b
add x28, x28, x8    # z += a
```
