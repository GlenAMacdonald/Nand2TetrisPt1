// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

// Put your code here.

// Screen register starts at 16384, 
// Screen has dimensions: 512(columns) x 256(rows)
// Each row has 32 Registers (512/16), one for each column.
// Each column has 16 Registers (256/16) one for each row.
// There are a total of 8192 (512*256/16) Registers.
// note that these Registers are sequential and go from left to right.

(INIT)
    @8192
    D=A
    @nRegisters
    M=D

(MONITOR)
    @R0 // Register 0 is a temporary toggle to decided whether to change the screen colour
    D=M
    @MONITOR
    D;JEQ

    @SCREEN // Point at the Register allocated for the screen
    D=A; // Retrieve the address
    @address
    M=D; // save it to the working 16bit space
    @loopCount
    M=0

    @R1 // Register 1 is the colour switch
    D=M

    @MAKEBLACK // If Register 1 is Greater Than 0, make the screen black
    D;JGT

    @MAKEWHITE // If Register 1 is equal to zero, make the screen white
    D;JEQ

    @INIT // incase we get here, re-initialize the program
    0;JMP

(MAKEBLACK) // Loop through all of the screen registers turning them to all ones

    @nRegisters
    D=M
    @loopCount
    D=D-M
    @MONITOR
    D;JEQ
    @MONITOR
    D;JLT

    @address
    A=M
    M=-1
    
    @loopCount
    M=M+1

    @address
    M=M+1
    
    @MAKEBLACK
    0;JMP
  
(MAKEWHITE) // Loop through all the screen registers, turning them all to white

    @nRegisters
    D=M
    @loopCount
    D=D-M
    @MONITOR
    D;JEQ
    @MONITOR
    D;JLT
    
    @address
    A=M
    M=0
    
    @loopCount
    M=M+1

    @address
    M=M+1
    
    @MAKEWHITE
    0;JMP


(FINISH)

(END)
    @END
    0;JMP
