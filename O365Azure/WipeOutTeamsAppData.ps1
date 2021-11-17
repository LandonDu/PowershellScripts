#Stops the Team process
Get-Process -name *Teams* | Stop-Process -force

$users = get-childitem C:\users\ -exclude 'public' | Select-Object -expand Name

foreach ($user in $Users) {Get-ChildItem -Path C:\users\$user\appdata -Include *teams* -Attributes directory -Recurse -erroraction SilentlyContinue| Remove-Item -recurse -Force}