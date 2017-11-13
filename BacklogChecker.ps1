Import-Module Dfsr
function ConvertTo-Json20([object] $item){
    add-type -assembly system.web.extensions
    $ps_js=new-object system.web.script.serialization.javascriptSerializer
    return $ps_js.Serialize($item)
}
function QueryDFSBackLogs
{
Param(
[Parameter(Mandatory)]
[string]$GroupName,
[string]$FolderName,
[string]$SourceComputerName,
[string]$DestinationComputerName
)

Get-DfsrBacklog -GroupName $GroupName -FolderName $FolderName -SourceComputerName $SourceComputerName -DestinationComputerName $DestinationComputerName -Verbose

}
function Format-JSON-File
{
[CmdletBinding()]
Param
(
[Parameter(Mandatory,ValueFromPipeline)]
[pscustomobject]$InputObject
)
Process
{
ConvertTo-Json -PipelineVariable $InputObject
}
}