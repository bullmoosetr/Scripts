

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

    $computers = @("STOR45CT1ZA01")
    foreach($computer in $computers){$VerboseMessage = (Get-DfsrBacklog -GroupName "*" -SourceComputerName $env:COMPUTERNAME -DestinationComputerName $computer -Verbose 4>&1)   } 
    $Status
    $Date = Get-Date
if ($VerboseMessage -like "*The replicated folder has a backlog of files*")
{
    
    $Status
    Add-Content \\uk.corp.local\STORAGE\PROJECTS\IT\GNOC\PRTG\BackLogDocs\BacklogCount.txt  "1:$VerboseMessage $Date"
   
}
elseif ($VerboseMessage -like "*No backlog for the replicated folder named*")
{
    Add-Content \\uk.corp.local\STORAGE\PROJECTS\IT\GNOC\PRTG\BackLogDocs\BacklogCount.txt "0:OK $Date" 
    break
}
}
}
catch
{

    Add-Content \\uk.corp.local\STORAGE\PROJECTS\IT\GNOC\PRTG\BackLogDocs\BacklogCountError.txt $Error $Date

}
}
BacklogCount
