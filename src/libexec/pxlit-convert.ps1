# Usage: pxlit convert [-vp] [-i image] [> destination]
# Summary: Convert an image to the PXL format.
# Help: Convert a PNG, BMP, or JPEG image to a PXL image. Requires Imagemagick.
#
# Options:
#   -i, --srcfile              The source image to convert.
#   -c, --columns              Control the size of the resulting image by specifying
#                              the number of columns. Default: width of terminal.

param (
    [alias('i')]$srcfile,
    [alias('c')]$columns = $host.UI.RawUI.WindowSize.Width
)

. "$psscriptroot/../lib/convert.ps1"

if (-not (test-path $srcfile)) {
    write-host "error: provided srcfile does not exist"
    exit 1
}


convertpxl -path $srcfile -size $columns