BeforeAll{
    Import-Module .\Convert-Line.ps1 -Force;
}

Describe "Checks Conversion of Addresses to Binary Values" {
    Context "Send function a few register values" {
        It "Converts @1 -> @16" {
            Convert-Value('@1')     | Should -Be '0000000000000001'
            Convert-Value('@2')     | Should -Be '0000000000000010'
            Convert-Value('@3')     | Should -Be '0000000000000011'
            Convert-Value('@4')     | Should -Be '0000000000000100'
            Convert-Value('@5')     | Should -Be '0000000000000101'
            Convert-Value('@6')     | Should -Be '0000000000000110'
            Convert-Value('@7')     | Should -Be '0000000000000111'
            Convert-Value('@8')     | Should -Be '0000000000001000'
            Convert-Value('@9')     | Should -Be '0000000000001001'
            Convert-Value('@10')    | Should -Be '0000000000001010'
            Convert-Value('@11')    | Should -Be '0000000000001011'
            Convert-Value('@12')    | Should -Be '0000000000001100'
            Convert-Value('@13')    | Should -Be '0000000000001101'
            Convert-Value('@14')    | Should -Be '0000000000001110'
            Convert-Value('@15')    | Should -Be '0000000000001111'
            Convert-Value('@16')    | Should -Be '0000000000010000'
        }
        It "Converts @R1 -> @R16" {
            Convert-Value('@R1')    | Should -Be '0000000000000001'
            Convert-Value('@R2')    | Should -Be '0000000000000010'
            Convert-Value('@R3')    | Should -Be '0000000000000011'
            Convert-Value('@R4')    | Should -Be '0000000000000100'
            Convert-Value('@R5')    | Should -Be '0000000000000101'
            Convert-Value('@R6')    | Should -Be '0000000000000110'
            Convert-Value('@R7')    | Should -Be '0000000000000111'
            Convert-Value('@R8')    | Should -Be '0000000000001000'
            Convert-Value('@R9')    | Should -Be '0000000000001001'
            Convert-Value('@R10')   | Should -Be '0000000000001010'
            Convert-Value('@R11')   | Should -Be '0000000000001011'
            Convert-Value('@R12')   | Should -Be '0000000000001100'
            Convert-Value('@R13')   | Should -Be '0000000000001101'
            Convert-Value('@R14')   | Should -Be '0000000000001110'
            Convert-Value('@R15')   | Should -Be '0000000000001111'
            Convert-Value('@R16')   | Should -Be '0000000000010000'
        }
        It "Check some larger values" {
            Convert-Value('@356')   | Should -Be '0000000101100100'
            Convert-Value('@2156')  | Should -Be '0000100001101100'
            Convert-Value('@9491')  | Should -Be '0010010100010011'
        }
    }
}

Describe "Check the Jump conversion" {
    Context "Check all of them" {
        It "Checks one by one" {
            Convert-Jump('null') | Should -Be '000';
            Convert-Jump('JGT')  | Should -Be '001';
            Convert-Jump('JEQ')  | Should -Be '010';
            Convert-Jump('JGE')  | Should -Be '011';
            Convert-Jump('JLT')  | Should -Be '100';
            Convert-Jump('JNE')  | Should -Be '101';
            Convert-Jump('JLE')  | Should -Be '110';
            Convert-Jump('JMP')  | Should -Be '111';
            Convert-Jump('AAA')  | Should -Be $null;
            Convert-Jump('jump') | Should -Be $null;
        }
    }
}

Describe "Check the Destination conversion" {
    Context "Check all of them" {
        It "Checks One by One" {
            Convert-Destination('null') | Should -Be '000';
            Convert-Destination('M')    | Should -Be '001';
            Convert-Destination('D')    | Should -Be '010';
            Convert-Destination('MD')   | Should -Be '011';
            Convert-Destination('A')    | Should -Be '100';
            Convert-Destination('AM')   | Should -Be '101';
            Convert-Destination('AD')   | Should -Be '110';
            Convert-Destination('AMD')  | Should -Be '111';
            Convert-Destination('anythingelsereally')  | Should -Be $null;
        }
    }
}

