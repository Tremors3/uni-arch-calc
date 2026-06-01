Example 1: String Copy
• C code:
• Null-terminated string
 
```C
char[] strcpy(char x[], char y[])
{ 
    size_t i = 0;
    while ( (x[i] = y[i]) != '\0')
        i += 1;
    return x;
}
```

```asm
.global main
.data
    x: .string "dst"
    y: .string "src"
    
    hx: .string "X: "
    hy: .string "\nY: "
.text
main:
    addi x2, x2, -4     # Allocate stack
    sw x1, 0(x2)        # Save ra

    la x10, x           # 1° Arg = x
    la x11, y           # 2° Arg = y
    jal x1, strcpy      # Call strcpy procedure

    li x17, 4           # PrintString syscall code
    
    la x10, hx          # 1° Arg = hx
    ecall               # Call PrintString syscall

    la x10, x           # 1° Arg = x
    ecall               # Call PrintString syscall
    
    la x10, hy          # 1° Arg = hy
    ecall               # Call PrintString syscall

    la x10, y           # 1° Arg = y
    ecall               # Call PrintString syscall

    lw x1, 0(x2)        # Restore ra
    addi x2, x2, 4      # Deallocate stack

    li x10, 0           # Exit Value = 0
    li x17, 93          # Exit syscall code
    ecall               # Call Exit syscall
# x10 = x
# x11 = y
strcpy:
    add x29, x0, x0     # i = 0
LOOP:
    add x5, x29, x10    # x5 = x + i
    add x6, x29, x11    # x6 = y + i
    lbu x6, 0(x6)       # x6 = y[i]
    sb x6, 0(x5)        # x[i] = y[i]

    beq x6, x0, ENDL    # Goto ENDL if (y[i] == 0)
    addi x29, x29, 1    # i++
    jal x0, LOOP        # Goto LOOP
ENDL:
    # x10 = x           # res already x
    jalr x0, 0(x1)      # Return to caller
```
