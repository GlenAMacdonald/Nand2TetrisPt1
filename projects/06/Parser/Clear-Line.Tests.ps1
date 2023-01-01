BeforeAll {
    Import-Module .\Clear-Line.ps1 -Force;
}

Describe "Send the function some simple single line commands" {
    Context "An empty line" {
        It "Returns an Empty String #0" {
            $line = '     ';
            (Clear-WhiteSpace($line)) | Should -Be '';
        }
    }
    
    Context "Some Comment lines" {
        It "Returns an Empty String #1" {
            $line = '// Some comment';
            (Clear-Comment($line)) | Should -Be '';
        }
        It "Returns an Empty String #2" {
            $line = ' // Another comment';
            (Clear-All($line)) | Should -Be '';
        }
    }

    Context "a Line with some code and a comment" {
        It "Returns @R2" {
            $line = '@R2 // Some comment';
            (Clear-WhiteSpace($line)) | Should -Be '@R2//Somecomment';
            (Clear-Comment($line))   | Should -Be '@R2 ';
            (Clear-All($line)) | Should -Be '@R2';
        }
        It "Returns @R3" {
            $line = '@R3// Another comment';
            (Clear-Comment($line))   | Should -Be '@R3';
            (Clear-All($line)) | Should -Be '@R3';
        }
    }

    Context "a Line with some commands and a comment" {
        It "Returns D=A;JMP" {
            $line = 'D = A ; JMP // Some comment';
            (Clear-WhiteSpace($line)) | Should -Be 'D=A;JMP//Somecomment';
            (Clear-All($line)) | Should -Be 'D=A;JMP';
        }
        It "Returns D=D-M;JGT" {
            $line = 'D = D-M; JGT // Another comment';
            (Clear-All($line)) | Should -Be 'D=D-M;JGT';
        }
    }

    Context "a Line with a Symbol" {
        It "Returns (LOOP)" {
            $line = '(LOOP) // Some comment // blah blah';
            (Clear-All($line)) | Should -Be '(LOOP)';
        }
        It "Returns (END)" {
            $line = '(END) //// Another comment';
            (Clear-All($line)) | Should -Be '(END)';
        }
    }

    Context "Many lines" {
        It "Returns one line after removing the comment" {
            $lines = @('// Some Comment','@R1');
            (Clear-AllLines($lines)) | Should -Be '@R1';
        }
        It "Returns two lines after removing the comment" {
            $lines = @('// Some Comment','@R1','D=D');
            $ClearedLines = Clear-AllLines($lines);
            $ClearedLines[0] | Should -Be '@R1';
            $ClearedLines[1] | Should -Be 'D=D';
        }
        It "Returns four lines after removing two comments" {
            $lines = @('// Some Comment','@R1','D=D','//another comment','@R2','D = M+1; JMP');
            $ClearedLines = Clear-AllLines($lines);
            $ClearedLines[0] | Should -Be '@R1';
            $ClearedLines[1] | Should -Be 'D=D';
            $ClearedLines[2] | Should -Be '@R2';
            $ClearedLines[3] | Should -Be 'D=M+1;JMP';
        }
        It "Returns five lines after removing two comments and an inline" {
            $lines = @('// Some Comment','@R1','D=D','//another comment','@R2','D = M+1; JMP','@R3 // why comment here');
            $ClearedLines = Clear-AllLines($lines);
            $ClearedLines[0] | Should -Be '@R1';
            $ClearedLines[1] | Should -Be 'D=D';
            $ClearedLines[2] | Should -Be '@R2';
            $ClearedLines[3] | Should -Be 'D=M+1;JMP';
            $ClearedLines[4] | Should -Be '@R3';
        }
    }
}