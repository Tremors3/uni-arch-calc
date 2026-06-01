
#### QUESITO

Si consideri la seguente funzione C:

```c
int acc (int array[], int size) {
  int i, sum = 0;
  for (i= 0; i < size; i+= 1)
    sum += array[i];
}
```

a. Si scriva la corrispondente funzione assembly RISC-V, assumendo che gli 
argomenti vengano forniti in x10 e x11 e gestendo opportunamente lo stack.

#### RISOLUZIONE

```
// x10 = array
// x11 = size

arraysum:
    add x5, x0, x0      // i = 0
    add x6, x0, x0      // sum = 0
LOOP:
    bge x5, x11, EXIT   // Goto EXIT if (i >= size)
    slli x7, x5, 2      // x7 = offset (words)
    add x7, x7, x10     // x7 = array + offset
    lw x7, 0(x7)        // x7 = array[i]
    add x6, x6, x7      // sum += array[i]
    jal x0, LOOP        // Goto LOOP
EXIT:
    add x10, x0, x6     // x10 (ret val) = sum
    jalr x0, 0(x1)      // Goto caller
```