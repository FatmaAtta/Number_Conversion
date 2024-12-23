.data
#input sentences to be printed
inputNum: .asciiz "Enter the number you want to convert (use capital letters)\n"
inputFrom: .asciiz "Enter the number's base\n"
inputTo: .asciiz "Enter the desired base\n"

number: .asciiz
from: .word
to: .word

numberValidation: .asciiz "0123456789ABCDEF"

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
li $a1, 100 #max size of input
li $v0, 8 #syscall to read a string
syscall
#input the desired base
la $a0, inputTo
li $v0, 4
syscall
la $a0, to #stores the input in a0 in variable inputNum
li $a1, 100 #max size of input
li $v0, 8 #syscall to read a string
syscall

function_validate:
	#validate(t0 = num, t1 = base)
	


