.global main
.data
	x: .word 1, 2, 3, 4
	y: .word 4, 3, 2, 1
	len: .byte 4
.text
main:
	la x5, len			# x5 = addr of len
	
	la x10, x			# Arg1 = x
	la x11, y			# Arg2 = y
	lb x12, 0(x5)		# Arg3 = len
	jal x1, prodscal	# Call prodscal procedure
	
	li x17, 1			# PrintInt syscall code
	ecall				# Call PrintInt syscall
	
	# The exit value is the procedure result
	li x10, 0			# Exit Value 0: No Error
	li x17, 93			# Exit syscall code
	ecall				# Call Exit syscall

# x10 = x
# x11 = y
# x12 = len

prodscal:
	addi x30, x30, 0	# sum = 0
	addi x29, x29, 0	# i = 0
LOOP:
	bge x29, x12, END	# Goto END if (i >= len)
	
	slli x5, x29, 2		# x5 = i * 4
	add x6, x5, x10		# x6 = x + (i* 4)
	add x7, x5, x11		# x7 = y + (i * 4)
	
	lw x6, 0(x6)		# x6 = x[i]
	lw x7, 0(x7)		# x7 = y[i]
	
	mul x5, x6, x7		# x5 = x[i] * y[i]
	add x30, x30, x5	# sum = x[i] * y[i]
	
	addi x29, x29, 1	# i++
	jal x0, LOOP		# Goto LOOP
END:
	mv x10, x30			# ret = sum
	jalr x0, 0(x1)		# Return to caller