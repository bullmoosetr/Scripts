
$logs = Get-ChildItem -Path C:\Users\lafferic\Desktop\Scripts\*.txt
$log = Get-ChildItem -Path C:\Users\lafferic\Desktop\Scripts\ -recurse | where {((Get-Date)-$_.LastWriteTime).days -ge 30}
for($i=0;$i -lt $logs.Count;$i++ ){
$logs[$i]
$log | Remove-Item -Recurse -Force}

$Error.Clear()
$Status = " FixEdge Logs - OK"
 
 $smtpserver = "smtp-pmta"
 
 $To = "GNOC@ipreo.com"

 if ($Error.Count -gt 0){
 $Status = " Tomcat log grooming -NOT OK"
        $MailBody =  "Please investigate, removal of these files were not successful: <br>" + $OldTomCatHTMLFormat + "<br>" + (Get-Date).ToString() + $Error[0].toString()
        Clear($Error)
 }else{
     $MailBody = $MailBody +  "No old logs found " + (Get-Date).ToString()
 }


 Send-MailMessage -SmtpServer $smtpserver -To $To -Cc $cc -from "NOCTasks@ipreo.com" -Subject "$env:COMPUTERNAME $Status" -BodyAsHtml -Body $MailBody