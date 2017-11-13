#-------------------------------------------------------------------------
#Script Log Archiver
#Author Eric Laff
#Date 6/6/2016
#-------------------------------------------------------------------------
try
{
$Datestamp = Get-Date -Format "dd-MM-yyyy"
$destination = "C:\Users\lafferic\Desktop\Test2\$DateStamp.Zip"
$destinationDir = "C:\Users\lafferic\Desktop\Test2"
$tempFolder = New-Item -Path "C:\Users\lafferic\Desktop\Test2" -Name "Temp Folder" -ItemType directory
$tempFolder
$source = @(Get-ChildItem "C:\Users\lafferic\Desktop\TestDir" -Include *.txt -Recurse | Where-Object {$_.LastWriteTime -lt (Get-Date).AddDays((-30))})
foreach ($log in $source){ Copy-Item $log "C:\Users\lafferic\Desktop\Test2\Temp Folder" -Force} 
Remove-Item $source
Add-Type -assembly "system.io.compression.filesystem"
[io.compression.zipfile]::CreateFromDirectory($tempFolder, $destination)
Remove-Item "C:\Users\lafferic\Desktop\Test2\Temp Folder" -Recurse
$Error.Clear()
}
Catch
{
"File already exist, Please check the directory"
}
$smtpserver = "nycmail"
$To = "GNOC@ipreo.com"
 if ($Error.Count -gt 0){
 $Status = " REQTY60NY1US01 D:\Logs - NOT OK"
        $MailBody =  "Please investigate, removal of these files were not successful: <br>" + $source + "<br>" + (Get-Date).ToString() + $Error[0].toString()
        $Error.clear()
 }
 else{
   $Status = " REQTY60NY1US01 D:\Logs - OK"
   $MailBody = $MailBody +  " Logs have been archived. $destination" + "" + (Get-Date).ToString()
  
 }
Send-MailMessage -SmtpServer $smtpserver -To $To -from "NOCTasks@ipreo.com" -Subject "$env:COMPUTERNAME $Status" -BodyAsHtml -Body $MailBody
