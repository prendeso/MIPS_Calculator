##########################################################
#   Calculator, by Orlando Prendes for CDA 3101 class    #
# This program performs basic operations like addition,  # 
# subtraction, multiplication and division, and prints   # 
# the result. The input needs to be an integer. Overflow #
# and division for zero are handled.			 #
##########################################################
READ_INT = 5
READ_STRING = 8
READ_CHARACTER = 12
WRITE_INT    = 1
WRITE_CHARACTER = 11
WRITE_STRING = 4
EXIT         = 10

	.text
	.globl main
main:	
   
   li	$v0, WRITE_STRING	        # Ask user to input number
	la	$a0, int		
	syscall

   li $v0, READ_INT                     # Read user's input number
   syscall

   move  $s0, $v0                       # Save input number

operation: 
   li $v0, WRITE_STRING                 # Ask user to input operator
   la $a0, op    
   syscall

   la $a0,input                         # Read user input operator
   li $a1,3
   li $v0, READ_STRING
   syscall
   lb $t0, 0($a0)
   
   beq $t0,'+',caseADDITION             # Branches to select the operation to perform
   beq $t0,'-',caseSUBSTRACTION
   beq $t0,'*',caseMULTIPLICATION
   beq $t0,'/',caseDIVISION
   beq $t0,'%',caseMODULO
   beq $t0,'c',caseCLEAR
   beq $t0,'e',caseEXIT 

   li $v0, WRITE_STRING                 # Wrong operator prompt
   la $a0, illegal    
   syscall

   j operation                          # Jump to input operator

caseADDITION:                           # Case to perform integer addition
   
   li $v0, WRITE_STRING                 # Ask user to input second number
   la $a0, int    
   syscall

   li $v0, READ_INT                     # Read user's second input number
   syscall

   move  $s1, $v0                       # Save second input number

   add $s0,$s0,$s1                      # Performs integer addition

   j displayRESULT                      # Jump to display result

caseSUBSTRACTION:                       # Case to perform integer substraction

   li $v0, WRITE_STRING                 # Ask user to input second number
   la $a0, int    
   syscall

   li $v0, READ_INT                     # Read user's second input number
   syscall

   move  $s1, $v0                       # Save second input number

   sub $s0,$s0,$s1                      # Performs integer substraction

   j displayRESULT                      # Jump to display result

caseMULTIPLICATION:                     # Case to perform integer multiplication

   li $v0, WRITE_STRING                 # Ask user to input second number
   la $a0, int    
   syscall

   li $v0, READ_INT                     # Read user's second input number
   syscall

   move  $s1, $v0                       # Save second input number

   mult $s0,$s1                         # Performs integer multiplication

   mfhi $t8                             # Load upper 32 bits of the multiplication result

   mflo $s0                             # Load lower 32 bits of the multiplication result

   bne $t8,$zero,OVERFLOW               # Check for overflow

   j displayRESULT                      # Jump to display result

caseDIVISION:                           # Case to perform integer division

   li $v0, WRITE_STRING                 # Ask user to input second number
   la $a0, int    
   syscall

   li $v0, READ_INT                     # Read user's second input number
   syscall

   move  $s1, $v0                       # Save second input number

   beq $s1,$zero,zeroDIVISION           # Check for zero divisor

   div $s0,$s1                          # Performs integer division

   mflo $s0                             # Load division quotient

   j displayRESULT                      # Jump to display result

caseMODULO:                             # Case to perform the modulo operation between two integers

   li $v0, WRITE_STRING                 # Ask user to input second number
   la $a0, int    
   syscall

   li $v0, READ_INT                     # Read user's second input number
   syscall

   move  $s1, $v0                       # Save second input number

   beq $s1, $zero,zeroMODULO            # Check for zero divisor

   div $s0,$s1                          # Performs integer division

   mfhi $s0                             # Load division remainder

   j displayRESULT                      # Jump to display result

caseCLEAR:                              # Case to clear the state to zero
   
   move $s0, $zero                      # Clear state

   j displayRESULT                      # Jump to display result

caseEXIT:                               # Case to exit

   li $v0, WRITE_STRING                 # Exit message
   la $a0, gb    
   syscall

   li $v0, EXIT                         # Exit
   syscall

zeroDIVISION:

   li $v0, WRITE_STRING                 # Division by zero error message
   la $a0, division    
   syscall

   j caseDIVISION                       # Jump to enter new divisor

zeroMODULO:

   li $v0, WRITE_STRING                 # Division by zero error message
   la $a0, division    
   syscall

   j caseMODULO                         # Jump to enter new divisor

OVERFLOW:

   move $t8, $zero                      # Clear $t8

   li $v0, WRITE_STRING                 # Overflow message
   la $a0, overflow    
   syscall
   
   move $s0, $zero                      # Clear state
   
   j displayRESULT                      # Display the result

displayRESULT:

   move  $a0, $s0                       # Display the result
   li $v0, WRITE_INT
   syscall

   li $v0, WRITE_STRING                 # Inserts new line after displaying result
   la $a0, space    
   syscall

   j operation                          # Jump to input operator




###########################################
#	       Data Segment     	 #
##########################################

		.data
space: .asciiz "\n"      
int:		.asciiz "int: "
op:     .asciiz "op: "
illegal:     .asciiz "Illegal operator, must be one of +,-,*,/,%,c,e. Please try again.\n"
division:     .asciiz "'Attempting to divide by zero. Please enter a new divisor.\n"
overflow:     .asciiz "Overflow, state reset to 0.\n"
gb:     .asciiz "Goodbye\n"
		.end
input:          .space 3

