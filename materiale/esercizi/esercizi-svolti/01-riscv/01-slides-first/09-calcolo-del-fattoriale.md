
#### Quesito:

Scrivi una funzione in Risc-V assembly che calcoli il fattoriale.

#### Soluzione:

```asm
fact:
    addi t0, zero, 1   // t0 = 1 per confronto
    blt t0, a0, body   // Se (n > 1): vai al corpo
    addi a0, zero, 1   // Caso base:  fact(n) = 1
    jal zero, end      // Restituisci 1

body:
    addi sp, sp, -16   // Allochiamo spazio per n e ra
    sd a0, 0(sp)       // Salva n
    sd ra, 8(sp)       // Salva ra
    
    addi a0, a0, -1    // Calcola n - 1
    jal ra, fact       // Chiamata ricorsiva: fact(n - 1)
    
    ld t1, 0(sp)       // Riprendiamo n
    ld ra, 8(sp)       // Riprendiamo ra
    addi sp, sp, 16    // Libera lo spazio nello stack

    mul a0, a0, t1     // Calcola n * fact(n - 1)

end:
    jalr zero, 0(ra)   // Restituisci il risultato (fine)
```
