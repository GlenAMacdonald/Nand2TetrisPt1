function Convert-Value {
    param (
        [String]$Value
    )

    $Value = $Value -Replace '@', '';
    $Value = $Value -Replace 'R', '';

    $BinaryValue = [convert]::ToString($Value,2);
    $BinaryValue = $BinaryValue.PadLeft(16,'0');

    return $BinaryValue;
}

function Convert-Jump {
    param(
        [String]$Jump
    )

    switch ($Jump) {
        'null' {return '000'};
        'JGT'  {return '001'};
        'JEQ'  {return '010'};
        'JGE'  {return '011'};
        'JLT'  {return '100'};
        'JNE'  {return '101'};
        'JLE'  {return '110'};
        'JMP'  {return '111'};
        Default {return $null}
    }
}

function Convert-Destination {
    param(
        [String]$Destination
    )

    switch ($Destination) {
        'null'  {return '000'};
        'M'     {return '001'};
        'D'     {return '010'};
        'MD'    {return '011'};
        'A'     {return '100'};
        'AM'    {return '101'};
        'AD'    {return '110'};
        'AMD'   {return '111'};
        Default {return $null}
    }
}

function Convert-Computation {
    param (
        [String]$Computation
    )

    switch ($Computation) {
        '0'     {return '0101010' };
        '1'     {return '0111111' };
        '-1'    {return '0111010' };
        'D'     {return '0001100' };
        'A'     {return '0110000' };
        'M'     {return '1110000' };
        '!D'    {return '0001101' };
        '!A'    {return '0110001' };
        '!M'    {return '1110001' };
        '-D'    {return '0001111' };
        '-A'    {return '0110011' };
        '-M'    {return '1110011' };
        'D+1'   {return '0011111' };
        'A+1'   {return '0110111' };
        'M+1'   {return '1110111' };
        'D-1'   {return '0001110' };
        'A-1'   {return '0110010' };
        'M-1'   {return '1110010' };
        'D+A'   {return '0000010' };
        'D+M'   {return '1000010' };
        'D-A'   {return '0010011' };
        'D-M'   {return '1010011' };
        'A-D'   {return '0000111' };
        'M-D'   {return '1000111' };
        'D&A'   {return '0000000' };
        'D&M'   {return '1000000' };
        'D|A'   {return '0010101' };
        'D|M'   {return '1010101' };
        Default {return $null}
    }
}

function Split-Command {
    # Symbolic Syntax: dest = comp ; jump
    # Examples: 
    #   D;JMP
    #   D=D-M;JMP
    #   M=D+M
    #   0;JMP

    param (
        [String]$Command
    )
    $HasDestination = $Command.Contains('=');
    $HasJump        = $Command.Contains(';');
    
    if ($HasDestination) {
        $Destination = ($Command -split '=')[0];
        if (-not $HasJump){
            $Computation = ($Command -split '=')[1];
        } else {
            $Computation = (($Command -split '=')[1] -split ';')[0];
        }
    } else {
        $Destination = 'null';
    }

    if ($HasJump) {
        $Jump        = ($Command -split ';')[1];
        if (-not $HasDestination) {
            $Computation = ($Command -split ';')[0];
        }
    } else {
        $Jump = 'null';
    }

    if (($Computation -eq '') -or (-not $Computation)) {
        Write-Host "Computation was not parsed - problem with compiler function 'Split-Command'";
    }

    $ReturnObject = @{'Destination' = $Destination; 'Computation' = $Computation; 'Jump' = $Jump};
    return $ReturnObject;
}

function Identify-Type {
    param (
        [String]$line
    )

    if ($line.Contains('@')) {
        return 'Address';
    } elseif ($line.Contains(';') -or $line.Contains('=')) {
        return 'Command';
    } else {
        Write-Host "Line Type was indeterminate - Function Identify-Type needs updating"
        Write-Host "Problematic line is: $line";
        return $null;
    }
}



function Convert-Command {
    # Command Binary Syntax = 111aC1C2C3C4C5C6D1D2D3J1J2J3,
    # or equivalently = 111CommandInBinaryDestinationInBinaryJumpInBinary
    param (
        [String]$Command
    )
    $Commands = Split-Command($Command);
    $JumpInBinary = Convert-Jump($Commands.Jump);
    $DestinationInBinary = Convert-Destination($Commands.Destination);
    $ComputationInBinary = Convert-Computation($Commands.Computation);
    $CommandInBinary = '111' + $ComputationInBinary + $DestinationInBinary + $JumpInBinary;

    return $CommandInBinary;
}

function Convert-Commands {
    param(
        $Commands
    )

    $ConvertedCommands = [System.Collections.ArrayList]::new();
    ForEach ($Command in $Commands) {
        $ConvertedCommand = Convert-Command($Command);
        [void]$ConvertedCommands.Add($ConvertedCommand);
    }
    
    return $ConvertedCommands;
}

function Convert-Address {
    param (
        [String]$Address
    )

    try {
        [void]([convert]::ToInt32(($Address -Replace '@','')));
        return Convert-Value $Address;
    }
    catch {
        try {
            [void]([convert]::ToInt32(($Address -Replace '@R','')));
            return Convert-Value $Address;
        }
        catch {
            return $null;
        }
    }
}

function Convert-Line {
    param (
        [String]$Line
    )

    $LineType = Identify-Type $Line;

    if ($LineType -eq 'Address') {
        $ConvertedLine = Convert-Address $Line;
    } elseif ($LineType -eq 'Command') {
        $ConvertedLine = Convert-Command $Line;
    }

    return $ConvertedLine;
}

function Convert-LineList {
    param (
        $Lines
    )

    $ConvertedLines = [System.Collections.ArrayList]::new();

    ForEach ($Line in $Lines) {
        [void]$ConvertedLines.Add((Convert-Line $Line));
    }

    return $ConvertedLines;
}

function Convert-File {
    param (
        [String]$Path
    )

    Import-Module ./Clear-Line.ps1 -Force;

    if (-not (Test-Path $Path)) {
        Write-Host "File could not be found at $Path";
        return $null;
    }

    $LoadedFile = Get-Content $Path;
    $ClearedFile = Clear-AllLines $LoadedFile;
    $ConvertedFile = Convert-LineList $ClearedFile;
    
    return $ConvertedFile;
  
    
}

function Convert-FileAndSave {
    param (
        [String]$Path
    )
    $ConvertedFile = Convert-File $Path;
    $ConvertedFile | Out-File ($Path -replace 'asm','hack');
}