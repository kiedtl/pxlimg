# Usage: pxlit decompress [-v] [-i archive] [-o destination]
# Summary: Decompress a PXL image
# Help: Decompress a PXLC image that has already been compressed with the 'compress' command.
#
# Note: It is recommended to use the .pxl file extension for the uncompressed image.
#
# Options:
#   -v, --verbose              Write (very) verbose information.
#   -o, --outfile              The file to which to write the decompressed image.
#   -i, --srcfile              The source archive to decompress.

param (
    [alias('i')]
    [string]$srcfile = $(write-host "error: no srcfile provided"; exit 1),
    [alias('o')]
    [string]$outfile = $(write-host "error: no outfile provided"; exit 1),
    [alias('v')]
    [switch]$verbose
)

. "$psscriptroot/../lib/decompress.ps1"

if (-not (test-path $srcfile)) {
    write-host "error: provided srcfile does not exist"
    exit 1
}

if ($verbose) {
    decompress -pxl $srcfile -out $outfile -verbose
} else {
    decompress -pxl $srcfile -out $outfile
}