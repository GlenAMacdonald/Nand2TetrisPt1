// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/02/Neg16.tst

load Neg16.hdl,
output-file Neg16.out,
compare-to Neg16.cmp,
output-list a%B1.16.1 out%B1.16.1;

set a %B0000000000000000,
eval,
output;

set a %B1111111111111111,
eval,
output;

set a %B0101010101010101,
eval,
output;

set a %B1010101010101010,
eval,
output;

set a %B0000011111110101,
eval,
output;
