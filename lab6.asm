# COMP 411 LAB 6 - STARTER CODE

#==================================================================================#
# DATA - DO NOT MODIFY
.data 
	A:				.space 2000  	# create string array with 20 elements * 100 char per element ( A[20][100] )
	num_strings_prompt: 	.asciiz		"Enter array size [between 1 and 20]: "
	print_prompt:		.asciiz		"The sorted array of strings is...\n"
	array_start:		.asciiz		"A["
	array_end:			.asciiz		"] = "
	newline:			.asciiz 		"\n"
	here:			.asciiz		"\nREACHED HERE\n"
#==================================================================================#	
	
.text
#==================================================================================#
# SCANNING IN INPUTS - DO NOT MODIFY
main: 
  	la $s0, A			# store address of array A in $s0
  	
	add $s1, $0, $0			# Initialize variable "size" ($s1) and set to 0.
	add $t0, $0, $0			# Initialize variable "i" ($t0) and set to 0.
	add $t1, $0, $0			# Initialize variable "j" ($t1) and set to 0.	
	add $t2, $0, $0			# Initialize variable "offset " (t2) and set to 0.

	addi $v0, $0, 4  			# System call (4) to print string.
	la $a0, num_strings_prompt 	# Put string memory address in register $a0.
	syscall           		# Print string.
	
	addi $v0, $0, 5			# System call (5) to get integer from user and store in register $v0.
	syscall				# Get user input for variable "size".
	add $s1, $0, $v0			# Copy to register $s1, b/c we'll reuse $v0.

	add $s6, $0, $0
	add $s7, $0, $0

scan_loop:
	
	beq $t0, $s1, bubble_sort	# End loop if i == size ($t0 == $s1).
	
	addi $v0, $0, 4			# System call (4) to print string.
	la $a0, array_start		# Put string memory address in register $a0.
	syscall				# Print string.
	
	addi $v0, $0, 1			# System call (1) to print integer.
	add $a0, $0, $t0			# Put integer value in register $a0.
	syscall				# Print integer.
	
	addi $v0, $0, 4			# System call (4) to print string.
	la $a0, array_end			# Put string memory address in register $a0.
	syscall				# Print string.
	
	li $v0, 8				# System call (8) to scan in string from user and store in register $v0.
	la $a0, 0($t2)			# Read A[i] (stored at address $s0 and store in $a0.
	li $a1, 100 			# Max character allowance per string.
	syscall
	
	addi $t2, $t2, 100		# Increment address of $t2 to store next string.
	addi $t0, $t0, 1			# i = i+1
	
	j scan_loop

bubble_sort: 
	addi $t3, $s1, -1 			#declaring variables
	addi $t2, $0, 100
	slt $t5, $s7, $t3 			#i<size-1
	beq $t5, $zero, print			#branch if i>size-1
	addi $s7, $s7, 1 			#i++
	addi $t1, $zero, 0 			#j=0
	j BSORT2				#jump to internal for loop

BSORT2:
	addi $t4, $s7, -1 			
	sub $t4, $t3, $t4 			#storing size-1-i
	slt $t4, $t1, $t4 			#j<(size - 1 - i)
	beq $t4, $zero, bubble_sort		#branch if j>(size-1-i)

	addi $a0, $s0, 0 			#store array address
	addi $t7, $t1, 0
	mult $t7, $t2 				#multiply by 100
	mflo $t7				#move value from lo
	add $a0, $s0, $t7 			# A[j]

	addi $a1, $s0, 0 		
	addi $t9, $t1 , 1 
	mult $t9, $t2
	mflo $t9
	add $a1, $s0, $t9			# A[j+1] of bubble sort

	jal lab_compare_strings


	addi $a0, $s0, 0 			#store array back in $a0
	addi $t7, $t1, 0 			#j
	mult $t7, $t2 				#multiply by 100
	mflo $t7 
	add $a0, $s0, $t7 			#A[j]

	addi $a1, $s0, 0 			#store array add in a1
	addi $t9, $t1 , 1 			#j+1
	mult $t9, $t2 				#multiply by 100
	mflo $t9
	add $a1, $s0, $t9 			#A[j+1}

	addi $s6, $0, 0				#reset to 0

	beq $v0, 1, lab_swap_strings

	addi $t1, $t1, 1
	j BSORT2

lab_compare_strings:
	lb $s4, ($a0)
	beq $s4, $s0, branches			#branch once words end
	lb $s5, ($a1)
	beq $s5, $s0, branches			#branch to end 


	slt $s6, $s5, $s4 			#if second letter < first
	bne $s6, $0, greater_than		#branch to greater_than

	slt $s6, $s4, $s5 			#if first letter < second letter
	bne $s6, $0, smaller_than		#branch to smaller_to
	
	addi $a0, $a0, 1			
	addi $a1, $a1, 1

	j lab_compare_strings

branches:
	beq $s4, $s5, equal			#branch if equal	
	slt $s6, $s5, $s4
	bne $s6, $0, greater_than		#branch to greater_than
	beq $s6, $0, smaller_than		#branch to smaller_than


equal:
	addi $v0, $0, 0
	j return

greater_than:
	addi $v0, $0, 1
	j return

smaller_than:
	addi $v0, $0, -1
	j return

return:
	jr $ra

lab_swap_strings:
	beq $s6,100, swap			#branch swap if $s6 == 100

	lb $t6, ($a0)
	lb $t8, ($a1)
	sb $t8, ($a0)
	sb $t6, ($a1)

	addi $a0, $a0, 1
	addi $a1, $a1, 1

	addi $s6, $s6, 1

	j lab_swap_strings

swap:
	addi $t1, $t1, 1
	j BSORT2
#==================================================================================#
# OUTPUTTING RESULTS - DO NOT MODIFY
print:
		addi $t1, $0, 0		# Initialize variable "i" ($t1) and set to 0
		addi $t2, $0, 100		# Store 100 in $t2 for multiplicative factor.
		
		addi $v0, $0, 4		# System call (4) to print string.
		la $a0, print_prompt	# Put string memory address in register $a0.
		syscall			# Print string.
print_loop:
		beq $t1, $s1, exit	# We are done printing once we have printed the same number of strings as the size.
		
		addi $v0, $0, 4		# System call (4) to print string.
		la $a0, array_start	# Put string memory address in register $a0.
		syscall			# Print string.
	
		addi $v0, $0, 1		# System call (1) to print integer.
		add $a0, $0, $t1		# Put integer value in register $10.
		syscall			# Print integer.
	
		addi $v0, $0, 4		# System call (4) to print string.
		la $a0, array_end		# Put string memory address in register $a0.
		syscall			# Print string.
		
		
		mult $t1, $t2		# Multiply i by 100 to get appropriate address of A[i].
		mflo $a0			# Put memory address of A[i] in register $a0.
		li $v0, 4			# Print string.

		syscall 	

		addi $t1, $t1, 1 		# Increment i by 1.

	j print_loop

exit:
  	addi	$v0, $0, 10			# sys call 10 is for exit
  	syscall
#==================================================================================#