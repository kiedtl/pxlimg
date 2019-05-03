function convertpxl {
    param (
        $path,
        $size
    )

    $E = [char]0x1B
    $COLUMNS = $size
    $CURR_ROW = ""
    $OUTPUT = ""
    $CHAR = [text.encoding]::utf8.getstring((226, 150, 128)) # 226,150,136
    [string[]]$upper = @()
    [string[]]$lower = @()

    foreach ($item in $path) {			
        [array]$pixels = (convert -thumbnail "${COLUMNS}x" -define txt:compliance=PNG $item txt:- ).Split("`n")

        foreach ($pixel in $pixels) {
            $coord = ((([regex]::match($pixel, "([0-9])+,([0-9])+:")).Value).TrimEnd(":")).Split(",")
            [int]$global:col = $coord[0]
            [int]$global:row = $coord[1]
            $rgba = ([regex]::match($pixel, "\(([0-9])+,([0-9])+,([0-9])+,([0-9])+\)")).Value
            $rgba = (($rgba.TrimStart("(")).TrimEnd(")")).Split(",")
            $r = $rgba[0]
            $g = $rgba[1]
            $b = $rgba[2]
            if (($row % 2) -eq 0) {
                $upper += "${r};${g};${b}"
            }
            else {
                $lower += "${r};${g};${b}"
            }

            if (($row % 2) -eq 1 -and ($col -eq ($COLUMNS - 1))) {
                $i = 0
                while ($i -lt $COLUMNS) {
                    $CURR_ROW += "${E}[48;2;$($lower[$i])m${E}[38;2;$($upper[$i])m${CHAR}"
                    $i++
                }
                $OUTPUT += "${CURR_ROW}${E}[0m${E}[B${E}[0G`n"
                $upper = @()
                $lower = @()
            }
            $CURR_ROW = ""
        }

        write-output $OUTPUT
        $OUTPUT = ""
    }
}