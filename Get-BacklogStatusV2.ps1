try
{
$TextContent = Get-Content -Path \\uk.corp.local\STORAGE\PROJECTS\IT\GNOC\PRTG\BackLogDocs\BacklogCount.txt | select -Last 1
############################################################################################################################




############################################################################################################################

if (($TextContent.Substring(0,4)).Trim() -eq "0:OK")
{
    $time1 = $TextContent.Substring(15,9)
    $time2 = Get-Date -Format HH:mm:ss
    $timeDiff = New-TimeSpan $time1 $time2
if ($timeDiff.Minutes -lt 15)
{
        $Hrs = ($timeDiff.Hours) + 0
        $Mins = ($timeDiff.Minutes) + 1
        $Secs = ($timeDiff.Seconds) + 1

} 
else
{
        $Hrs = $TimeDiff.Hours
	    $Mins = $TimeDiff.Minutes
	    $Secs = $TimeDiff.Seconds       
}
$Difference = '{0:00}:{1:00}:{2:00}' -f $Hrs,$Mins,$Secs
if ($Difference -ge "00:15:00") 
{   
    Write-Host "1:The backlog check data is stale, last checked at"  $TextContent.SubString(15,9)  "please check the scheduled task"
    exit 1
}
else
{
    Write-Host "0:OK"
    exit 0
}
}
if ($TextContent.Substring(0,1) -like "1" -and ($TextContent.Substring(88,10)).Trim() -eq (Get-Date).ToString('MM/dd/yyyy'))
{
    $time1 = $TextContent.Substring(99,8)
    $time2 = Get-Date -Format HH:mm:ss
    $timeDiff = New-TimeSpan $time1 $time2
if ($timeDiff.Minutes -lt 15)
{
        $Hrs = ($timeDiff.Hours) + 0
        $Mins = ($timeDiff.Minutes) + 1
        $Secs = ($timeDiff.Seconds) + 1

} 
else
{
        $Hrs = $TimeDiff.Hours
	    $Mins = $TimeDiff.Minutes
	    $Secs = $TimeDiff.Seconds       
}
$Difference = '{0:00}:{1:00}:{2:00}' -f $Hrs,$Mins,$Secs
if ($Difference -ge "00:15:00") 
{   
    Write-Host "1:The backlog check data is stale, last checked at"  $TextContent.SubString(99,8)  "please check the scheduled task"
    exit 1
}
else
{
    $Text = $TextContent.Substring(0,107)
    Write-Host "1:$Text"
    exit 1
}
}
}
catch
{
Write-Host "1:$Error"
exit 1
}