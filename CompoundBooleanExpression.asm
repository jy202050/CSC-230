# CompoundBolleanExpression.asm

# printf("Enter a number between 0 and 10");
# scanf("%d", &x)
# if ( x >0 && x < 10)
# printf("Good Panda")
# else
# printf("Hung over much??")
# endif

.include "MyMacros.asm"   # Use the preprocessor directive to include that file into this code

.data 
  prompt:   .asciiz "Enter a positive number  between 1 and 10: "
  gp: .asciiz "Good Panda"
  bp: .asciiz "Bad Panda"
 
.text
  .globl main
 main:  
   printString prompt   # Use the printString macro to print prompt
   readInt $t0          # Use the readInt Macro to read an int and store in the $t0
   printInt $t0
   
 # if (x > 0 && x < 10)
  sgt $t1, $t0, $zero   # Set $t1 if x > 0 (Remember x is in $t0)
  slti $t2, $t0, 10     # Set $t2 if x < 10
  and $t1, $t1, $t2     # and??? What does and do????
  beq $t1, $zero, else  # If false, then skip to the else section
  printString gp        # Print good panda
  b endIf
 
 else:
   printString bp       # Print bad Panda

 endIf:
 
 
   done
   