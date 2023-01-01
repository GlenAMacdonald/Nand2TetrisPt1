function Clear-WhiteSpace {
    param(
        [String]$line
    )
    $cleanedLine = $line -replace ' ','';
    return $cleanedLine;
}

function Clear-Comment {
    param(
        [String]$line
    )

    $cleanedLine = ($line -split '//')[0];
    return $cleanedLine;
}

function Clear-All {
    param(
        [String]$line
    )

    $cleanedLine = (Clear-WhiteSpace($line));
    $cleanedLine = (Clear-Comment($cleanedLine));
    return $cleanedLine;
}

function Clear-AllLines {
    param(
        $lines
    )

    $ClearedLines = [System.Collections.ArrayList]::new();
    ForEach ($line in $lines) {
        $ClearedLine = (Clear-All($line))
        if (-not ($ClearedLine -eq '')){
            [void]$ClearedLines.Add($ClearedLine);
        }
    }

    return $ClearedLines;
}