#requires -version 2
# Copyright (c) 2019 Kied Llaentenn

param(
	$x
)
set-strictmode -off

$cmd = $x

# Escape character, needed for ANSI terminal sequences
[char]$E = [char]27

[string]$mya_version = "v0.0.1"
[string]$mya_name = "pxlit"

# Load files with helper functions
# Also load the commands file which loads
# command implementations
. "$psscriptroot\..\lib\commands.ps1"

# Load commands
$commands = commands
if ('--version' -contains $cmd -or (!$cmd -and '-V' -contains $args)) {
	write-output "$E[38;2;150;150;150m$mya_name version $E[1m$E[38;2;50;233;15m$mya_version$E[0m"
}
# Show help message if command list is null,
# the command is `/?`, or the arguement list contains
# `--help` or `-h`
elseif (@($null, '--help', '/?') -contains $cmd -or $args[0] -contains '-h') {
	exec 'help' $args		
}
# Execute appropriate command
elseif ($commands -contains $cmd) {
	try {
		exec $cmd $args
	}
	catch { }
	finally { }
}
else {
	Write-Host "${mya_name}: '$cmd' isn't a valid command. Try '${mya_name} help'." 
	exit 12
}
