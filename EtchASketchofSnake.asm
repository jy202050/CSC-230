# Title: Etch A Sketch  	
# Desc: Write a program that emulates an Etch-A-Sketch
# Author: JIAYUAN YU
# Date: 04/29/2023


# Initialize your Bitmap Display to 512 x 512 with Unit Height/Width of 8
#############################################################
##                                                         ##
##              Bitmap Display Setting                     ##
##         Unit Width in Pixels:       8                   ##       
##         Unit Height in Pixels:      8                   ##
##         Display Width in Pixels:    512                 ##
##         Display Height in Pixels:   512                 ##
##         Base address for display:   0x10040000(heap)    ##
##   Please use lowercase when type in the MMIO simulator  ##
##                                                         ##
#############################################################



  # Define Constant for function 
  .eqv THD 0xffff000c           # this is where we write data to...
  .eqv THR 0xffff0008           # This check is the device ready
  .eqv KC  0xffff0004           # MMMI Address that we use to read data
  .eqv KR  0xffff0000           # Is it ok to write?  Key Write Request
  .eqv BMD 0x10040000           # This needs to be changed to the heap.
 
  # Define Constant for Colors
  .eqv blue   0x000000FF        # Blue Color 
  .eqv green  0x0000FF00        # Green color
  .eqv red    0x00FF0000        # Red color
  .eqv white  0xFFFFFFFF        # White color 
  .eqv orange 0x00FFA500        # Orange color 
   
   
  # Define Constant for Control Keys 
  .eqv h 0x00000068            # Move left (Code for h)
  .eqv k 0x0000006B            # Move down (Code for k)
  .eqv l 0x0000006C            # Move right (Code for l)
  .eqv i 0x00000069            # Move up (Code for i)
  .eqv y 0x00000079            # Move up/left (Code for y)
  .eqv o 0x0000006F            # Move up/right (Code for o)
  .eqv n 0x0000006E            # Move down/left (Code for n)
  .eqv m 0x0000006D            # Move down/right (Code for m)
  .eqv q 0x00000071            # Exits the program (Code for q)
  .eqv r 0x00000072            # Set to Red Color (Code for r)
  .eqv g 0x00000067            # Set to Green Color (Code for g)
  .eqv v 0x00000076            # Set to Blue Color (Code for v)


  
.text
  .globl main
main:

# Allocate memory in the Heap to hold your 512 x 512 display.
   li $v0, 9                  # Load 9 into register $v0 to allocate memory
   li $a0, 16384              # Load 16384 into $a0 to request memory size
   syscall                    # Pixels(Display width / Unit width) * Pixels(Display Height / Unit Height) * 4 bytes
                                                      
# Draw a white dot in the exact middle.
   li $a0, 16                 # Load 16 into register $a0 for x-coordinate
   li $a1, 32                 # Load 32 into register $a1 for y-coordinate
   jal displayBorder          # Call displayBorder function to draw a white dot in the screen
   move $t4, $v0              # Move the result of displayBorder function to $t4
  
   li $a0, white              # Load constant white color into $a0
   addi $a1, $t4, BMD         # Add BMD to the result of displayBorder function and load it to $a1
   addi $s0, $t4, BMD	      # Add BMD to the result of displayBorder function and load it to $s0
   li $a2, 1                  # Load 1 into register $a2 for line length
   jal horizontalLine         # Call horizontalLine function to draw a horizontal line of length 1
  
  
# Draw a nice border that would be the edge of the Etch-A-Sketch - Make it your own.
# Horizontal border(Top part)
   li $a0, 0                  # Load 0 into $a0 (x-coordinate)
   li $a1, 0                  # Load 0 into $a1 (y-coordinate)
   jal displayBorder          # Call displayBorder function
   move $t4, $v0              # Move the result of diplayBorder function into $t4
   li $a0, orange             # Load the address of orange color into $a0
   addi $a1, $t4, BMD         # Add BMD to the result of displayBorder function and load it into $a1
   li $a2, 64                 # Load 64 into $a2 for line length
   jal horizontalLine         # Call horizonatalLine function to draw a horizontal line of lenght 64
   
 # Horizontal border(Bottom part) 
   li $a0, 63                # Load 63 into $a0 for x
   li $a1, 0                 # Load 0 into $a1 for y
   jal displayBorder         # Call displayBorder function
   move $t4, $v0             # Move the result of diplayBorder function into $t4
   li $a0, red               # Load the address of red color into $a0
   addi $a1, $t4, BMD        # Add BMD to the result of displayBorder function and load it into $a1
   li $a2, 64                # Load 64 into $a2 for line length 
   jal horizontalLine 	     # Call horizonatalLine function to draw a horizontal line of lenght 64	 
  