Describe "Check all the Computation Commands" {
    Context "All Commands" {
        It "One By One" {
            Convert-Computation('0')    | Should -Be '0101010';
            Convert-Computation('1')    | Should -Be '0111111';
            Convert-Computation('-1')   | Should -Be '0111010';
            Convert-Computation('D')    | Should -Be '0001100';
            Convert-Computation('A')    | Should -Be '0110000';
            Convert-Computation('M')    | Should -Be '1110000';
            Convert-Computation('!D')   | Should -Be '0001101';
            Convert-Computation('!A')   | Should -Be '0110001';
            Convert-Computation('!M')   | Should -Be '1110001';
            Convert-Computation('-D')   | Should -Be '0001111';
            Convert-Computation('-A')   | Should -Be '0110011';
            Convert-Computation('-M')   | Should -Be '1110011';
            Convert-Computation('D+1')  | Should -Be '0011111';
            Convert-Computation('A+1')  | Should -Be '0110111';
            Convert-Computation('M+1')  | Should -Be '1110111';
            Convert-Computation('D-1')  | Should -Be '0001110';
            Convert-Computation('A-1')  | Should -Be '0110010';
            Convert-Computation('M-1')  | Should -Be '1110010';
            Convert-Computation('D+A')  | Should -Be '0000010';
            Convert-Computation('D+M')  | Should -Be '1000010';
            Convert-Computation('D-A')  | Should -Be '0010011';
            Convert-Computation('D-M')  | Should -Be '1010011';
            Convert-Computation('A-D')  | Should -Be '0000111';
            Convert-Computation('M-D')  | Should -Be '1000111';
            Convert-Computation('D&A')  | Should -Be '0000000';
            Convert-Computation('D&M')  | Should -Be '1000000';
            Convert-Computation('D|A')  | Should -Be '0010101';
            Convert-Computation('D|M')  | Should -Be '1010101';
        }
    }
}

Describe "Check it splits commands correctly" {
    Context "Check Jump" {
        It "Command D;JMP - Returns Jump = JMP, Destination = null, Computation = 'D'" {
            $Commands = Split-Command('D;JMP');
            $Commands.Jump          | Should -Be 'JMP';
            $Commands.Destination   | Should -Be 'null';
            $Commands.Computation   | Should -Be 'D';
        }
        It "Command D=D-M;JMP - Returns Jump = JMP, Destination = D, Computation = 'D-M'" {
            $Commands = Split-Command('D=D-M;JMP');
            $Commands.Jump          | Should -Be 'JMP';
            $Commands.Destination   | Should -Be 'D';
            $Commands.Computation   | Should -Be 'D-M';
        }
        It "Command M=D+M - Returns Jump = null, Destination = M, Computation = 'D+M'" {
            $Commands = Split-Command('M=D+M');
            $Commands.Jump          | Should -Be 'null';
            $Commands.Destination   | Should -Be 'M';
            $Commands.Computation   | Should -Be 'D+M';
        }
        It "Command 0;JMP - Returns Jump = JMP, Destination = null, Computation = 0" {
            $Commands = Split-Command('0;JMP');
            $Commands.Jump          | Should -Be 'JMP';
            $Commands.Destination   | Should -Be 'null';
            $Commands.Computation   | Should -Be '0';
        }
        It "Command D;JGT - Returns Jump = JGT, Destination = null, Computation = D" {
            $Commands = Split-Command('D;JGT');
            $Commands.Jump          | Should -Be 'JGT';
            $Commands.Destination   | Should -Be 'null';
            $Commands.Computation   | Should -Be 'D';
        }
    }
}

Describe "Check some full command conversions" {
    Context "Simple Commands" {
        It "Command: D = D&A,       Returns '1110000000010000'" {
            Convert-Command('D=D&A') | Should -Be '1110000000010000';
        }
        It "Command: D;JMP,         Returns '1110001100000111'" {
            Convert-Command('D;JMP') | Should -Be '1110001100000111';
        }
        It "Command: AMD=M-D;JNE,   Returns '1111000111111101'" {
            Convert-Command('AMD=M-D;JNE') | Should -Be '1111000111111101';
        }
    }
}

