########################################################################################
# Program : Recursive Bubble Sort Algorithm in MIPS
# About	  : Using Recursive Bubble Sort to sort n integer values stored in .data.
# Author  : Marios Iacovou
# Since	  : 13/04/2019
########################################################################################
	.align 2
	.data									# data segment
#The table of 15 words
table: 		.word 	60 41 29 15 23 11 99 108 1 10 111 41 59 17 891	
size:		.byte	15						# The size of the table
new_line:	.asciiz "\n"					# New line
comma:		.asciiz ", "					# Comma
before_msg:	.asciiz "Array before sort: \n"	# Message for array before sort
after_msg:	.asciiz "Array after sort: \n"	# Message for array after sort
########################################################################################
	.text				# text segment
	.globl main
main:	
	# Initiate the values used in the program
	li $t0, 0			# set the counting value equal to 0
	
	li $v0, 4			# 4 = print string syscall
	la $a0, before_msg	# load address of message for before sorting
	syscall				# Print on console
	
	la $a0, table		# Load the start address of the table
	lb $a1, size		# Load the size of the table
	jal print_array		# Print the array
	
	li $v0, 4			# 4 = print string syscall
	la $a0, new_line  	# load address of new line
	syscall				# Print on console
	
	# Call the bubble sort function
	la $a0, table		# Load the start address of the table
	lb $a1, size		# Load the size of the table
	jal bubblesort		# call bubblesort function
	
	li $v0, 4			# 4 = print string syscall
	la $a0, after_msg	# load address of message for after sorting
	syscall				# Print on console
	
	la $a0, table		# Load the start address of the table
	lb $a1, size		# Load the size of the table
	jal print_array		# Print sorted array
	
	# Exit
	li	$v0, 10    		# Exit System Call
	syscall				# Execute system call
	
########################################################################################
# Functions
########################################################################################	
# Function to print an array

print_array:
      move $t0, $a0				# $t0 has the start address of the table
      move $t1, $a1				# $t1 has the size of the table

loop_prt: 
           lw $a0, 0($t0)       # Load word from table
           li $v0, 1            # System Call print_int
           syscall              # Print on Console
		   # Print on Console
           li $v0, 4            # 4 = print questionStr syscall
           la $a0, comma   		# load address of string
           syscall				# execute the system call
           addi $t0, $t0, 4		# Move the pointer to the next word
           addi $t1, $t1, -1	# Decrease the counter
           bnez $t1, loop_prt	# Repeat until all words read

     li $v0, 4					# 4 = print questionStr syscall
     la $a0, new_line 			# load address of string
     syscall                    # execute the system call
	 
     jr $ra 			        # return to caller


########################################################################################					
# Function to sort an array using bubble sort

bubblesort:
	subu $sp,$sp,56    		# Allocate 56 bytes for the stack in memory
	sw $ra, 16($sp)    		# Store return address in $sp + 16
	sw $fp, 20($sp)    		# Store frame pointer in $sp + 20

	addiu $fp, $sp, 52 		# Set up frame pointer
	
	li $t0, 1				# Value of 1 in $t0 for comaprison with size
	bgt $a1, $t0, compute	# if size of table > 1 -> compute sorting
	j return				# if size of table = 1 -> return
	
	compute:
		li $s0, 0			# Loading 0 as first value of position x
		
		move $t1, $a0		# $t1 has the start address of the table 
		move $t2, $a1		# $t2 has the size of the table (sorting range)
		move $s1, $a1		# $s1 has the size of the table stored for later
		li $s2, 0			# $s2 indicates if a swap was performed (starts with not performed = 0)
	
		for_loop:
			lw $t3, 0($t1) 				# Load word table[i] from table	
			lw $t4, 4($t1)				# Load word table[i+1] from table	
			sgt $t5,$t3,$t4				# Set $t5 as 1 if table[i] > table[i+1] (condition for swap)
			beqz $t5, after_comparison	# If $t5 is zero then we don't swap
			
			# Swap two array cells
			move $s3, $t1				# Store pointer to restore after swap
			move $s4, $t2				# Store counter to restore after swap
			
			move $a0, $s0				# Pass table's i position and	
			addi $a1, $s0, 1			# table's i+1 position as arguments					
			jal swap					# Call swap function to swap the values
			li $s2, 1					# $s2 becomes 1 to indicate a swap was performed
			
			move $t1, $s3				# Restore pointer
			move $t2, $s4				# Restore counter
			
			after_comparison:
			addi $s0, 1					# Increment position counter
			addi $t1, $t1, 4			# Move the pointer to the next word
			addi $t2, $t2, -1			# Decrease the counter
			li $t0, 1					# Restore value of 1 in $t0 for branch
			bne $t2, $t0, for_loop		# Repeat until counter = 1 (Ran through whole table)
 
		beqz $s2, return	# If a swap wasn't performed, no more sorting is needed
		la $a0, table		# Otherwise, restore start address in argument 0,
		move $a1, $s1		# restore current size in argument 1,
		addi $a1, $a1, -1	# reduce sorting range (size of array checked) by one,
		jal bubblesort		# and bubblesort again (recursion)
		
	return:
		lw $ra, 16($sp)		# Restore previous value of return address
		lw $fp, 20($sp)		# Restore previous value of frame pointer
		addiu $sp,$sp,56	# Pop the stack
		jr $ra				# Return to caller
		
########################################################################################
# Function to swap two array cells given their positions

swap:     
	 la $t0, table          # Load the start address of the table
     mul $a0, $a0, 4        # Compute the offset for x 
     mul $a1, $a1, 4		# Compute the offset for y
     add $a0, $a0, $t0      # Compute the address of x
     add $a1, $a1, $t0      # Compute the address of y

     lw $t1, 0($a0)			# Load into $t1 the first value
     lw $t2, 0($a1)			# Load into $t2 the second value

     # Swap numbers
     sw $t2, 0($a0)			# Swap second value
     sw $t1, 0($a1)			# Swap first value
	 
     jr $ra					# Return to caller
########################################################################################