.global main
.data
	x: .string "dst"
	y: .string "src"
.text
main:
	# Allocate the stack
	addi x2, x2, -4
	sw x1, 0(x2)

	la x10, x			# Dst String
	la x11, y			# Src String
	jal x1, strcpy		# Call strcpy procedure
	
	# Deallocate the stack
	lw x1, 0(x2)
	addi x2, x2, 4

	# Exit the program
	li x10, 0
	li x17, 93
	ecall
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