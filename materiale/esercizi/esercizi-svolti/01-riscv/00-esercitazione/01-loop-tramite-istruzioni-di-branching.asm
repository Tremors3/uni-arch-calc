.global main
.text

# We use the register x10 (a0) directly as the counter, 
#   so we avoid one unnecessary "mv" instruction.

main:
	addi x5, x0, 10		# n = 10
	addi x10, x0, 0		# i = 0
	li x17, 1       	# PrintInt (1): print an integer
LOOP:
	addi x10, x10, 1    # i++
	ecall               # Call PrintInt syscall
	blt x10, x5, LOOP   # Goto LOOP until i < n
END:
	li x10, 0			# 0 Exit Value: No error
	li x17, 93			# Exit (93): exit from program
	ecall				# Call Exit syscall
