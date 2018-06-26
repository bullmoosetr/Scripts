#-------------------------------------------------------------------------
#Script Log Archiver
#Author Eric Laff
#Date 6/6/2016
#-------------------------------------------------------------------------
try
{
$Datestamp = Get-Date -Format "dd-MM-yyyy"
$destination = ""
$destinationDir = ""
$tempFolder = New-Item -Path "" -Name "Temp Folder" -ItemType directory
$tempFolder
$source = @(Get-ChildItem "" -Include *.txt -Recurse | Where-Object {$_.LastWriteTime -lt (Get-Date).AddDays((-30))})
foreach ($log in $source){ Copy-Item $log "" -Force} 
Remove-Item $source
Add-Type -assembly "system.io.compression.filesystem"
[io.compression.zipfile]::CreateFromDirectory($tempFolder, $destination)
Remove-Item "" -Recurse
$Error.Clear()
}
Catch
{
"File already exist, Please check the directory"
}
$smtpserver = ""
$To = ""
 if ($Error.Count -gt 0){
 $Status = "NOT OK"
        $MailBody =  "Please investigate, removal of these files were not successful: <br>" + $source + "<br>" + (Get-Date).ToString() + $Error[0].toString()
        $Error.clear()
 }
 else{
   $Status = "   - OK"
   $MailBody = $MailBody +  " Logs have been archived. $destination" + "" + (Get-Date).ToString()
  
 }
Send-MailMessage -SmtpServer $smtpserver -To $To -from "" -Subject "$env:COMPUTERNAME $Status" -BodyAsHtml -Body $MailBody
