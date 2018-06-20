try{
$services = "Winmgmt","lmhosts"
Invoke-Command -ComputerName "computer" -Credential domain01\user01 -ScriptBlock {$services.ForEach({Restart-Service -Force -Verbose $_; })}
}
Catch{
Write-Host $Error
}