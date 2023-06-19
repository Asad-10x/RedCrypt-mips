.include "utils.asm"
.data

.text
.globl main

main:
	jal welcome_script
	
	jal sleep
	
	jal main_menu
	

	
