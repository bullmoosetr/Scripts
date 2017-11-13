#Created by Eric Laff
##########################################################Email Settings##########################################################
##########################################################Determine SMTP Server##################################################
$ComName= gc env:computername
IF (($ComName -Like '*CORP*') -or ($ComName -Like '*40NY1*'))
{
$smtpServer = "MAILSERVER"
}
IF ($ComName -Like '*20NY1*' -OR $ComName -Like '*30NY1*' -OR $ComName -Like '*60NY1*' -OR $ComName -Like '*70NY1*' -OR $ComName -Like '*30NY1*' -OR $ComName -Like '*1NJ2*')
{
$smtpServer = "smtp-pmta"
}
IF ($ComName -Like '*1DC3*' )
{
$smtpServer = "smtp-dc3"
}
##########################################################Send To & Subject######################################################
$smtpFrom = 'NOCTasks@i-Deal.com'
$smtpTo = 'NOC@ipreo.com'
$messageSubject= $ComName + ' D:\ProgramData\Paessler\PRTG Network Monitor\Logs(Debug) - Grooming Job (All Folders)'
$EStart="<font face='verdana' size='2'>"
$EEnd="</Font>"
##################################################################################################################################################################
##################################################################################################################################################################
$Checker = 0
#Directory
$directory = "D:\ProgramData\Paessler\PRTG Network Monitor\Logs (Debug)"

Get-Service "PRTGCoreService" | Where-Object {$_.Status -eq "Running"} | Stop-Service | Start-Sleep -s 60 | Get-Service "PRTGProbeService" | Where-Object {$_.Status -eq "Running"} | Stop-Service

$source = Get-ChildItem "D:\ProgramData\Paessler\PRTG Network Monitor\Logs (Debug)" | Where-Object{$_.Name -like "snmpdebug 0.log" -or $_.Name -like "metasnmpdebug 0.log"} | Remove-Item

Get-Service "PRTGCoreService" | Where-Object {$_.Status -eq "Stopped"} | Stop-Service | Start-Sleep -s 60 | Get-Service "PRTGProbeService" | Where-Object {$_.Status -eq "Stopped"} | Start-Service

foreach ($file in $directory)
{
$file = $file.name
$dir = $directory
if (Test-Path $dir\$source)
{
$Checker++
}
}
If ($Checker -gt '0')
{
    $Body = "The log files metasnmpdebug 0.log and snmpdebug 0.log have been cleared and refreshed for the past week." 
}
Else
{
    $Body = "No files to delete today"
}
$Ebody= $EStart + $Body + $EEnd

send-mailmessage -from "$smtpFrom" -to "$smtpTo" -cc $smtpCC -subject "$messageSubject" -body "$EBody" -BodyAsHtml -smtpServer "$smtpserver"





 
