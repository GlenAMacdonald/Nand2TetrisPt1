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
        Write-Host "Computation was not parsed - problem with compiler";
    }

    $ReturnObject = @{'Destination' = $Destination; 'Computation' = $Computation; 'Jump' = $Jump};
    return $ReturnObject;
}