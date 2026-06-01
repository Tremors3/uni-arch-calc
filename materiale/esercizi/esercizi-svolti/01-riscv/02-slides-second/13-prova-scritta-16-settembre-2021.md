
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
    la t0, arr
    la t1, n
    lb t1, 0(t1)        //  i =  5 (1 byte)
    lw t2, 0(t0)        // t2 = 10 (2 byte)
ciclo:
    addi t1, t1, -1     // i --
    beq t1, zero, exit  // Goto exit 8f (t1 == 0)
    slli t3, t1, 2      // t3 = i * 4
    add t3, t0, t3      // t3 = arr + (i * 4)
    lw t3, 0(t3)        // t3 = arr[i]
    sub t2, t2, t3      // t2 -= arr[i]
    j ciclo             // Goto ciclo
exit:
```

Lo stralcio di codice sottrae al primo numero dell'array (10) gli elementi dall'ultimo fino al secondo (non sottrae il primo). In pratica:

- **`10 - 1 - 2 - 4 - 3 = 0`**

Risposta giusta:

- **c) `0`**