# Vertical border(Left)
   li $a0, 0                 # Load 0 into $a0 for x
   li $a1, 0                 # Load 0 into $a1 for y
   jal displayBorder         # Call displayBorder function
   move $t4, $v0             # Move the result of diplayBorder function into $t4
   li $a0, orange            # Load the address of orange color into $a0
   addi $a1, $t4, BMD        # Add BMD to the result of displayBorder function and load it into $a1
   li $a2, 64                # Load 64 into $a2 for line length 
   jal verticalLine          # Call verticalLine function to draw a horizontal line of lenght 64	
  
 # Vertical border(Right)
   li $a0, 0                 # Load 0 into $a0 for x
   li $a1, 63                # Load 63 into $a1 for y
   jal displayBorder         # Call displayBorder function
   move $t4, $v0             # Move the result of diplayBorder function into $t4
   li $a0, orange            # Load the address of orange color into $a0
   addi $a1, $t4, BMD        # Add BMD to the result of displayBorder function and load it into $a1
   li $a2, 64                # Load 64 into $a2 for line length 
   jal verticalLine          # Call verticalLine function to draw a horizontal line of lenght 64	
 
  
   li $t0, KC                # Load the address of the KC into $t0
   li $t1, KR     	     # Load address KR into $t1,Need this to set the interrupt bit.  Which is bit 2.
   li $t2, THD   	     # Load the address of the THD to Write data
   li $t3, THR   	     # Check if the device is ready.
   li $s3, blue  	     # Set initial color to blue	

    
loop:
   lw $t4, 0($t1)            # Load the value of keyboard reader(KR) into $t4
   beq $t4, $zero, loop      # Branch back to the loop if $t4 = 0, means no key has been pressed
   lw $s1, 0($t0)            # Load the value of keyboard controller (KC) into $s1
     
   .ktext 0x80000180         # Have to have that address so it can jump here(Handle Keyboard Input)     
    b handleKeyInput         # That is down below.  That is where your methods will go
                             # to handle each keystroke	        
   
			 	 		 	 		 	 
.text
# Check if the control keys are pressed and update the cursor accordingly.
handleKeyInput:

  beq $s1, h, handleKeyJ     # If the result is equal to h, branch to handleKeyJ(Move left)
  beq $s1, k, handleKeyK     # If the result is equal to k, branch to handleKeyK(Move down)
  beq $s1, l, handleKeyL     # If the result is equal to l, branch to handleKeyL(Move right)
  beq $s1, i, handleKeyI     # If the result is equal to i, branch to handleKeyI(Move up)
  beq $s1, y, handleKeyY     # If the result is equal to y, branch to handleKeyY(Move up/left)
  beq $s1, o, handleKeyO     # If the result is equal to o, branch to handleKeyO(Move up/right)
  beq $s1, n, handleKeyN     # If the result is equal to n, branch to handleKeyN(Move down/left)
  beq $s1, m, handleKeyM     # If the result is equal to m, branch to handleKeyM(Move down/right)
  beq $s1, q, handleKeyQ     # If the result is equal to q, branch to handleKeyQ(Exits the program)
  beq $s1, r, handleKeyR     # If the result is equal to r, branch to handleKeyR(Set color to Red)
  beq $s1, g, handleKeyG     # If the result is equal to g, branch to handleKeyG(Set color to Green)
  beq $s1, v, handleKeyB     # If the result is equal to v, branch to handleKeyB(Set color to blue)
  b loop                     # Branch back to loop
  

# Vertical Border Display
verticalLine:
  	# Prolog
  	addi $sp, $sp, -16              # Allocate space for the function
  	sw $ra, 0($sp)                  # Save the return address
  	sw $s0, 4($sp)                  # Save the $s0 on the stack
  	sw $s1, 8($sp)                  # Save the $s1 on the stack
  	sw $s2, 12($sp)                 # Save the $s2 on the stack
  	
  	# Logic
  	move $s0, $a0  			# Store the color in $s0
  	move $s1, $a1  			# Store the base address in $s1
  	move $s2, $a2  			# Store the length in $s2
  	
  	# initialize
  	li $t0, 0      			# Initialize the loop counter to 0
  	
