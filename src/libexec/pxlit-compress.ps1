# Usage: pxlit compress [-i image] [-o destination]
# Summary: Compress a PXL image
# Help: Compress a PXL image and reduce the file size by as much as 67%.
#
# Note: It is recommended to use the .pxlc file extension for the compressed image.
#
# Options:
#   -v, --verbose              Write (very) verbose information.
#   -o, --outfile              The file to which to write the compressed image.
#   -i, --srcfile              The source archive to compress.

param (
    [alias('i')]
    [string]$srcfile = $(write-host "error: no srcfile provided"; exit 1),
    [alias('o')]
    [string]$outfile = $(write-host "error: no outfile provided"; exit 1),
    [alias('v')]
    [switch]$verbose
)

. "$psscriptroot/../lib/compress.ps1"

if (-not (test-path $srcfile)) {
    write-host "error: provided srcfile does not exist"
    exit 1
}

if ($verbose) {
    compress -pxl $srcfile -out $outfile -verbose
} else {
    compress -pxl $srcfile -out $outfile
}