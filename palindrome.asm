## palindrome.asm -- reads a line of text and tests whether it is a palindrome.
## Register usage:
##	$t1	- A.
##	$t2	- B.
##	$t3	- the character *A.
##	$t4	- the character *B.
##	$v0	- syscall parameter / return values. 
##	$a0	- syscall parameters.
##	$a1	- syscall parameters.

		.globl  test_loop
        .globl  length_loop
        .globl  string_space
	    .text
main:				        		# SPIM starts by jumping to main.
					  				# read the string S:
	la      $a0, string_space
	li      $a1, 1024
	li      $v0, 8	            	# load "read_string" code into $v0.
	syscall

	la      $t1, string_space		# A <- S.

	la      $t2, string_space    	# we need to move B to the end
length_loop:			        	#	of the string:
	lb		$t3, ($t2)	           		# load the byte *B into $t3.
	beqz	$t3, end_length_loop       # if $t3 == 0, branch out of loop.
	addu	$t2, $t2, 1	        	# otherwise, increment B,
	b		length_loop		  			#  and repeat the loop.

end_length_loop:
	subu	$t2, $t2, 2	       		# subtract 2 to move B back past
				       				#  the '\0' and '\n'.


test_loop:
    bgeu    $t1, $t2, is_palin 		# if A >= B, it is a palindrome.

    #We invoke the checker subroutines for each character
    jal     checkerA            
    jal     checkerB            


    lb      $t3, ($t1)          	# load the byte *A into $t3,
    lb      $t4, ($t2)          	# load the byte *B into $t4.


    bne     $t3, $t4, not_palin 	# if $t3 != $t4, not a palindrome.
									# Otherwise,
    addu    $t1, $t1, 1         	#  increment A,
    subu    $t2, $t2, 1         	#  decrement B,
    b       test_loop           	#  and repeat the loop.

is_palin:
									# print the is_palin_msg, and exit.
    la         $a0, is_palin_msg
    li         $v0, 4
    syscall
    b          exit

not_palin:

    la         $a0, not_palin_msg	# print the is_palin_msg, and exit.
    li         $v0, 4
    syscall

exit:			                  	# exit the program:
	li		$v0, 10	          		# load "exit" into $v0.
	syscall			          		# make the system call



##-----------------------------------------------------------------------------------------------
checkerA:
    
    lb      $t3, ($t1)          
    li      $t8, '0'

    #Anything below '0' is not a valid, so we ditch it and increment
    blt     $t3, $t8, incrementerA   #<48

    #Anything from 48 to 57 is valid, so no need to do anything.

    #We "brute force" the branching when unequal, which is simpler than manipulating intervals and for more clarity
    #Since there are not so many cases
    beq     $t3, 58, incrementerA   #58
    beq     $t3, 59, incrementerA   #59
    beq     $t3, 60, incrementerA   #60
    beq     $t3, 61, incrementerA   #61
    beq     $t3, 62, incrementerA   #62
    beq     $t3, 63, incrementerA   #63
    beq     $t3, 64, incrementerA   #64

    li      $t8, 91

    #At this point, we are dealing with upper case values (65-90). We update them to be lowercase      
    blt     $t3, $t8, toLowerCaseA   #<91

    beq     $t3, 91, incrementerA   #91
    beq     $t3, 92, incrementerA   #92
    beq     $t3, 93, incrementerA   #93
    beq     $t3, 94, incrementerA   #94
    beq     $t3, 95, incrementerA   #95
    beq     $t3, 96, incrementerA   #96

    slt     $t8, $t3, 123
    beq     $t8, $zero,  incrementerA

    jr      $ra                 

toLowerCaseA:
    addi    $t3, $t3, 32
    sb      $t3, 0($t1)            
    jr      $ra                 

incrementerA:
    addu    $t1, $t1, 1         
    b       test_loop               

checkerB:
    lb      $t4, ($t2)          
    li      $t8, '0'
    blt     $t4, $t8, decrementerB   #<48

    #Anything from 48 to 57 is valid, so no need to do anything.

    #We "brute force" the branching when unequal, which is simpler than manipulating intervals and for more clarity
    #Since there are not so many cases
    beq     $t4, 58, decrementerB   #58
    beq     $t4, 59, decrementerB   #59
    beq     $t4, 60, decrementerB   #60
    beq     $t4, 61, decrementerB   #61
    beq     $t4, 62, decrementerB   #62
    beq     $t4, 63, decrementerB   #63
    beq     $t4, 64, decrementerB   #64

    li      $t8, 91      

    #At this point, we are dealing with upper case values (65-90). We update them to be lowercase    
    blt     $t4, $t8, toLowerCaseB   #<91

    beq     $t4, 91, decrementerB  #91
    beq     $t4, 92, decrementerB  #92
    beq     $t4, 93, decrementerB  #93
    beq     $t4, 94, decrementerB  #94
    beq     $t4, 95, decrementerB  #95
    beq     $t4, 96, decrementerB  #96

    slt     $t8, $t4, 123
    beq     $t8, $zero,  decrementerB

    jr      $ra 


toLowerCaseB:
    addi    $t4, $t4, 32  
    sb      $t4, 0($t2)     
    jr      $ra                 

decrementerB:
    subu    $t2, $t2, 1         
    b       test_loop               
##-----------------------------------------------------------------------------------------------


## Here is where the data for this program is stored:
	.data
string_space:	.space	1024  	# set aside 1024 bytes for the string.
is_palin_msg:	.asciiz "The string is a palindrome.\n"
not_palin_msg:	.asciiz "The string is not a palindrome.\n"
## end of palindrome.asm



