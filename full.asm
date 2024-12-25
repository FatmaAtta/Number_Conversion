.data
#input sentences to be printed
inputNum: .asciiz "Enter the number you want to convert (use capital letters)\n"
inputFrom: .asciiz "Enter the number's base\n"
inputTo: .asciiz "Enter the desired base\n"

output: .asciiz "The number in the new base:"

digits: .byte '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' 
endl: .asciiz "\n"

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
    #j convert
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
    j convert

exit:
    li $v0, 10
    syscall
    
convert:
	la $a1, digits
	li $s0 , 0
	lw $t0, from
	lw $t2, to
	la $a0, number
	li $a1, 100
	jal outputStatement
 	jal OtherToDecimal
 getDecToOther:
	jal DecimalToOther
	li $v0, 10
 	syscall
	
outputStatement:
	# Input the base
	la $a0, output
	li $v0, 4
	syscall

######################################### OTHER TO DECIMAL ############################################## 
# [1] Other To Decimal Function
OtherToDecimal: 
     la $t3, number
     li $t5, 0 # size of number entered in other base 
     jal countNumberLength
     
     addi $t5, $t5, -1
     add $t6, $t5, $zero # size of the string 
     addi $t6, $t6, -1
    
    
     li $s3, 1 # The result of the power
     jal GetPower
     
     li $t6, 0 # index of the string 
     li $t1, 0 # result << decimal >> 
    
     la $t3, number
     InnerLoop:
     beq $t6, $t5, EndOtherToDecimal
        lb $t7, 0($t3)
     
        jal GetCharchterIndex
        
        mul $a3, $t8, $s3
        add $t1, $t1, $a3
        addi $t6, $t6, 1
        div $s3, $t0 
        mflo $s3
        
        addi $t3, $t3, 1
     
     j InnerLoop
        
EndOtherToDecimal:
     #li $v0, 1
     #move $a0, $t1
     #syscall
     
     li $v0, 4
     la $a0, endl
     syscall
  
     jal getDecToOther
     
      li $v0, 10
     syscall
 
   
# [2] Get the length of the string
countNumberLength:
       lb $t4, 0($t3) 
       beqz $t4, EndLength
       addi $t5, $t5, 1
       addi $t3, $t3, 1 
       j countNumberLength      
EndLength:
       jr $ra 


# [3] GET THE POWER 
GetPower: 
     beqz $t6, EndPower
     mul $s3, $s3, $t0
     addi $t6, $t6, -1
     j GetPower   
EndPower: 
    
     jr $ra 


# [4] Get the Charchter Index in the digits array 
# t7: charchter  we want to search for 
# t8: The result of the index in the digits string is stored here 
GetCharchterIndex:
    la $s4, digits         
    li $t8, 0              
    li $t9, 16             
    
IndexLoop:
    beq $t8, $t9, EndGetCharacterIndex 
    lb $a3, 0($s4)                    
    beq $a3, $t7, EndGetCharacterIndex 
    
    addi $s4, $s4, 1         
    addi $t8, $t8, 1      
    j IndexLoop              

EndGetCharacterIndex:
    jr $ra                   
###############################################################################################

 DecimalToOther:
 beq $t1 , 0 , dto_end_loop
 div $t1, $t2
 mflo $t1
 mfhi $t5
 
 la $a0, digits
 add $t6, $a0,$t5
 lb  $t7,0($t6)
 
 addi $sp, $sp, -1
 sb   $t7, 0($sp)
 addi $s0, $s0 , 1
 j DecimalToOther
 
 dto_end_loop:
 beq $s0 , 0, done 
 lb $a0, 0($sp)
 addi $sp, $sp, 1 
 addi $s0, $s0, -1
 
 li $v0, 11
 syscall

 j dto_end_loop 
 
 done:
 jr $ra 
