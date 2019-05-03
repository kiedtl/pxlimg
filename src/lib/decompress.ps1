function decompress {
    param (
        [string]$pxl = $(write-host "error: no srcfile provided"; exit 1),
        [string]$out = $(write-host "error: no outfile provided"; exit 1),
        [switch]$verbose
    )

    $E = [char]0x1b
    $cpxl = @()
    $pixels = @()
    $char = '▀'

    foreach ($line in Get-Content $pxl) {
        if ($line -match '^%PXLCv((([0-9])+\.?))+$') {
            continue
        } 
        $pixels = $line.Split(';')
        foreach ($pixel in $pixels) {
            if ($pixel -eq $null -or ($pixel -eq '')) {
                continue
            }
            $bgsgr = $pixel.split('|')[0]
            $fgsgr = $pixel.split('|')[1]

            $mbgr = [char]$bgsgr[0]
            $mbgg = [char]$bgsgr[1]
            $mbgb = [char]$bgsgr[2]
            $mfgr = [char]$fgsgr[0]
            $mfgg = [char]$fgsgr[1]
            $mfgb = [char]$fgsgr[2]

            [int]$bgr = [int][char](([int]$mbgr) - 125)
            [int]$bgg = [int][char](([int]$mbgg) - 125)
            [int]$bgb = [int][char](([int]$mbgb) - 125)
            [int]$fgr = [int][char](([int]$mfgr) - 125)
            [int]$fgg = [int][char](([int]$mfgg) - 125)
            [int]$fgb = [int][char](([int]$mfgb) - 125)

            $cpxl += "$E[48;2;${bgr};${bgg};${bgb}m$E[38;2;${fgr};${fgg};${fgb}m${char}"
            if ($verbose) {
                write-output "pxl-comp: uncompressed pixel $pixel (bg: $bgsgr fg: $fgsgr) as ${bgr},${bgg},${bgb}"
            }
        }
        
        $cpxl += "$E[0m$E[B$E[0G`n"
    }

    (-join $cpxl) > $out
}