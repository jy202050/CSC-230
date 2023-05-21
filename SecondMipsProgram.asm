# Title: Second Mips Program
# Desc: The second program written at home and formatted nicely
# Author: JIAYUAN YU	
# Date: 2/7/23

# int x = 5; // Global Variable
# int y = 2; // Global Variable
# int z = 3; // Global Variable
# int w = 4: // Global Variable
# int main() {
# x = (x - y) + (z + w);
# exit();
# }

.data # This tells the assembler that everything that follows is data

 x: .word 5 # int x = 5
 y: .word 2 # int y = 2
 z: .word 3 # int z = 3
 w: .word 4 # int w = 4
 
.text #This tells the assembler that everything that follows is code
  .globl main
 main: #This is the starting point


 lw $t0, x  # Move x into the register $t0
 lw $t1, y  # Move y into a register $t1
 lw $t2  z  # Move z into a register $t2
 lw $t3  w  # Move w into a register $t3
  
 
   #  Do Processing
   sub $t0, $t0, $t1  #  sub $t0 and $t1 and store the results back into $t0 (t0 = 5 - 2 = 3) 
   add $t2, $t2, $t3  #  Add $t2 and $t3 and store the results back into $t2 (t2 = 3 + 4 = 7)
   add $t0, $t0, $t2  #  Add $t0 and $t2 and store the result back into $t0  (t0 = 3 + 7 = 10)
   
   #  Output Results
   
   #  Get out of Dodge
   li $v0, 10      # Load up a code to tell the program we're done.
   syscall