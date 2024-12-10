    .text
    .globl main

main:
    li $v0, 4 
    la $a0, msg1   #Beginning by prompting the user about what the program does
    syscall

    la $t0, table   # Loading the address of the  table
    lw $t1, N       # Loads the value of N into $t1

    #$t2 will be used to store the smallest, $t3 will be used to store the largest, $t4 will be used to store the counter

    lw $t2, 0($t0)  # Assuming that the first element of the table is the smallest
    lw $t3, 0($t0)   # Assuming that the first element of the table is the largest
    li $t4, 1       # initialize the counter at 1

loop:
    bge $t4, $t1, exitloop      #The program exits the loop if the counter is greater than or equal to the size of the table, and prints the values

    #Retrieve the offset corresponding to the increment (i in bytes), by multiplying by 4 (double shift to the left)
    sll $t5, $t4, 2

    #We add that offset to the original address of the table, and store it back to $t5 ( new address i = address (table[0] + 4bytes*i )
    add $t5, $t0, $t5  

    #We now read the value in the table at the offet matching the increment table[i]  
    lw $t6, ($t5)          

    blt $t6, $t2, setNewMin #if the new value table[i] < smallest, we update the smallest
    bgt $t6, $t3, setNewMax  #if the new value table[i] > largest, we update the largest
    j loopNext #the second part of the loop

setNewMin:
    move $t2, $t6          # smallest = table[i]
    j loopNext

setNewMax:
    move $t3, $t6          # largest = table[i]

loopNext:
    addi $t4, $t4, 1       # i = i + 1
    j loop  #Go back to the loop

exitloop:
    #We now print the smallest value
    li $v0, 4 
    la $a0, MsgSmallest  
    syscall

    li $v0, 1              
    move $a0, $t2          
    syscall                

    #Then, print the largest value
    li $v0, 4 
    la $a0, MsgLargest  #Beginning by prompting the user about what the program does
    syscall

    li $v0, 1              
    move $a0, $t3          
    syscall                

    # Exiting the program
    li $v0, 10           
    syscall


    .data
N:      .word 9
table:  .word 3, -1, 6, 5, 7, -3, -15, 18, 2


#N:      .word 13
#table:  .word -5, 0, -69, 36, 54, -12, 29, 7, 44, 33, -1256, 11, 2048




msg1:   .asciiz "This programs finds the smallest and largest values in a non-empty table of N word sized integers.\n"
MsgSmallest: .asciiz "\nThe smallest value in the table is: \n"
MsgLargest: .asciiz "\nThe largest value in the table is: \n"