verticalLoop:
	slt $t1, $t0, $s2 		# Check if $t0 is less than $s2
	beq $t1, $0, verticalEnd        # If not, exit the loop
	sw $s0, 0($s1)  		# Write the color to the screen
	addi $t0, $t0, 1 		# i++
	addi $s1, $s1, 256              # Move to the next line
	addi $s0, $s0, 0x00FF0000 	# Mix (Red and Orange) for vertical borders
	b verticalLoop                  # Repeat the loop

verticalEnd: 
    	lw $ra, 0($sp)                  # Restore the return address
  	lw $s0, 4($sp)                  # Restore the $s0
  	lw $s1, 8($sp)                  # Restore the $s1
  	lw $s2, 12($sp)                 # Restore the $s2
  	addi $sp, $sp, 16               # Deallocate the space for the function
  	
  	jr $ra 	                        # Return to the caller
  	
# Horizontal Border Display
horizontalLine:
  	# Prolog
  	addi $sp, $sp, -16              # Allocate space for the function
  	sw $ra, 0($sp)                  # Save the return address
  	sw $s0, 4($sp)                  # Save the $s0 on the stack
  	sw $s1, 8($sp)                  # Save the $s1 on the stack
  	sw $s2, 12($sp)                 # Save the $s2 on the stack
  	
  	# Logic 
  	move $s0, $a0  			# Store the color in $s0
  	move $s1, $a1  			# Store the base address in $s1
  	move $s2, $a2  			# Store the length in $s2
  	
  	# initialize
  	li $t0, 0      			# Initialize the loop counter to 0
  	
horizontalLoop:
	slt $t1, $t0, $s2 		# Check if $t0 is less than $s2
	beq $t1, $0, horizontalEnd      # If not, exit the loop
	sw $s0, 0($s1)  		# Write the color to the screen
	addi $t0, $t0, 1 		# i++
	addi $s1, $s1, 4                # Increment the memory address of the screen
	addi $s0, $s0, 0x00FF0000       # Red and orange mix
	b horizontalLoop                # Loop back to horizontalLoop

horizontalEnd: 	
  	# Epilog
  	lw $ra, 0($sp)                  # Restore the return address
  	lw $s0, 4($sp)                  # Restore the $s0
  	lw $s1, 8($sp)                  # Restore the $s1
  	lw $s2, 12($sp)                 # Restore the $s2
  	addi $sp, $sp, 16               # Deallocate the space for the function
  	
  	jr $ra                          # Return to the caller
  	
displayBorder:
        addi $sp, $sp, -16              # Allocate space on the stack for displayBorder function
        sw $ra, 0($sp)                  # Save the return address on the stack
        sw $s1, 4($sp)                  # Save $s1 on the stack
        sw $s2, 8($sp)                  # Save $s2 on the stack
        sw $s0, 12($sp)                 # Save $s0 on the stack
   	move $s1, $a0  		        # Save the x coordinate in $s1
   	move $s2, $a1  		        # Save the y coordinate in $s2	
   	mul $s1, $s1, 256	        # Convert the x coordinate to a memory address
   	mul $s2, $s2, 4		        # Convert the y coordinate to a word offset
   	add $s2, $s1, $s2               # Compute the memory address of the screen element
  	move $v0, $s2 		        # Return the memory address of the screen element

   	lw $ra, 0($sp)                  # Restore the return address
  	lw $s1, 4($sp)                  # Restore $s1
  	lw $s2, 8($sp)                  # Restore $s2
   	lw $s0, 12($sp)                 # Restore $s0
   	addi $sp, $sp, 16 	        # Deallocate 
  	
   	jr $ra                          # Return to the caller
  
#-----------------------------handle key J-------------------------------
# J says to draw a pixel at the current location and move one to the left
  handleKeyJ:  # Move left(Use Key h)
  
     # Update Screen
        lw $t5, 0($s0)		       # Load the value of the current pixel from memory
  	or $t5, $t5, $s3	       # Set the color of the pixel to the current color
        sw $t5, 0($s0)  	       # Store the updated value back into memory
  	andi $t5, $s0, 0xff	       # Check if the current column is at the left edge of the screen
  	beq $t5, 4, loop	       # If it is, jump to the loop 
  	addiu $s0, $s0, -4             # Otherwise, move one pixel to the left, -4 bytes
  			
  	b loop
      
