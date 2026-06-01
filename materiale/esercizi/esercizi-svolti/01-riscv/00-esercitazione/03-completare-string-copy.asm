.global main
.data
	x: .string "dst"
	y: .string "src"
.text
main:
	la x10, x			# Set First Arg (x)
	la x11, y			# Set Second arg (y)
	jal x1, strcpy		# Call strcpy procedure
	
	li x10, 0			# Exit Value 0: No error
	li x17, 93			# Exit syscall code (93)
	ecall				# Call Exit syscall
#-------------------------------------------
strcpy:
	addi x2, x2, -4		# Allocate stack
	sw x19, 0(x2)		# Save s3
	add x19, x0, x0		# i = 0
L1:
	add x5, x19, x11	# x5 = y + (i * 1)
	lbu x5, 0(x5)		# x5 = y[i]
	add x6, x19, x10    # x6 = x + (i * 1)
	sb x5, 0(x6)		# x[i] = y[i]
	beq x5, x0, L2		# Goto L2 if (x[i] == 0)
	addi x19, x19, 1	# i++
	jal x0, L1			# Goto L1
L2:
	lw x19, 0(x2)		# Restore s3
	addi x2, x2, 4		# Deallocate stack
	jalr x0, 0(x1)		# Return to caller
#-------------------------------------------