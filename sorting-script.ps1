
$files = @(Get-Item C:\Users\lafferic\Desktop*).LastWriteTime | Get-Item $_.Name

