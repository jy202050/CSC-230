# IfElse.asm
# Let's learn how to write branching statement.

.data 
  prompt:   .asciiz "Enter a positive number: "
  negative: .asciiz "negative"
  positive: .asciiz "zero"
  zero:     .asciiz "zero"
 
.text
  .globl main
 main:  
   la $a0, prompt # Prompt the user for a value
   li $v0, 4
   syscall
 
   li $v0,5   # That gets an input
   syscall   
   move $t0, $v0
   
   

   # if ($t1 < 0)
   slt $t1, $t0, $zero   # Sets $t1 if $t0 is less than $zero
   beq $t1, $zero, elseIf  # If $t1 is zero, then the condition is false, take the branch
     la $a0, negative
     li $v0, 4
     syscall
     b endIf
     
elseIf:  # else if ($t1 > 0)
     sgt $t1, $t0, $zero   # Set $t1 to one if  $t0 is less then $zero
     beq $t1, $zero, else  # If $t1 is zero, then the condition is false, take the branch
     la $a0, positive
     li $v0, 4
     syscall
     
else:
     la $a0, zero
     li $v0, 4
     syscall

endIf:

    li $v0, 10
    syscall
  