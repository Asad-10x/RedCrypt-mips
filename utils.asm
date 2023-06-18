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
#  append_path -                Append working directory path with a file name
#  encryption_subroutine -      Encrypt data given by user
#  decryption_subroutine -	  Decrypt the encrypted data. 
#  exit_program -               Call syscall with a service 10 to exit the program
#  get_current_directory -      Retrieves the current working directory path
#  manual_input -               Prompts user to Enter the input Manually
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
welcome: .asciiz "\nWelcome to SecureCrypt.\n"
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
# subprogram:    append_path
# author:        Asad Ali
# purpose:       Appends a filename to the current working directory path
# input:         $a0 - buffer address (input/output), $a1 - filename address
# output:        gives the file name with current working path directory
# side effects:  -
.data
#
.text
append_path:
    addi $sp, $sp, -4   # Allocate space on the stack
    sw $ra, 0($sp)      # Save the return address

    move $t2, $a0       # Copy the current working directory address to $t2
    append_loop:
        lb $t3, ($t2)   # Load a character from the current working directory
        beqz $t3, append_end  # If the character is null, end the loop
        addi $t2, $t2, 1   # Move to the next character in the current working directory
        j append_loop
    append_end:
        sb $t3, ($t2)      # Replace the null character with the path separator

    append_filename:
        lb $t3, ($a1)      # Load a character from the filename
        beqz $t3, append_exit  # If the character is null, exit the loop
        sb $t3, ($t2)      # Append the character to the current working directory
        addi $t2, $t2, 1   # Move to the next character in the current working directory
        addi $a1, $a1, 1   # Move to the next character in the filename
        j append_filename

    append_exit:
        lw $ra, 0($sp)     # Restore the return address
        addi $sp, $sp, 4   # Deallocate space on the stack
        jr $ra             # Return to the calling routine    
#
# subprogram:	encryption_subroutine
# author: 		Asad Ali
# purpose: 		Takes input from data stored in a file and encrypts it. 
# input: 		$a0, filename.
# output: 		stores the encrypted data in a file and saves it as output_file
# side effects: 	-
.data
outfile: .asciiz "output_file"
eprompt: .asciiz " Enter the Data:\n "
.text
encryption_subroutine:
	la $a0, eprompt
	jal print_string

	jal manual_input

	

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
dprompt: .asciiz "\nDecryption_subroutine is still in progress. \n"
.text
decryption_subroutine:
	la $a0, dprompt
	jal print_string
	
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
# subprogram:    get_current_directory
# author:        Asad Ali
# purpose:       Retrieves the path of current working directory
# input:         -
# output:        -
# side effects:  -
.data
#
.text
get_current_directory:
    li $v0, 17          # Load the syscall code for getting the current working directory
    syscall             # Perform the syscall
    jr $ra              # Return to the calling routine
#
# subprogram: 	 manual_input
# author:        Asad Ali
# purpose:       Creates and saves the data entered by user in a file called "maninp.txt
# input:         -
# output:        -
# side effects:  -
.data
input_buffer: .space 512
.text
manual_input:
	# Take input in space "input_buffer" 
	li $v0, 8
	la $a0, input_buffer
	li $a1, 512
	syscall

	# Return to the calling subroutine
	jr $ra
	
#
# subprogram:    new_file
# author:        Asad Ali
# purpose:       Creates and saves the data entered by user in a file called "maninp.txt
# input:         -
# output:        -
# side effects:  -
.data
temp_filename: .asciiz "/home/a7d/snow/02-code/mips/encrypt-files/maninp.txt"
a_filename: .asciiz "test.txt"
temp_save_ok: .asciiz " your manual input is saved in a temporary file named "
nline: .asciiz "\n"
bufferx:     .space 256             # Allocate space for storing the current directory path

.text
new_file:
    li $v0, 17
    syscall
    
    move $a0, $v0
    la $a1, a_filename
    jal append_path

    li $v0, 4
    la $a0, a_filename
    syscall

    # Open the file
    li $v0, 13
    la $a0, temp_filename
    li $a1, 1  # create a new file in write mode
    li $a2, 0   # file permission: default
    syscall
    move $s0, $v0 # store file descriptor in $s0

    # Write user input to file
    li $v0, 15
    move $a0, $s0
    la $a1, buffer
    li $a2, 256
    syscall

    # close the opened file
    li $v0, 16
    move $a0, $s0
    syscall

    # Tell the user. 
    li $v0, 4
    la $a0, temp_save_ok
    syscall
    la $a0, temp_filename
    syscall
    la $a0, nline
    syscall
    # Program should wait for some seconds then jump to encrypt subprogram
#    j encryption_subroutine
#
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
	j invalid_input
	



