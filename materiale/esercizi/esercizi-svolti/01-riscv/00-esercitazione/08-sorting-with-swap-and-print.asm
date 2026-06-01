.global main
.data
	numv:	.byte 10
	vett:	.word 8, 3, 9, 2, 5, 6, 1, 0, 2, 2
	
	sep:	.string ", "
.text

# 	int* sort(int A[], int n)
#		for (i = 0; i < n-1; i++) {
#			for (j = 0; j < n-1-i; j++) {
#				if (A[j] > A[j+1]) {
#					swap(A[j], A[j+1]);
#				}
#			}
#		}
#
#	void swap(int *e) {
#		int temp = *e;
#		*e = *(e+1)
#		*(e+1) = temp;
#	}

main:
	addi 	x2, x2, -4		# Allocate stack
	sw 		x20, 0(x2)		# Save s4 (numv)
	
	la 		x5, numv		# x25 = addr of numv
	lbu 	x20, 0(x5)		# x20 = numv
	
	la 		x10, vett		# Arg1: vett
	mv 		x11, x20		# Arg2: numv
	jal 	x1, sort		# Call sort
	
	la 		x10, vett		# Arg1: vett
	mv 		x11, x20		# Arg2: numv
	jal 	x1, print		# Call print
	
	lw		x20, 0(x2)		# Restore s4
	addi	x2, x2, 4		# Deallocate stack
	
	li 		x10, 0			# Exit Value 0
	li 		x17, 93			# Exit syscall code
	ecall					# Call Exit syscall


swap:
	lw 		x5, 0(x10)		# temp1 = vett[j]
	lw 		x6, 4(x10)		# temp2 = vett[j+1]
	sw 		x6, 0(x10)		# vett[j] = temp2
	sw		x5, 4(x10)		# vett[j+1] = temp1
	jalr 	x0, 0(x1)		# Return to caller


sort:
	addi 	x2, x2, -20		# Allocate stack
	sw 		x1, 0(x2)		# Save ra
	sw 		x19, 4(x2)		# Save s3 (i)
	sw 		x20, 8(x2)		# Save s4 (j)
	sw 		x21, 12(x2)		# Save s5 (n-1)
	sw 		x22, 16(x2)		# Save s6 (vett)
	
	mv 		x22, x10		# x22 = vett
	addi 	x21, x11, -1	# x21 = n - 1
	
	add		x19, x0, x0		# i = 0
FOR1:
	bge 	x19, x21, END1	# Goto END1 if (i >= n - 1)
	sub 	x28, x21, x19	# x28 = n - 1 - i
	add 	x20, x0, x0		# j = 0
FOR2:
	bge 	x20, x28, END2	# Goto END2 if (j >= n - 1 - i)
	slli 	x5, x20, 2		# x5 = j * 4
	add 	x5, x5, x22		# x5 = vett + (j * 4)
	
	lw 		x6, 0(x5)		# x6 = vett[j]
	lw 		x7, 4(x5)		# x7 = vett[j+1]

	ble 	x6, x7, ENDIF	# Goto ENDIF if (vett[j] <= vett[j+1])
	mv 		x10, x5			# Arg: x10 = vett + (j * 4)
	jal 	x1, swap		# Call swap procedure
ENDIF:
	addi 	x20, x20, 1		# j++
	jal 	x0, FOR2		# Goto FOR2
END2:
	addi 	x19, x19, 1		# i++
	jal 	x0, FOR1		# Goto FOR1
END1:
	mv 		x10, x22		# ret = vett

	lw 		x1, 0(x2)		# Restore ra
	lw 		x19, 4(x2)		# Restore s3
	lw 		x20, 8(x2)		# Restore s4
	lw 		x21, 12(x2)		# Restore s5
	lw 		x22, 16(x2)		# Restore s6
	addi	x2, x2, 20		# Deallocate stack
	
	jalr	x0, 0(x1)		# Return to caller


print:
	mv 		x28, x10		# x28 = vett
	
	slli 	x30, x11, 2		# x30 = n * 4
	add 	x30, x30, x28	# x30 = vett + (n * 4)
PLOOP:
	beq		x28, x30, PEND	# Goto PEND if (&p == &(vett + n))
	lw		x10, 0(x28)		# x10 = *p

	li		x17, 1			# PrintInt syscall code
	ecall					# Call PrintInt syscall
	
	addi	x28, x28, 4		# x28 = &(p + 1)
	
	beq		x28, x30, PENDF	# Goto PENDF if (&(p + 1) == &(vett + n))
	la		x10, sep		# Set sep val
	li		x17, 4			# PrintString syscall code
	ecall					# Call PrintString syscall
PENDF:
	jal 	x0, PLOOP		# Goto PLOOP
PEND:
	jalr 	x0, 0(x1)		# Return to caller
