$servers = 'Server'.Split(',')#Add servers to tuple 
foreach ($server in $servers){
Write-Host $server
$result = Invoke-Command -ComputerName $server -ScriptBlock {Get-Content -Path "D:\Temp\NOC TEST\Test.txt" | Where-Object {$_ -like '**'} } 
}
