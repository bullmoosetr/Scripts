function Get-Server-Name
{
[CmdletBinding()]
[OutputType([System.Management.Automation.PSCustomObject])]
param
(
[Parameter(Mandatory)]
[string]$Machine

)
[pscustomobject]@{'Machine' = $Machine}
}


function Get-Powershell-Version
{
[CmdletBinding()]
param (

[Parameter(Mandatory,ValueFromPipeline)]
[pscustomobject]$InputObject
)
process
{
Write-Host $InputObject.Machine
Get-Host -PipelineVariable $InputObject.Machine -Verbose

}

}



$Servers = {'ny-corp-noc1','ny-corp-noc2','ny-corp-noc3'}
foreach ($server in $Servers)
{
$a = @{Expression=$server;Label="Server Name"; width=25}
Get-Server-Name -Machine $server | Get-Powershell-Version -Verbose | Format-Table $a,Version  -Wrap
} 