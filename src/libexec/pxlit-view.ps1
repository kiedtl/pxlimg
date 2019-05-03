# Usage: pxlit view [-a] [-file image]
# Summary: View a PXL image
# Help: This command prints out the PXL image in the terminal.
#
# Options:
#   -a, --ascii              Open the file with the ASCII encoding instead of UTF-8.

param (
    [string]$file,
    [alias('a')]
    [switch]$ascii
)

$encoding = 'UTF8'

if ($ascii.IsPresent) {
    $encoding = 'ASCII'
}

if (test-path $file) {
    get-content -path $file -encoding $encoding
}