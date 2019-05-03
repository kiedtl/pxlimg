function relpath($path) { "$($myinvocation.psscriptroot)\$path" } # relative to calling script
function command_files {
    (Get-ChildItem (relpath '../libexec')) | Where-Object { $_.name -match 'pxlit-.*?\.ps1$' }
}

function commands {
    command_files | ForEach-Object { command_name $_ }
}

function command_name($filename) {
    $filename.name | Select-String 'pxlit-(.*?)\.ps1$' | ForEach-Object { $_.matches[0].groups[1].value }
}

function command_path($cmd) {
    $cmd_path = relpath "../libexec/pxlit-$cmd.ps1"

    $cmd_path
}

function exec($cmd, $arguments) {
    $cmd_path = command_path $cmd
    & $cmd_path @arguments
}
