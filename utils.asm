#  File:     utils.asm
#  Purpose:  To define utilities which will be used in MIPS Program
#  Author:   Asad Ali
# 
#  Title to and ownership of all intellectual property 
#  rights in this file are the exclusive property of
#  Asad Ali, Lahore, PK
# 
#  Subprograms Index:
#  welcome_script-		  Introductry text. 
#  clear_screen - 		  Clears the output from the screen `system("clear/cls");`
#  Invalid_input - 		  Prints a prompt on screen to notify user if he made the wrong choice
#  sleep - 				  press any key to continue
#  encryption_subroutine -      Encrypt data given by user
#  decryption_subroutine -	  Decrypt the encrypted data. 
#  exit_program -               Call syscall with a service 10 to exit the program
#  new_file -                   Creates and saves the manual input in a file
#  print_string - 		  Prints the data(string) on output screen
#  print_int - 			  Prints the data(integer) on output screen
#  main_menu - 			  Prints the menu of this program and let's user choose what they wanna do
#
# subprogram:		welcome_script
# author:			Asad Ali
# purpose:			Print an introductry output when program starts
# input: 			-
# output:			-
# side effects: 		-
.data
welcome: .asciiz "\nWelcome to RedCrypt.\n"
nline: .asciiz "\n"
.text
welcome_script:
	# print introduction
	li $v0, 4
	la $a0, welcome
	syscall
	
	# print new line
	la $a0, nline
	syscall
	
	# jump back to calling subroutine
	jr $ra
#
# subprogram: 	clear_screen
# author: 		Asad Ali
# purpose: 		Clears the output screen
# input: 		-
# output: 		-
# side effects: 	Clears the output screen
.data
buffer: .space 1
.text
clear_screen:
	# Press Any key to continue
	li $v0, 8
	la $a0, buffer
	li $a1, 1
	syscall
	
	# Clear Screen 
	li $v0, 11
	la $a0, '\0'
	syscall
	jr $ra
#
# subprogram:    invalid_input
# author:        Asad Ali
# purpose:       Notify User of his invalid input in the program
# input:         -
# output:        -
# side effects:  Notifies the user and clears the screen for user to try again
.data
preclr_prompt: .asciiz "\n Sorry, Invalid Input ! Please try again. \n"
.text
invalid_input:
	li $v0, 4
	la $a0, preclr_prompt
	syscall
	
	jal sleep
	
	j main_menu
#
# subprogram:    sleep
# author:        Asad Ali
# purpose:       to wait for the to press a key to continue in the program. 
# input:         -
# output:        -
# side effects:  hold further execution of the program until user continues
.data
sbuffer: .space 1
.text
sleep:
	li $v0, 8
	la $a0, sbuffer
	li $a1, 1
	syscall
	
	jr $ra		# jump back to calling subroutine    
#
# subprogram:	encryption_subroutine
# author: 		Asad Ali
# purpose: 		Takes input from user and encrypts it. 
# input: 		$a0, filename.
# output: 		stores the encrypted data in a file and saves it as output_file
# side effects: 	-
.data
output_file: .asciiz "/home/a7d/snow/02-code/mips/securecrypt-mips/encrypted.txt"
eprompt: .asciiz " Enter the Data:\n "
input_buffer: .space 128
key: .word 0x55      # XOR encryption key

.text
encryption_subroutine:
	la $a0, eprompt
	jal print_string

    	# Read the input from the user
    	li $v0, 8
    	la $a0, input_buffer
    	li $a1, 128
    	syscall

    # Open the output file for writing
    li $v0, 13
    la $a0, output_file
    li $a1, 1    # 1 for write mode
    li $a2, 0    # Permissions (ignored)
    syscall
    move $s0, $v0    # Save the file descriptor

    # Encrypt and write the data to the file
    la $t0, input_buffer
    la $t1, key
loop:
    lb $t2, ($t0)      # Load a byte from input
    beqz $t2, done     # Exit the loop if end of input
    lw $t3, ($t1)      # Load the encryption key
    xor $t2, $t2, $t3  # XOR operation
    sb $t2, ($t0)      # Store the encrypted byte
    addiu $t0, $t0, 1  # Increment input pointer
    j loop

done:
    # Write the encrypted data to the file
    li $v0, 15
    move $a0, $s0
    la $a1, input_buffer
    li $a2, 128
    syscall

    # Close the file
    li $v0, 16
    move $a0, $s0
    syscall
    
	jal sleep
	j main_menu
#
# subprogram:    decryption_subroutine
# author:        Asad Ali
# purpose:       Decrypts the encrypted data.
# input:         -
# output:        -
# side effects:  Makes an output file & stores the decrypted data in that file.
.data
dprompt: .asciiz"\nEnter the encrypted Message:-\n"
decipher: .asciiz "/home/a7d/snow/02-code/mips/securecrypt-mips/deciphered.txt"
.text
decryption_subroutine:
	# Print out dprompt on the Output Screen
	la $a0, dprompt
	jal print_string
	
    	# Read the input from the user
    	li $v0, 8
    	la $a0, input_buffer
    	li $a1, 128
    	syscall

    # Open the output file for writing
    li $v0, 13
    la $a0, decipher
    li $a1, 1    # 1 for write mode
    li $a2, 0    # Permissions (ignored)
    syscall
    move $s0, $v0    # Save the file descriptor

    # Encrypt and write the data to the file
    la $t0, input_buffer
    la $t1, key
dloop:
    lb $t2, ($t0)      # Load a byte from input
    beqz $t2, done     # Exit the loop if end of input
    lw $t3, ($t1)      # Load the encryption key
    xor $t2, $t2, $t3  # XOR operation
    sb $t2, ($t0)      # Store the encrypted byte
    addiu $t0, $t0, 1  # Increment input pointer
    j dloop

ddone:
    # Write the encrypted data to the file
    li $v0, 15
    move $a0, $s0
    la $a1, input_buffer
    li $a2, 128
    syscall

    # Close the file
    li $v0, 16
    move $a0, $s0
    syscall
    
	jal sleep
	j main_menu
#
# subprogram:    exit_program
# author:        Asad Ali
# purpose:       Exits the program
# input:         -
# output:        -
# side effects:  -
.data
#
.text
exit_program:
    # Exit program
    li $v0, 10
    syscall
#	
# subprogram: 	 print_string
# author:        Asad Ali
# purpose:       Prints the string provided in argument
# input:         the address of string in $a0
# output:        -
# side effects:  -
.data
#
.text
print_string:
	li $v0, 4
	syscall

	jr $ra
#
# subprogram: 	 print_int			
# author:        Asad Ali
# purpose:       Prints the string provided in argument
# input:         copy the int value in $a0
# output:        -
# side effects:  -
.data
#
.text
print_int:
	li $v0, 1
	syscall

	jr $ra
#
# subprogram:    main_menu
# author:        Asad Ali
# purpose:       Prints a menu for user to choose b/w encryption or decryption
# input:         -
# output:        -
# side effects:  -
.data
prompt: .asciiz "\nChoose between Following:\n1) Encrypt Data\n2) Decrypt Data\n0) Exit\n_:"
.text
main_menu:
	li $v0, 4
	la $a0, prompt
	syscall
	
	# Take the choice from user
	li $v0, 5
	syscall
	
	# Move the Choice for check
	move $t0, $v0
	
	# Check conditions
	beqz $t0, exit_program
	beq $t0, 1, encryption_subroutine
	beq $t0, 2, decryption_subroutine
	jr $ra
