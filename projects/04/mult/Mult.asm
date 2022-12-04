// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)
//
// This program only needs to handle arguments that satisfy
// R0 >= 0, R1 >= 0, and R0*R1 < 32768.


@R0 // Read and record the first value
D=M
@firstValue
M=D

@R1 // Read and record the second value
D=M
@secondValue
M=D

@R2 // Set the output to zero
M=0
 
@loopCount // Initialize the loop counter $Register18
M=0

@accumulator // Initialize the value accumulator $Register18
M=0

(LOOP) // to multiply, add a (first number), b (second number) times
    @secondValue // Retrieve the second number
    D=M
    @loopCount // Compare the current loop count to the second number
    D=D-M
    @STOP // If they are equal stop accumulating values.
    D;JEQ 

    @firstValue // else, retrieve the first number
    D=M
    @accumulator // add it to the accumulator another time
    M=M+D;
        
    @loopCount // Add 1 to the loop count
    M=M+1
    @LOOP // jump to the start of the loop
    0;JMP

(STOP) // at the end the value needs to be returned
    @accumulator
    D=M
    @R2
    M=D

(END)
    @END
    0; JMP
    


