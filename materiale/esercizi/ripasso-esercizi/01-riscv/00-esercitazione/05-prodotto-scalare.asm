.global main
.data
	a: .word 1, 2, 3, 4
	b: .word 4, 3, 2, 1
	len: .word 4
.text
main:
	# Allocating the stack
	addi x2, x2, -4
	sw x1, 0(x2)
	
	# Getting the array length
	la x5, len				# x5 = addr of len
	lw x5, 0(x5)			# x5 = value of len

	# Calling the prodscal procedure
	la x10, a				# Arg1 = a[]
	la x11, b				# Arg2 = b[]
	mv x12, x5				# Arg3 = len
	jal x1, prodscal		# Call prodscal procedure
	
	# Printing the result
	li x17, 1				# PrintInt syscall code
	ecall					# Call PrintInt syscall
	
	# Deallocating the stack
	lw x1, 0(x2)
	addi x2, x2, 4
	
	# Exiting the program
	li x10, 0				# Exit Value 0
	li x17, 93				# Exit syscall code
	ecall					# Call Exit syscall

# x10 = a
# x11 = b
# x12 = len

prodscal:
	li x28, 0				# sum = 0
	li x29, 0				# i = 0
ps_LOOP:
	slli x5, x29, 2			# x5 = (i * 4)
	add x6, x5, x10			# x6 = a + (i * 4)
	add x7, x5, x11			# x7 = b + (i * 4)
	
	lw x6, 0(x6)			# x6 = a[i]
	lw x7, 0(x7)			# x7 = b[i]
	
	mul x30, x6, x7			# x30 = a[i] * b[i]
	add x28, x28, x30		# sum += a[i] * b[i]
	
	addi x29, x29, 1		# i++
	blt x29, x12, ps_LOOP	# Goto ps_LOOP if (i < n)
ps_ENDL:
	mv x10, x28				# x10 = sum
	jalr x0, 0(x1)			# Return to caller
