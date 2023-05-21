# Title: Nested Procedures Lab
# Desc: Compile the given C program by using assembly language
# Author: JIAYUAN YU
# Date: 03/18/2023



# int Dif(int a, int b) {
#   return b - a;
# }

# int Sum(int m, int n) {
#   int p = Dif(n+1, m-1);
#   int q = Dif(m+1, n-1);
#   return p + q;
# }

# int main() {
#   int x, y;
#    z = x + y + Sum(x, y);
#   return 0;
# }



# Procedure Main 
.text
 .globl main
main:

      li $s0, 5      			# Initialize x = 5 into $s0
      li $s1, 10     			# Initialize y = 10 into $s1
       
      add $a0, $zero, $s0    		# Passing the x value (5) from $s0 to $a0
      add $a1, $zero, $s1   		# Passing the y value (10) from $s1 to $a1
      
      
      jal Sum               		# Calling the Sum procedure
      
      add $s2, $s0, $s1			# Perform z = x + y
      add $s2, $s2, $v0			# Perform z = x + y + Sum(x, y)
      
      move $a0, $s2			# Move the result z to $a0
      li $v0, 1				# Print the integer (z)
      syscall
      
      li $v0, 10			# Terminate the program
      syscall

# Procedure Sum
Sum:
      
      addi $sp, $sp, -12       		# Allocate 12 bytes of space in stack
      
      sw $ra, 0($sp)			# Store main return address in stack
      sw $s0, 4($sp)			# Store $s0 in stack
      sw $s1, 8($sp)   			# Store $s1 in stack
      		
      
      # Perform p = Dif(n+1, m-1)
      addi $a0, $s1, 1			# Perform (y + 1)  <== n + 1
      subi $a1, $s0, 1			# Perform (x - 1)  <== m - 1
      jal Dif				# Calling the Dif procedure; $a1 - $a0 ==> (5-1) - (10+1) = -7($v0) 
      add $v1, $zero, $v0               # Save the p value (-7£© to register $v1
      
      # Perform q = Dif(m+1, n-1)
      addi $a0, $s0, 1			# Perform (x + 1)  <== m + 1
      subi $a1, $s1, 1			# Perform (y - 1)  <== n - 1
      jal Dif				# Calling the Dif procudurel $a1 - $a0 ==> (10-1) - (5+1) = 3($v0)
      
      lw $ra, 0($sp)			# Load value back into $ra so we can return to main
      lw $s0, 4($sp)			# Load value back into $s0
      lw $s1, 8($sp)			# Load value back into $s1
      
      addi $sp, $sp, 12                 # Restore the stack from the previous -12
      
      
      add $v0, $v1, $v0           	# Sum p + q
      
      jr $ra 				# Return to main
     	

# Procedure Dif 
Dif:
      sub $v0, $a1, $a0
      jr $ra


