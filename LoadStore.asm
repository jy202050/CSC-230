# Title: LoadStore Assignment
# Desc: Create a program that ask 3 numbers from user and perform a+b-c
# Author: JIAYUAN YU
# Date: 02/14/2023

# Ask 3 numbers from the user and return a method of first + second - third.
.data
  val1: .word 0
  val2: .word 0
  val3: .word 0
  
# Ask 3 numbers from user 
  prompt1: .asciiz "Please enter the first number: "
  prompt2: .asciiz "Please enter the second number: "
  prompt3: .asciiz "Please enter the third number: "
  
# Print the operator + - =
  prompt4: .asciiz " + "
  prompt5: .asciiz " - "
  prompt6: .asciiz " = "
  prompt7: .asciiz "Result: "
  

  
.text
 # Prompt for second number and store the value to val2
  la $a0, prompt1                     # Load the address of first prompt string
  li $v0, 4                           # Print String
  syscall
  
  li $v0, 5                           # Read an Integer
  syscall
  
  sw $v0, val1 # store the value to val1 
  
  
  
 # Prompt for second number and store the value to val2
  la $a0, prompt2                     # Load the address of second prompt string
  li $v0, 4
  syscall
  
  li $v0, 5
  syscall
  
  sw $v0, val2                        # store the value to val2

 
 # Prompt for third number and store the value to val3
  la $a0, prompt3                     # Load the address of third prompt string
  li $v0, 4
  syscall
  
  li $v0, 5
  syscall
  
  sw $v0, val3                        # store the value to val3

 # load the value to register $s0, $s1, $s2
  lw $s0, val1
  lw $s1, val2
  lw $s2, val3
  
 # Perform the method of val1 + val2 - val3
  add $s3, $s0, $s1                  # Add val1 and val2 and store the sum to register $s3
  sub $s3, $s3, $s2                  # subtract $s3 (stored value from last step) and $s2, override the value in $s3
  
 # Print Result:val1 + val2 - val3 = the number stored in $s3
 
  la $a0, prompt7                    # Print Result:
  li $v0, 4
  syscall
  
  move $a0, $s0                      # Move the stored value from $s0 to address $a0 
  li $v0, 1                          # Print the first user number
  syscall
  
  la $a0, prompt4                    # Print the operator + that set in prompt 4
  li $v0, 4
  syscall
  
  move $a0, $s1                      # Move the stored value from $s1 to address $a0
  li $v0, 1                          # Print the second user number
  syscall
  
  la $a0, prompt5                    # Print the operator - that set in prompt 5
  li $v0, 4
  syscall
  
  move $a0, $s2                      # Move the stored value from $s2 to address $a0
  li $v0, 1                          # Print the third user number
  syscall
  
  la $a0, prompt6                    # Print the operator = that set in prompt 6
  li $v0, 4
  syscall
  
  move $a0, $s3                      # Move the result from register $s3 to the address $a0
  li $v0, 1
  syscall
  
  
  li $v0, 10
  syscall
  
  
  
