Si converta il seguente frammento di codice C in assembly 
RISC-V

```C
// s0 -> int * p = intArr;
// s1 -> a;
*p = 0;
int a = 2;
p[1] = p[a] = a;
```

```asm
sw x0, 0(x8)        # intArr[0] = 0
addi x9, x0, 2      # a = 2
slli x5, x9, 2      # x5 = (a * 4)
addi x5, x5, x8     # x5 = intArr + (a * 4)
sw x9, 0(x5)        # intArr[a] = a
sw x9, 4(x8)        # intArr[1] = a
```
