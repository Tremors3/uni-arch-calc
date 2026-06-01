
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
# x10 = array[]
# x11 = size
acc:
    add x29, x0, x0     # i = 0
    add x30, x0, x0     # sum = 0
LOOP:
    bge x29, x11, ENDL  # Goto ENDL if (i >= size)
    slli x5, x29, 2     # x5 = (i * 4)
    add x5, x5, x10     # x5 = array + (i * 4)
    lw x5, 0(x5)        # x5 = array[i]
    add x30, x30, x5    # sum += array[i]
    addi x29, x29, 1    # i++
    jal x0, LOOP
ENDL:
    add x10, x0, x30    # x10 (ret val) = sum
    jalr x0, 0(x1)      # Return to caller
```
