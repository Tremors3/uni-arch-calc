.global main
.text
main:
	li x10, 5		# Arg: n
	jal x1 fact		# Call fact procedure
	
	li x17, 1		# PrintInt syscall code
	ecall			# Call PrintInt syscall
	
	li x10, 0		# Exit Value 0
	li x17, 93		# Exit syscall code
	ecall			# Call Exit syscall

# int fact(int n) {
# 	if (n == 0 || n == 1)
# 		return 1;
# 	return n * fact(n - 1);
# }

fact:
	addi x2, x2, -8		# Allocate stack
	sw x1, 0(x2)		# Save ra
	sw x20, 4(x2)		# Save s4 (ARGUMENT)
	
	mv x20, x10			# s4 = n
	
	li x5, 1			# temp = 1
	
	beq x20, x0, OR		# Goto OR if (n == 0)
	beq x20, x5, OR		# Goto OR if (n == 1)
	jal x0, ENDOR		# Goto ENDOR
OR:
	mv x10, x5			# ret = 1
	jal x0, END			# Goto END
ENDOR:
	addi x10, x20, -1	# xArg: n - 1
	jal x1, fact		# Call fact procedure
	mul x10, x20, x10	# ret = n * fact(n - 1)
END:
	lw x1, 0(x2)		# Restore ra
	lw x20, 4(x2)		# Restore s4
	addi x2, x2, 8		# Deallocate stack
	
	jalr x0, 0(x1)		# Return to caller