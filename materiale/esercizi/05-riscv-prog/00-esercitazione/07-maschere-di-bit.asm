.global main
.data
	msg1: .byte 0x69    # 0x69 = 105 = 01101001 in binario
	msg2: .byte 0x7F    # 0x7F = 127 = 01111111 in binario
	
	newline: .string "\n"
.text
main:
	la x5, msg1		# x5 = addr of msg1
	lbu x10, 0(x5)	# x5 = msg1
	jal x1, chkpar	# Call chkpar procedure
	
	li x17, 35		# PrintIntBinary syscall code
	ecall			# Call PrintIntBinary syscall

	la x10, newline	# New Line
	li x17, 4		# PrintString syscall code
	ecall			# Call PrintString syscall

	la x5, msg2		# x5 = addr of msg2
	lbu x10, 0(x5)	# x5 = msg2
	jal x1, chkpar	# Call chkpar procedure
	
	li x17, 35		# PrintIntBinary syscall code
	ecall			# Call PrintIntBinary syscall
	
	li x10, 0		# Exit Value 0
	li x17, 93		# Exit syscall code
	ecall			# Call Exit syscall

# char chkpar (char msg) {
#		int n = 7, u = 0;
#		for (int n = 7; n > 0; n--) {
#			if ((msg & 1) == 0) {
#				// bit meno significativo = 1
#				u += 1;
#			}
#			msg >>= 1;
#		}
#		
#		if ((u & 1) == 0) {
#			// Numero PARI di uni
#			return msg & 127;
#		}
#		
#		// Numero DISPARI di uni
#		return msg | 128
#	}

chkpar:
	mv x28, x10			# x28 = msg
	li x31, 0			# u = 0 (unos counter)
	li x30, 7			# n = 7 (iterations)
LOOP:
	bge x0, x30, ENDL	# Goto END if (n <= 0)
	andi x5, x28, 1		# x5 = msg & 00000001
	beq x5, x0, ENDIF	# Goto ENDIF if (x5 == 0)
	addi x31, x31, 1	# u += 1
ENDIF:
	srli x28, x28, 1	# msg >> 1
	addi x30, x30, -1	# n -= 1
	jal x0, LOOP		# Goto LOOP
ENDL:
	andi x5, x31, 1     # x5 = u & 00000001
	beq x5, x0, PARI	# Goto PARI if (x5 == 0)
DISP:
	ori x10, x10, 128	# x10 = msg | 10000000
	jal x0, END
PARI:
	andi x10, x10, 127	# x10 = msg & 01111111
END:
	jalr x0, 0(x1)		# Return to caller
