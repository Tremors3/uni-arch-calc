Scrivi in linguaggio assembly Risc-V un algoritmo di ordinamento:

```C
void swap(int A[], int j) {
    int temp = A[j]
    A[j] = A[j+1]
    A[j+1] = temp;
}

int[] sort(int A[], int n) {
    for (int i = 0; i < n; i++)
        for (int j = i - 1; (j >= 0) && (A[j] > A[j+1]); j--)
            swap(A, j);
}
```

```asm
.global main
.data
    A: .word 10, 9, 8, 7, 6, 5, 4, 3, 2, 1
    n: .byte 10

    text1: .string "Unordered: "
    text2: .string "\nOrdered:   "
    sep: .string ", "
.text
main:
    addi x2, x2, -8     # Allocate stack
    sw x1, 0(x2)        # Save ra
    sw x9, 4(x2)        # Save s1    (address of n)

    la x9, n            # s1 = address of n
    lb x9, 0(x9)        # s1 = n
    
    la x10, text1       # 1° Arg = "Unordered: "
    li x17, 4           # PrintStr syscall code
    ecall               # Call PrintStr syscall
    
    la x10, A           # 1° Arg = A[]
    mv x11, x9          # 2° Arg = n
    jal x1, print       # Call print procedure
    
    la x10, A           # 1° Arg = A[]
    mv x11, x9          # 2° Arg = n
    jal x1, sort        # Call sort procedure

    la x10, text2       # 1° Arg = "\nOrdered: "
    li x17, 4           # PrintStr syscall code
    ecall               # Call PrintStr syscall

    la x10, A           # 1° Arg = A[]
    mv x11, x9          # 2° Arg = n
    jal x1, print       # Call print procedure

    lw x1, 0(x2)        # Restore ra
    lw x9, 4(x2)        # Restore s1
    addi x2, x2, 8      # Deallocate stack

    li x10, 0           # Exit value 0
    li x17, 93          # Exit syscall code 
    ecall               # Call Exit syscall
# x10 = A[]
# x11 = n
print:
    add x28, x0, x10    # x28 = A[]
    slli x30, x11, 2    # x5 = (n * 4)
    add x30, x30, x10   # x5 = A + (n * 4)
pLOOP:
    lw x10, 0(x28)      # x5 = *A
    addi x17, x0, 1     # PrintInt syscall code
    ecall               # Call PrintInt syscall

    addi x28, x28, 4    # A = A + 1 (4 bytes)
    bge x28, x30, pLEND # Goto PLEND if (A+1 = A+n)
    
    la x10, sep         # x10 = ", "
    addi x17, x0, 4     # PrintStr syscall code
    ecall               # Call PrintStr syscall
    
    jal x0, pLOOP       # Goto pLOOP
pLEND:
    jalr x0, 0(x1)      # Return to caller
# x10 = A[]
# x11 = j
swap:
    slli x5, x11, 2     # x5 = (j * 4)
    add x5, x5, x10     # x5 = A + (j * 4)
    lw x6, 0(x5)        # x6 = A[j]
    lw x7, 4(x5)        # x7 = A[j+1]
    sw x6, 4(x5)        # A[j+1] = A[j]
    sw x7, 0(x5)        # A[j] = A[j+1]
    jalr x0, 0(x1)      # Return to caller
# x10 = A[]
# x11 = n
sort:
    addi x2, x2, -20    # Allocate stack
    sw x1, 0(x2)        # Save ra
    sw x18, 4(x2)       # Save s2   (i)
    sw x19, 8(x2)       # Save s3   (j)
    sw x20, 12(x2)      # Save s4   (A)
    sw x21, 16(x2)      # Save s5   (n)

    add x20, x0, x10    # s4 = A
    add x21, x0, x11    # s5 = n

    add x18, x0, x0     # i = 0
L1:
    bge x18, x21, ENDL1 # Goto ENDL1 if (i >= n)
    addi x19, x18, -1   # j = i - 1
L2:
    blt x19, x0, ENDL2  # Goto ENDL2 if (j < 0)
    slli x5, x19, 2     # x5 = j * 4
    add x5, x5, x20     # x5 = A + (j * 4)
    lw x6, 0(x5)        # x6 = A[j]
    lw x7, 4(x5)        # x7 = A[j+1]
    bge x7, x6, ENDL2   # Goto ENDL2 if (A[j] <= A[j+1])
    
    add x10, x0, x20    # 1° Arg = A[]
    add x11, x0, x19    # 2° Arg = j
    jal x1, swap        # Call swap procedure

    addi x19, x19, -1   # j--
    jal x0, L2          # Goto L2
ENDL2:
    addi x18, x18, 1    # i++
    jal x0, L1          # Goto L1
ENDL1:
    add x10, x0, x20    # res = A[]

    lw x1, 0(x2)        # Restore ra
    lw x18, 4(x2)       # Restore s2
    lw x19, 8(x2)       # Restore s3
    lw x20, 12(x2)      # Restore s4
    lw x21, 16(x2)      # Restore s5
    addi x2, x2, 20     # Deallocate stack

    jalr x0, 0(x1)      # Return to caller
```
