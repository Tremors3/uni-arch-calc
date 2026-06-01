Si converta il seguente frammento di codice C in assembly 
RISC-V

```C
// s0 -> a, s1 -> b 
int a = 5, b = 10;
if(a + a == b) {
 a = 0;
} else {
 b = a - 1;
}
```

```asm
    addi x5, x0, 5      # a = 5
    addi x6, x0, 10     # b = 10
    slli x7, x6, 1      # temp = a * 2
    bne x7, x6, ELSE    # Goto ELSE if (a + a != n)
    xor x5, x0, x0      # a = 0
    jal x0, ENDIF       # Goto ENDIF
ELSE:
    addi x6, x5, -1     # b = a -1
ENDIF:
    ...
```
