# Title: Print Routine Assignment
# Desc: Complete the following program in Assembly. Call that program PrintMethods.asm.
# Author: JIAYUAN YU
# Date: 04/16/2023

# You CANNOT USE any macro's for this assignment.


# Global Array
.data
myInts: .word 3, -8, -9, 12, 14, -23, 32, 33, 42    #int myInts[] = {3, -8, -9, 12, 14, -23, 32, 33, 42};
numberSpace: .asciiz " "
reversePrint: .asciiz "The numbers in reverse order: "
positivePrint: .asciiz "Positive number from myInts: "

#    printReverse(myInts);
.text
  .globl main
main:

  la $a0, reversePrint                 # Print the string (for reverse)
  li $v0, 4
  syscall
  
  la $t0, myInts			# Put the address of our array into $t0
  li $t1, 8                             # Initialize counter $t1 to 8
  addi $t0, $t0, 32                     # Initialize the array pointer to the address of the last element of the array(42)
  jal printReverse                      # Jump and link to printReverse subroutine
  
  li $a0, '\n'                          # Print a new line
  li $v0, 11
  syscall
  
  la $a0, positivePrint                 # Print the string (for positive)
  li $v0, 4
  syscall
  
  la $t0, myInts                        # Put the address of our array into $t0
  li $t1, 9                             # Initialize counter $t1 to 9
  jal printPositive
  
  # Exit
  li $v0, 10
  syscall
    
# end main


printReverse:
  lw $a0, ($t0)                        # Load the current array element into $a0
  li $v0, 1                            # Print the current integer from the array
  syscall 
  
  la $a0, numberSpace                  # Load the address of the space character into $a0
  li $v0, 4                            # Set the system call code for printing strings
  syscall                              # Print the space character
  
  addi $t0, $t0, -4                    # Decrement the array pointer to the previous element
  addi $t1, $t1, -1                    # Decrement the counter
  
  bgez $t1, printReverse               # If the counter is greater than or equal to zero, jump back to printReverse
  


  
printPositive:
  lw $a0, ($t0)                        # # Load the current array element into $a0
  blez $a0, skipPrint                  # If the current array element is greater than zero, jump back to printPositiveNums
  
  li $v0, 1                            # Print integer
  syscall    
  
  la $a0, numberSpace                  # Print space between number
  li $v0, 4
  syscall
  
  addi $t0, $t0, 4                     # Increment the array pointer to the next element
  addi $t1, $t1, -1                    # Decrement the counter
  
  blez $t1, endPositive                # If the counter is greater than zero, jump back to printPositive
  j printPositive

skipPrint:
  addi $t0, $t0, 4                     # Increment the array pointer to the next element
  addi $t1, $t1, -1                    # Decrement the counter
  
  bltz $t1, endPositive                # If the counter is greater than zero, jump back to printPosive
  j printPositive
  
endPositive:
  jr $ra                               # return


