Si converta il seguente frammento di assembly RISC-V in 
codice C e si dica cosa fa

```asm
 addi s0, zero, 0
 addi s1, zero, 1
 addi t0, zero, 30
loop:
 beq s0, t0, exit
 add s1, s1, s1
 addi s0, s0, 1
 jal zero, loop
exit:
```

```C
int b = 1, n = 30;
for (int i = 0; i != n; i++) {
    b *= 2;
}
```