#-----------------------------handle key K-------------------------------  
#  K says to draw a pixel at the current location and move down one   
  handleKeyK:  # Move down
      
      # Update Screen  
       lw $t5, 0($s0)		       # Load the value of the current pixel from memory
       or $t5, $t5, $s3		       # Set the color of the pixel to the current color
       sw $t5, 0($s0)  		       # Store the updated value back into memory
       li $t5, BMD		       # Load the base address of the bottom row of pixels
       addi $t5, $t5, 15872	       # Add the offset of the current column to get the address of the pixel below
       bgtu $s0, $t5, loop	       # If the current address is below the screen, jump to the loop 
       addiu $s0, $s0, 256             # Otherwise, move one row down, +256 bytes
       		
       b loop
      
#-----------------------------handle key L-------------------------------  
#  L says to draw a pixel at the current location and move right     
  handleKeyL:  # Move right
    
      # Update Screen 
       lw $t5, 0($s0)		      # Load the value of the current pixel from memory
       or $t5, $t5, $s3		      # Set the color of the pixel to the current color
       sw $t5, 0($s0)  		      # Store the updated value back into memory
       andi $t5, $s0, 0xff	      # Check if the current column is at the right edge of the screen
       beq $t5, 248, loop	      # If it is, jump to the loop
       addiu $s0,$s0, 4	              # Otherwise, move one pixel to the right, +4 bytes
       	
       b loop
          
#-----------------------------handle key I-------------------------------  
#  I says to draw a pixel at the current location and move up   
  handleKeyI:  # Move up
  
      # Update Screen 
        lw $t5, 0($s0)		      # Load the value of the current pixel from memory
        or $t5, $t5, $s3	      # Set the color of the pixel to the current color
  	sw $t5, 0($s0)  	      # Store the updated value back into memory
  	li $t5, BMD		      # Load the base address of the bottom row of pixels
  	addi $t5, $t5, 512	      # Add 512 to $t5 to move up one row
  	bltu $s0, $t5, loop	      # If the current location is above the top-most pixel, branch to loop  
  	addiu $s0, $s0, -256	      # Otherwise, move one pixel up, -256 bytes
  	
  	b loop
       
#-----------------------------handle key Y----------------------------- 
#  Y moves to draw a pixel at the current location and up/left 
  handleKeyY:  # Move up/left
  
      # Update Screen   
        lw $t5, 0($s0)		      # Load the value of the current pixel from memory
  	or $t5, $t5, $s3	      # Set the color of the pixel to the current color
  	sw $t5, 0($s0)  	      # Store the updated value back into memory
  	li $t5, BMD		      # Load the base address of the bottom row of pixels
  	addi $t5, $t5, 512	      # Add 512 to $t5 to move up one row
  	bltu $s0, $t5, loop	      # If the current location is above the top-most pixel, branch to loop  
  	andi $t5, $s0, 0xff	      # Check if the current column is at the right edge of the screen
  	beq $t5, 4, loop	      # If it is, branch to loop
  	addiu $s0, $s0, -260	      # Otherwise, move one pixel up left, -260 bytes 
  		 
  	b loop      
       
#-----------------------------handle key O----------------------------  
#  O moves to draw a pixel at the current location and up/right      
  handleKeyO:  # Move up/right
  
      # Update Screen
        lw $t5, 0($s0)		     # Load the value of the current pixel from memory
  	or $t5, $t5, $s3	     # Set the color of the pixel to the current color
  	sw $t5, 0($s0)  	     # Store the updated value back into memory
  	li $t5, BMD		     # Load the base address of the bottom row of pixels
  	addi $t5, $t5, 512	     # Add 512 to $t5 to move up one row
  	bltu $s0, $t5, loop	     # If the current location is above the top-most pixel, branch to loop  
  	andi $t5, $s0, 0xff	     # Check if the current column is at the right edge of the screen
  	beq $t5, 248, loop	     # If it is, branch to loop
  	addiu $s0,$s0, -252          # Otherwise, move one pixel up right, -252 bytes 
  			
  	b loop       
      
