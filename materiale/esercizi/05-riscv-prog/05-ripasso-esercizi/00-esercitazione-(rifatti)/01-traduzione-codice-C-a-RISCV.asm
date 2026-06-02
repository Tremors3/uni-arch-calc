.global main
.data
	header: .string  "i: "
	nline: .string  "\n"
.text
main:
	addi x5, x0, 10		# n = 10
	add x29, x0, x0		# i = 0
LOOP:
	addi x29, x29, 1	# i++
	
	# Printing the header
	la x10, header
	li x17, 4
	ecall
	
	# Printing the index
	mv x10, x29
	li x17, 1
	ecall
	
	# Printing the newline
	la x10, nline
	li x17, 4
	ecall
	
	blt x29, x5, LOOP	# Goto LOOP if (i < n)
ENDL:

	# Exit the program 
	# with exit value 0
	li x10, 0
	li x17, 93
	ecall