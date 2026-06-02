.global main
.data
	msg: .string "sum: "
.text
main:
	la x10, msg			# x10 = "sum: "
	li x17, 4			# PrintString syscall code (4)
	ecall				# Call PrintString syscall
	
	addi x10, x0, 10	# x10 = 10
	jal x1, sum			# Call sum procedure
	# now x10 (a0) has the return value of sum
	
	li x17, 1			# PrintInt syscall code (1)
	ecall				# Call PrintInt syscall
	
	li x10, 0			# Exit Value 0: No Error
	li x17, 93			# Exit syscall code (93)
	ecall				# Call Exit syscall
sum:
	li x5, 0			# sum = 0
	li x29 0			# i = 0
LOOP:
	addi x29, x29, 1	# i++
	add x5, x5, x29		# sum += i
	blt x29, x10, LOOP	# Goto LOOP until i < n
END:
	add x10, x0, x5		# ret = sum
	jalr x0, 0(x1)		# Return to caller
