    .text
    .globl main

main:
    li $t0, 5          #$t0 is the number being checkec, up to the upper limit (500)
    li $t1, 500        #$t1 is the upper limit

loop:
    bgt $t0, $t1, exit  #End condition: if the counter is greater than the upper limit

    li $t4, 0          #$t4 will store the sum of divisors
    li $t2, 1          #$t2 will be used to increment the divisor, for each value of integer $t0
    jal perfect

    #If the return value is 1, we found a perfect number and print it. Otherwise, we increment and check the next integer        
    beq $v0, 1, printer 
    addi $t0, $t0, 1   
    j loop             

printer:                  # Print routine
    li $v0, 4          #Printing the found message
    la $a0, msg1        
    syscall

    move $a0, $t0      #Printing the number
    li $v0, 1          
    syscall

    li $v0, 4          
    la $a0, nl        #We print a gap after
    syscall

    addi $t0, $t0, 1   
    j loop             

exit:
    li $v0, 10         
    syscall

perfect:
    div $t0, $t2   
    mfhi $t3    #Fetching the remainder

    #If the remainder is not zero, it is not a divisor. We move forward       
    bne $t3, $0, incrementer 

    #Otherwise, it is a divisor.
    mflo $t3

    #Add the newly found divisor to the sum
    add $t4, $t4, $t2   

incrementer:
    #incrementing the divisor
    addi $t2, $t2, 1

    #If it is less than the number being checked, we check the next one    
    blt $t2, $t0, perfect 


#At this point, we got out of the loop. We check if the sum is equal to the original number
#If the sum is equal to the number, then we call isPerfect, which will return 1
beq $t4, $t0, isPerfect 

#Otherwise, we return 0
li $v0, 0               
jr $ra

isPerfect:
    li $v0, 1               
    jr $ra


.data
msg1: .asciiz "Perfect Number found:\n"
nl:     .asciiz "\n\n"