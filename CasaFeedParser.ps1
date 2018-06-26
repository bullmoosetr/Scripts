$servers = 'Server'.Split(',')#Add servers to tuple 
foreach ($server in $servers){
Write-Host $server
$result = Invoke-Command -ComputerName $server -ScriptBlock {Get-Content -Path "" | Where-Object {$_ -like '**'} } 
}
