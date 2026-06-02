.global main
.text
main:
	# Allocate the stack
	addi x2, x2, -4
	sw x1, 0(x2)
	
	# Call fact procedure
	li x10, 5
	jal x1, fact
	
	# Deallocate the stack
	lw x1, 0(x2)
	addi x2, x2, 4
	
	# Printing the result
	li x17, 1
	ecall
	
	# Exiting the program
	li x10, 0
	li x17, 93
	ecall

# int fact(int n) {
# 	if (n == 0 || n == 1)
# 		return 1;
# 	return n * fact(n-1);
# }

# x10 = n

fact:
	# Allocate the stack
	addi x2, x2, -8
	sw x1, 0(x2)		# Save ra
	sw x20, 4(x2)		# Save s4
	
	# Save arguments
	mv x20, x10			# s4 = n
	
	li x5, 1			# temp = 1
	
	# Goto fact_OR if (n == 0 || n == 1)
	beq x10, x0, fact_OR
	beq x10, x5, fact_OR
	jal x0, fact_ENDOR
fact_OR:
	li x10, 1			# res = 1
	jal fact_RET		# Goto fact_RET
fact_ENDOR:
	# Call the procedure
	addi x10, x10, -1	# Arg1 = n - 1
	jal x1, fact		# Call fact procedure
	
	# Calculate the result
	mul x10, x20, x10	# ret = n * fact(n - 1)
fact_RET:
	# Deallocate the stack
	lw x1, 0(x2)
	lw x20, 4(x2)
	addi x2, x2, 8
	
	jalr x0, 0(x1)		# Return to caller
	