#-----------------------------handle key N-----------------------------  
#  N moves to draw a pixel at the current location and down/left     
  handleKeyN:  # Move down/left

      # Update Screen
        lw $t5, 0($s0)		     # Load the value of the current pixel from memory
  	or $t5, $t5, $s3	     # Set the color of the pixel to the current color
  	sw $t5, 0($s0)  	     # Store the updated value back into memory
  	li $t5, BMD		     # Load the base address of the bottom row of pixels
        addi $t5, $t5, 15872	     # Add 15872 to $t5 to move down one row 
        bgtu $s0, $t5, loop          # If the current location is below the bottom-most pixel, branch to loop   
        andi $t5, $s0, 0xff	     # Check if the current column is at the left edge of the screen 
        beq $t5, 4, loop	     # If it is, branch to loop 
        addiu $s0,$s0, 252           # Otherwise, move one pixel down left, +252 bytes  
        
        b loop   

#-----------------------------handle key M----------------------------- 
#  M moves to draw a pixel at the current location and down/right            
  handleKeyM:  # Move down/ right
  
      # Update Screen
        lw $t5, 0($s0)		     # Load the value of the current pixel from memory
  	or $t5, $t5, $s3	     # Set the color of the pixel to the current color
  	sw $t5, 0($s0)  	     # Store the updated value back into memory
  	li $t5, BMD		     # Load the base address of the bottom row of pixels
        andi $t5, $s0, 0xff	     # Check if the current column is at the right edge of the screen 
  	beq $t5, 248, loop	     # If it is, branch to loop 
  	addi $t5, $t5, 15872	     # Add 15872 to $t5 to move down one row
  	bgtu $s0, $t5, loop	     # If the current location is below the bottom-most pixel, branch to loop
  	addiu $s0,$s0, 260	     # Otherwise, move one pixel down right, +260 bytes 
  	
  	b loop                 

#-----------------------------handle key Q-----------------------------  
#  Q exits the program           
  handleKeyQ:  # Exits the program
   
       jal exit                      # Jump to exit, program end
       
      
#-----------------------------handle key R----------------------------- 
#  R changes current color to Red
  handleKeyR:   # Red
  
      # update red
        li $s3, red                 # Load the value of the red color to register $s3 
        li $t0, KC 	            # Load the value of the key code to register $t0
        li $t1, KR	            # Load the address of the key release flag to register $t1
        li $t2, THD		    # Load the threshold value for debouncing to register $t2
        li $t3, THR                 # Load the value of the key hold count to register $t3
               
  redColor: 
        lw $t4, 0($t1)		    # Load the value of the key release flag to register $t4
  	beq $t4, $0, redColor 	    # If the key is still pressed, branch to redColor
  	lw $s1, 0($t0)		    # Load the value of the key code to register $s1
  	b handleKeyInput            # Branch to handleKeyInput to handle the key press
     
#-----------------------------handle key G-----------------------------
#  G changes current color to Green 
  handleKeyG:   # Green
  
      # Update green
        li $s3, green               # Load the value of the green color to register $s3 
        li $t0, KC 	            # Load the value of the key code to register $t0
        li $t1, KR	            # Load the address of the key release flag to register $t1
        li $t2, THD		    # Load the threshold value for debouncing to register $t2
        li $t3, THR                 # Load the value of the key hold count to register $t3

  greenColor: 
        lw $t4, 0($t1)		    # Load the value of the key release flag to register $t4
  	beq $t4, $0, greenColor     # If the key is still pressed, branch to greenColor
  	lw $s1, 0($t0)		    # Load the value of the key code to register $s1
  	b handleKeyInput            # Branch to handleKeyInput to handle the key press
        
#-----------------------------handle key B-----------------------------
#  B changes current color to Blue
  handleKeyB:   # Blue(Use Key v)

      # Update blue
        li $s3, blue                # Load the value of the blue color to register $s3 
        li $t0, KC 	            # Load the value of the key code to register $t0
        li $t1, KR	            # Load the address of the key release flag to register $t1
        li $t2, THD		    # Load the threshold value for debouncing to register $t2
        li $t3, THR                 # Load the value of the key hold count to register $t3

  blueColor: 
        lw $t4, 0($t1)		    # Load the value of the key release flag to register $t4
  	beq $t4, $0, blueColor      # If the key is still pressed, branch to blueColor
  	lw $s1, 0($t0)		    # Load the value of the key code to register $s1
  	addi $s3, $s3, 0x000000FF   # Load back the blue color
 	b handleKeyInput            # Branch to handleKeyInput to handle the key press
  	eret                        # Return from exception (end of function)
  	                                                                                             
  	                                                                                             	                                                                                             	                                                                                             
exit:
   li $v0,10                        # Program End
   syscall
