
#### QUESITO

Si consideri il seguente stralcio di codice assembly RISC-V

```asm
.globl main
.data 
    arr: .word 10, 3, 4, 2, 1
    n: .word 5
.text
main:
    la t0, arr
    la t1, n
    lb t1, 0(t1)
    lw t2, 0(t0)
ciclo:
    addi t1, t1, -1
    beq t1, zero, exit
    slli t3, t1, 2
    add t3, t0, t3
    lw t3, 0(t3)
    sub t2, t2, t3 
    j ciclo
exit:
```

Che valore contiene il registro t2 al termine del programma? Motivare la risposta.

- a) 20
- b) 10
- c) 0
- d) Nessuna delle precedenti

#### RISOLUZIONE

```asm
.globl main
.data 
    arr: .word 10, 3, 4, 2, 1
    n: .word 5
.text
main:
    la t0, arr          # temp0 = arr
    la t1, n            # temp1 = address of n
    lb t1, 0(t1)        # temp1 = n
    lw t2, 0(t0)        # temp2 = arr[n] = 10
ciclo:
    addi t1, t1, -1     # n--
    beq t1, zero, exit  # Goto EXIT if (n == 0)
    slli t3, t1, 2      # temp3 = (n * 2)
    add t3, t0, t3      # temp3 = arr + (n * 2)
    lw t3, 0(t3)        # temp3 = arr[n]
    sub t2, t2, t3      # temp2 -= arr[n]
    j ciclo             # goto CICLO
exit:
```

- Il ciclo compie 4 iterazioni.
- Sottrae al primo elemento dell'array (10) i successivi elementi.
- Quindi alla fine delle iterazioni `t2` varrà:
    
    $$ \text{t2} = 10 - 1 - 2 - 4 - 3 = 0 $$

    - Risposta giusta: **C) 0**.