Describe "Check identification of line type" {
    Context "Identify Address vs Command" {
        It "Identify Address" {
            $Line = '@R2';
            Identify-Type $Line | Should -Be 'Address';
            $Line = '@2';
            Identify-Type $Line | Should -Be 'Address';
        }
        It "Identify Command" {
            $Line = 'D=A';
            Identify-Type $Line | Should -Be 'Command';
            $Line = 'D=D+A';
            Identify-Type $Line | Should -Be 'Command';
            $Line = 'D;JMP';
            Identify-Type $Line | Should -Be 'Command';
            $Line = 'D=D+A;JGE';
            Identify-Type $Line | Should -Be 'Command';
        }
    }
}

Describe "Check line type based conversion" {
    Context "Convert some Addresses" {
        It "Simple Addresses" {
            $Line = '@R2';
            Convert-Line($Line) | Should -Be '0000000000000010';
            $Line = '@2';
            Convert-Line($Line) | Should -Be '0000000000000010';
            $Line = '@R16';
            Convert-Line($Line) | Should -Be '0000000000010000';
            $Line = '@16';
            Convert-Line($Line) | Should -Be '0000000000010000';
        }
    }

    Context "Convert some Commands" {
        It "Simple Commands" {
            $Line = 'D=D&A';
            Convert-Line($Line) | Should -Be '1110000000010000';
            $Line = 'D;JMP'
            Convert-Line($Line) | Should -Be '1110001100000111';
            $Line = 'AMD=M-D;JNE'
            Convert-Line($Line) | Should -Be '1111000111111101';
        }
    }
}

Describe "Convert a simple Program" {
    Context "Add.asm" {
        It "Converts lines" {
            $Lines = @('@2'; 'D=A'; '@3'; 'D=D+A'; '@0'; 'M=D');
            $ConvertedLines = Convert-LineList $Lines;
            $ConvertedLines[0] | Should -Be '0000000000000010';
            $ConvertedLines[1] | Should -Be '1110110000010000';
            $ConvertedLines[2] | Should -Be '0000000000000011';
            $ConvertedLines[3] | Should -Be '1110000010010000';
            $ConvertedLines[4] | Should -Be '0000000000000000';
            $ConvertedLines[5] | Should -Be '1110001100001000';
        }
    }
}

Describe "Load a program from file and evaluate conversion" {
    Context "Add.asm" {
        It "Loads the program and checks the lines" {
            $Path = '/Users/glenmacdonald/git/Nand2TetrisPt1/projects/06/add/Add.asm';
            $ConvertedFile = Convert-File $Path;
            $ConvertedFile[0] | Should -Be '0000000000000010';
            $ConvertedFile[1] | Should -Be '1110110000010000';
            $ConvertedFile[2] | Should -Be '0000000000000011';
            $ConvertedFile[3] | Should -Be '1110000010010000';
            $ConvertedFile[4] | Should -Be '0000000000000000';
            $ConvertedFile[5] | Should -Be '1110001100001000';
        }
    }
}

Describe "Load a program from file and evaluate conversion" {
    Context "Add.asm" {
        It "Loads the program and checks the lines" {
            $Path = '/Users/glenmacdonald/git/Nand2TetrisPt1/projects/06/add/Add.asm';
            Convert-FileAndSave $Path;
            $ReLoadedFile = Get-Content ($Path -replace 'asm','hack');
            $ReLoadedFile[0] | Should -Be '0000000000000010';
            $ReLoadedFile[1] | Should -Be '1110110000010000';
            $ReLoadedFile[2] | Should -Be '0000000000000011';
            $ReLoadedFile[3] | Should -Be '1110000010010000';
            $ReLoadedFile[4] | Should -Be '0000000000000000';
            $ReLoadedFile[5] | Should -Be '1110001100001000';
        }
    }
}