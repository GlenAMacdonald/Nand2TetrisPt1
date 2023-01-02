function Get-PredefinedSymbolTable {
    $PredefinedSymbolTable = @{ 'R0'=0;
                                'R1'=1;
                                'R2'=2;
                                'R3'=3;
                                'R4'=4;
                                'R5'=5;
                                'R6'=6;
                                'R7'=7;
                                'R8'=8;
                                'R9'=9;
                                'R10'=10;
                                'R11'=11;
                                'R12'=12;
                                'R13'=13;
                                'R14'=14;
                                'R15'=15;
                                'R16'=16;
                                'SCREEN'=16384;
                                'KBD'=24576;
                                'SP'=0;
                                'LCL'=1;
                                'ARG'=2;
                                'THIS'=3;
                                'THAT'=4;
                            }
    return $PredefinedSymbolTable;
}

function Get-SymbolTable {
    param (
        $Lines
    )

    $SymbolTable = Get-PredefinedSymbolTable;
    $index = 0;
    ForEach ($Line in $Lines) {
        if ($Line -like '(*)'){
            $Symbol = $Line -Replace '\(','';
            $Symbol = $Symbol -Replace '\)','';
            if (-not $SymbolTable.Contains($Symbol)) {
                $SymbolTable.Add($Symbol,$index);
            }
        } else {
            $index++;
        }
    }
    return $SymbolTable;
}

function Convert-Symbols {
    param (
        $Lines
    )

    $SymbolTable = Get-SymbolTable $Lines;
    $ConvertedSymbols = [System.Collections.ArrayList]::new();
    $NextAvailableRegister = 16;
    ForEach ($Line in $Lines) {
        if ($Line.Contains('@')) {
            $Symbol = $Line -replace '@','';
            if ($Symbol -match '^[0-9]') {
                [void]$ConvertedSymbols.Add($Line);
            }
            elseif ($SymbolTable.Contains($Symbol)){
                [void]$ConvertedSymbols.Add(('@'+ $SymbolTable.$Symbol));
            } 
            else {
                $SymbolTable.Add($Symbol,$NextAvailableRegister);
                [void]$ConvertedSymbols.Add('@'+ $NextAvailableRegister);
                $NextAvailableRegister++;
            }
        } elseif (-not ($Line -like '(*)')) {
            [void]$ConvertedSymbols.Add($Line);
        }
    }
    return $ConvertedSymbols;
}