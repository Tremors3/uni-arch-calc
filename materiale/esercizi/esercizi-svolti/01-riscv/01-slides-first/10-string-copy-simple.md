#### Quesito:

Scrivi una funzione in Risc-V assembly che copia i valori dell'array x in y.

#### Soluzione:

```asm
# a0 = x[]
# a1 = y[]
# s0 = i

strcpy:
    addi sp, sp, -4     # Alloco 4 byte nello stack
    sd s0, 0(sp)        # Salvo i
    addi s0, zero, 0    # Setto i = 0

while:
    add t0, s0, a0      # t0 = addr of x[i]
    add t1, s0, a1      # t1 = addr of y[i]
    
    lbu t2, 0(t1)       # t2 = y[i]
    sb t2, 0(t0)        # x[i] = t2

    beq t2, zero, end   # Se y[i] == 0 allora esco

    addi s0, s0, 1      # incremento i
    jal zero, while     # Rieseguo il ciclo

end:
    ld s0, 0(sp)        # Carico i
    addi sp, sp, 4      # Disalloco 4 bytes nello stack
    jalr zero, 0(ra)    # Ritorno
```

**Ricorda:**

1) Invece di utilizzare il save register s0, avrei potuto utilizzare un temporaneo tra t0-t6, in modo da risparmiarmi il salvataggio sullo stack.
   
   In generale è bene utilizzare il **minor numero possibile di registri saved** in modo da dover scrivere di meno nello stack.
