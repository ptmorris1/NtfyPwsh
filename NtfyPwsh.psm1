Get-ChildItem -Path "$PSScriptRoot\public\*.ps1" -Recurse | ForEach-Object {
    . $_.FullName
}