.global main
.data
	header: .string "sum: "
	nline: .string "\n"
.text
main:
	# Print the header
	la x10, header
	li x17, 4
	ecall
	
	# Allocate stack
	addi x2, x2, -4
	sw x1, 0(x2)
	
	li x10, 10				# x10 = 10
	jal x1, sum				# x10 = sum(x10) 
	
	# Print the result
	#x10 = sum(10)
	li x17, 1
	ecall
	
	# Deallocate stack
	lw x1, 0(x2)
	addi x2, x2, 4
	
	# Print the new line
	la x10, nline
	li x17, 4
	ecall
	
	# Exit program
	li x10, 0
	li x17, 93
	ecall
sum:
	li x28, 0				# sum = 0
	li x29, 0				# i = 0
sum_L1:
	addi x29, x29, 1		# i++
	add x28, x28, x29		# sum += i
	blt x29, x10, sum_L1	# Goto sum_L1 if (i < n)
	mv x10, x28				# x10 = sum
	jalr x0, 0(x1)			# Return to caller