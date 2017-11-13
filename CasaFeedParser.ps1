$servers = 'CASA20NY1US04,CASA20NY1US05,CASA20NY1US06'.Split(',')
foreach ($server in $servers){
Write-Host $server
$result = Invoke-Command -ComputerName $server -ScriptBlock {Get-Content -Path "D:\Temp\NOC TEST\Test.txt" | Where-Object {$_ -like '**'} } 
}
