#  Title: Seven Segment Countdown
#  Desc: count from 99 to 1 using a for loop
#  Author: JIAYUAN YU
#  Date: 04/12/2023

#  Make this count from 99 to 1 using a for loop
#  FunWithSegDisplay.asm
#  Seven segment display
#  Byte value at address 0xFFFF0010 : command right seven segment display 
#  Byte value at address 0xFFFF0011 : command left seven segment display 


#  Since the program is asking countdown from 99 to 1, then we need 10 numbers
#  0,1,2,3,4,5,6,7,8,9 in order to complete the countdown with two segment.
.eqv SEG1 0xFFFF0010
.eqv SEG2 0xFFFF0011
.eqv ZERO  0x3f       # 0111111 
.eqv ONE   0x06       # 0000110 
.eqv TWO   0x5b       # 1011011 
.eqv THREE 0x4f       # 1001111 
.eqv FOUR  0x66       # 1100110 
.eqv FIVE  0x6d       # 1101101 
.eqv SIX   0x7d       # 1111101 
.eqv SEVEN 0x07       # 0000111 
.eqv EIGHT 0x7f       # 1111111 
.eqv NINE  0x6f       # 1101111 


.macro SLEEP          # Macro for countdown break
  li $a0, 1000
  li $v0, 32
  syscall
.end_macro

.data
  nums: .byte NINE,EIGHT,SEVEN,SIX,FIVE,FOUR,THREE,TWO,ONE,ZERO
  
.text
 .globl main
main:
  addi $s0, $zero, SEG1   # $s0 now holds the address of segment 1
  addi $s1, $zero, SEG2   # $s1 now holds the address of segment 2
  la $s2, nums            # Load address of the array for right_seg
  la $s3, nums            # Load address of the array for left_seg
 
  addi $s4, $zero, 10     # Set max nums array elements 
  
left_seg:
  beq $t0, $s4,leftSegEnd # Exit the program if i = 10
  lb $t2, 0($s2)          # Load the current byte from nums array into $t2
  sb $t2, 0($s1)          # Store the current byte in to left segment
  
  la $s3, nums            # Reload the array to re-count from 9 to 0
  addi $t1, $zero, 0      # set j = 0
 
right_seg: 
  beq $t1, $s4, rightSegEnd   # end the loop if j = 10
       
  lb $t3, 0($s3)         # Load the current bytes from nums array into $t3
  sb $t3, 0($s0)         # Store the current byte in to right segment
  SLEEP                  # Wait a short time
     
  addi $t1, $t1, 1       # j++
  addi $s3, $s3, 1       # scan in next element from array $s3 (nums array)  
  b right_seg
     
rightSegEnd:
  addi $t0, $t0, 1        # i++ 
  addi $s2, $s2, 1        # scan in next element from array $s2 (nums array)
  b left_seg
 
  
leftSegEnd:
  li $v0, 10              # Exit the program
  syscall
 
    

 
