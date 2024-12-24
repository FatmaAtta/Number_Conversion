.data
#input sentences to be printed
inputNum: .asciiz "Enter the number you want to convert (use capital letters)\n"
inputFrom: .asciiz "Enter the number's base\n"
inputTo: .asciiz "Enter the desired base\n"

number: .asciiz
from: .word
to: .word

numberValidation: .asciiz "0123456789ABCDEF"

global_t0: .byte

errorStatement: .asciiz " doesn't belong to the system "
.text
main:
#input the number
la $a0, inputNum
li $v0, 4
syscall
la $a0, number #stores the input in a0 in variable inputNum
li $a1, 100 #max size of input
li $v0, 8 #syscall to read a string
syscall
#input the base
la $a0, inputFrom
li $v0, 4
syscall
la $a0, from #stores the input in a0 in variable inputNum
li $v0, 5 #syscall to read an int
syscall
sw $v0, from
#input the desired base
la $a0, inputTo
li $v0, 4
syscall
la $a0, to #stores the input in a0 in variable inputNum
li $v0, 5 #syscall to read a string
syscall

function_validate:
	#validate(t0 = num, t1 = base)
	la $t0, number
	j loop
loop:
	lb $t1, 0($t0)
	beqz $t1, end_loop
	#body
	addi $t2, $t0, $t1
	lb $a0, 0($t2)
	la $t3, from
	lw $a1, 0($t3)
	j validate
	addi $t0, $t0, 1 #increment
	
validate:
	#a0 is the current char, a1 is the base
	#if base<=10
		#if a0 >= base+48 go to printError
	#else 
		#if a0 >= base+55 go to printError
	ble $a1, 10, if_con
	j else_con
	jr $ra
if_con:
	addi $t1, $a1, 48
	bge $a0, $t1, print_error
	jr $ra	
else_con:	
	addi $t1, $a1, 55
	bge $a0, $t1, print_error
	jr $ra
print_error:
	#load the number, base, error statement
	la $a0, number
	li $v0, 4
	syscall
	
	la $a0, errorStatement
	li $v0, 4
	syscall
	
	lw $t0, from
	move $a0, $t0
	li $v0, 1
	syscall
	
	li $a0, 10 #ascii of newline
	li $v0, 11 #code for printing a char
	syscall
	
	j exit

end_loop:
	j exit
	
exit:
	li $vo, 10
	syscall

