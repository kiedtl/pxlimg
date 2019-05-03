function compress {
    param (
        [string]$pxl,
        [string]$out,
        [switch]$verbose
    )

    $E = [char]0x1b

    $cpxl = @()
    $pixels = @()
    $ctr = 0

    # example of $pxl
    # $E[48;2;245;133;111m$E[38;2;123;234;56m▀$E[48;2;174;221;223m$E[38;2;123;234;99m▀$E[0m$E[B$E[0G

    foreach ($line in Get-Content $pxl) {
        # get each individual pixel
        $pixels = $line.TrimEnd("$E[0m$E[B$E[0G").Split('▀')
        foreach ($pixel in $pixels) {
            $newpxl = ""
            if ("" -eq $pixel) {
                continue
            }
            $pixel = $pixel.TrimStart($E)

            $bg_sgr = ($pixel.Split($E)[0])
            $bg_sgr = $bg_sgr.TrimEnd('m')

            $fg_sgr = ($pixel.Split($E)[1]).TrimEnd('m')

            $mbgr, $mbgg, $mbgb = $bg_sgr.Split(';')[2..4]
            $mfgr, $mfgg, $mfgb = $fg_sgr.Split(';')[2..4]

            [char]$bgr = [char](([int]$mbgr) + 125)
            [char]$bgg = [char](([int]$mbgg) + 125)
            [char]$bgb = [char](([int]$mbgb) + 125)
            [char]$fgr = [char](([int]$mfgr) + 125)
            [char]$fgg = [char](([int]$mfgg) + 125)
            [char]$fgb = [char](([int]$mfgb) + 125)

            $newpxl += "${bgr}${bgg}${bgb}|${fgr}${fgg}${fgb};"
            $cpxl += $newpxl 
            $ctr++
            if ($verbose) {
                write-output "pxl-comp: compressed pixel #$ctr ($($bg_sgr);${fg_sgr}) as $newpxl"
            }
        }
        $cpxl += "`n"
    }

    "%PXLCv0.0.1" > $out 
    $cpxl -join '' >> $out
}