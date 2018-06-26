

function BacklogCount
{
[CmdletBinding()]
param
()
try
{
$VerbosePreference = 'Continue'
for ($i = 0;$i -le 5;$i++)
{

    $computers = @("")
    foreach($computer in $computers){$VerboseMessage = (Get-DfsrBacklog -GroupName "*" -SourceComputerName $env:COMPUTERNAME -DestinationComputerName $computer -Verbose 4>&1)   } 
    $Status
    $Date = Get-Date
if ($VerboseMessage -like "*The replicated folder has a backlog of files*")
{
    
    $Status
    Add-Content   "1:$VerboseMessage $Date"
   
}
elseif ($VerboseMessage -like "*No backlog for the replicated folder named*")
{
    Add-Content  "0:OK $Date" 
    break
}
}
}
catch
{

    Add-Content  $Error $Date

}
}
BacklogCount
