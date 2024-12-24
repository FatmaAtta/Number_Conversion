.data
#input sentences to be printed
inputNum: .asciiz "Enter the number you want to convert (use capital letters)\n"
inputFrom: .asciiz "Enter the number's base\n"
inputTo: .asciiz "Enter the desired base\n"

number: .space 100             # Allocate space for number input
from: .word 0                  # Initialize the base variable to 0
to: .word 0                    # Initialize the desired base variable to 0

errorStatement: .asciiz " doesn't belong to the system "

.text
main:
# Input the number
la $a0, inputNum
li $v0, 4
syscall
la $a0, number                # Store the input in 'number'
li $a1, 100                    # Max size of input
li $v0, 8                      # Syscall to read a string
syscall

# Input the base
la $a0, inputFrom
li $v0, 4
syscall
li $v0, 5                      # Syscall to read an integer (base)
syscall
sw $v0, from                   # Store the base in 'from'

# Input the desired base
la $a0, inputTo
li $v0, 4
syscall
li $v0, 5                      # Syscall to read an integer (desired base)
syscall
sw $v0, to                     # Store the base in 'to'

# Validate the input number
la $t0, number
j loop

loop:
    lb $t1, 0($t0)             # Load the next character of 'number'
    beqz $t1, end_loop         # If it's null, end the loop

    # Validate the character based on the base
    la $t3, from
    lw $a0, 0($t3)             # Load base from 'from'
    move $a1, $t1
    # Check if the character is valid for the given base
    jal validate

    #addi $t0, $t0, 1           # Increment the pointer to the next character
    #j loop

increment:
    addi $t0, $t0, 1           # Increment the pointer to the next character
    j loop

validate:
    # Validate current character based on the base
    # a0 is the current character, a1 is the base
    ble $a0, 10, if_con        # If base <= 10, check valid digits 0-9
    j else_con                 # Otherwise, check valid digits A-F

if_con:
    addi $t1, $a0, 48          # Convert base to ASCII offset (48 = '0')
    bge $a1, $t1, print_error  # If char >= base, print error
    #jr $ra                      # Return from validate
    j increment

else_con:
    addi $t1, $a0, 55          # Convert base to ASCII offset (55 = 'A')
    bge $a1, $t1, print_error  # If char >= base, print error
    #jr $ra       
    j increment               # Return from validate
    

print_error:
    # Print the error message
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

    li $a0, 10                 # Print newline
    li $v0, 11
    syscall

    j exit

end_loop:
    j exit

exit:
    li $v0, 10
    syscall
