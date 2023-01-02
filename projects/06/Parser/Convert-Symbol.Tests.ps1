BeforeAll {
    Import-Module ./Convert-Symbol.ps1 -Force;
}

Describe "Check it can Create a symbol table" {
    Context "Try a few symbols" {
        It "Can detect one" {
            $Lines = @('(LOOP)','@R1');
            $SymbolTable = Get-SymbolTable $Lines;
            $SymbolTable.LOOP | Should -Be 0;
        }
        It "Ignores duplicate symbols" {
            $Lines = @('(LOOP)','(LOOP)');
            $SymbolTable = Get-SymbolTable $Lines;
            $SymbolTable.LOOP | Should -Be 0;
        }
        It "Can detect two" {
            $Lines = @('(LOOP)','(STOP)');
            $SymbolTable = Get-SymbolTable $Lines;
            $SymbolTable.LOOP | Should -Be 0;
            $SymbolTable.STOP | Should -Be 0;
        }
        It "Can detect two separated by one" {
            $Lines = @('(LOOP)','@R1','(STOP)');
            $SymbolTable = Get-SymbolTable $Lines;
            $SymbolTable.LOOP | Should -Be 0;
            $SymbolTable.STOP | Should -Be 1;
        }
        It "Can detect two, spread apart" {
            $Lines = @('(LOOP)','@R3','D=M','@1','0;JMP','(STOP)','@21','A=M+1');
            $SymbolTable = Get-SymbolTable $Lines;
            $SymbolTable.LOOP | Should -Be 0;
            $SymbolTable.STOP | Should -Be 4;
        }
    }
}

Describe "See if it can replace Symbols" {
    Context "@LOOP needs to be replaced with the line number where (LOOP) is defined" {
        It "Define (LOOP) and then replace it"{
            $Lines = @('@R1','D=A','@LOOP','AMD=D|A;JMP','(LOOP)','@R3','D=M','@1','0;JMP','@21','A=M+1');
            $NewLines = Convert-Symbols $Lines;
            $NewLines[2] | Should -Be '@4';
        }
        It "Define variable 'i'" {
            $Lines = @('@R1','D=A','@i','AMD=D|A;JMP','@R3','D=M','@i','0;JMP','@21','A=M+1');
            $NewLines = Convert-Symbols $Lines;
            $NewLines[2] | Should -Be '@16';
            $NewLines[6] | Should -Be '@16';
        }
        It "Define variables 'a','b','c','d','e' and make sure they are sequentially defined" {
            $Lines = @('@a','D=A','@b','AMD=D|A;JMP','@c','D=M','@d','0;JMP','@e','A=M+1','@a','D=A','@b','AMD=D|A;JMP','@c','D=M','@d','0;JMP','@e','A=M+1');
            $NewLines = Convert-Symbols $Lines;
            $NewLines[0] | Should -Be '@16';
            $NewLines[2] | Should -Be '@17';
            $NewLines[4] | Should -Be '@18';
            $NewLines[6] | Should -Be '@19';
            $NewLines[8] | Should -Be '@20';
            $NewLines[10] | Should -Be '@16';
            $NewLines[12] | Should -Be '@17';
            $NewLines[14] | Should -Be '@18';
            $NewLines[16] | Should -Be '@19';
            $NewLines[18] | Should -Be '@20';
        }
    }
}