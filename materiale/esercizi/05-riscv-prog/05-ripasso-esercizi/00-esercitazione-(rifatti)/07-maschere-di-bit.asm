# byte chksum(byte data) {
#     byte unos = 0, temp = data;
#     for (int i = 0; i < 7; i++) {
#         if (data & 1) unos++;
#         data = data >> 1;
#     }
#     if (unos & 1) {
#         // Dispari
#         data = data | 128;
#     } else {
#         // Pari
#         data = data & 127;
#     }
#     return data;
# }

.global main
.data
	msg1: .byte 0x69    # 0x69 = 105 = 01101001 in binario
	msg2: .byte 0x7F    # 0x7F = 127 = 01111111 in binario

    nl: .string "\n"
.text
main:
    # Allocate the stack
    addi x2, x2, -4
    sw x1, 0(x2)

    # Call chksum procedure
	la x5, msg1		# x5 = addr of msg1
	lbu x10, 0(x5)	# x5 = msg1
    jal x1, chksum      # Call chksum procedure

    # Print the result
    li x17, 35          # PrintIntBinary syscall code
    ecall               # Call PrintIntBinary syscall

    # Print the newline
    la x10, nl
    li x17, 4
    ecall

    # Call chksum procedure
	la x5, msg2		    # x5 = addr of msg2
	lbu x10, 0(x5)	    # x5 = msg2
    jal x1, chksum      # Call chksum procedure

    # Print the result
    li x17, 35          # PrintIntBinary syscall code
    ecall               # Call PrintIntBinary syscall

    # Print the newline
    la x10, nl
    li x17, 4
    ecall

    # Deallocate the stack
    lw x1, 0(x2)
    addi x2, x2, 4

    # Exit the program
    li x10, 0           # Exit Value 0
    li x17, 93          # Exit syscall code
    ecall               # Call Exit syscall

# x10 = msg

chksum:
    mv x28, x10         # x28 = msg
    li x31, 0           # u = 0
    li x30, 7           # n = 7
LOOP:
    bge x0, x30, ENDL   # Goto ENDL if (n <= 0)
    andi x5, x28, 1     # x5 = msg & 00000001
    beq x5, x0, ENDIF   # Goto ENDIF if (x5 == 0)
    addi x31, x31, 1    # u++
ENDIF:
    srli x28, x28, 1    # msg >> 1
    addi x30, x30, -1   # n--
    jal x0, LOOP        # Goto LOOP
ENDL:
    andi x5, x31, 1     # x5 = u & 00000001
    beq x5, x0, PARI    # Goto PARI if (x5 == 0)
DISP:
    ori x10, x10, 128   # x10 = msg | 10000000
    jal x0, END         # Goto END
PARI:
    andi x10, x10, 127  # x10 = msg & 01111111
END:
    jalr x0, 0(x1)      # Return to caller
