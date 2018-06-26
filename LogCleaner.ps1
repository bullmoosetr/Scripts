
$logs = Get-ChildItem -Path 
$log = Get-ChildItem -Path  -recurse | where {((Get-Date)-$_.LastWriteTime).days -ge 30}
for($i=0;$i -lt $logs.Count;$i++ ){
$logs[$i]
$log | Remove-Item -Recurse -Force}

$Error.Clear()
$Status = "  Logs - OK"
 
 $smtpserver = "smtp-pmta"
 
 $To = ""

 if ($Error.Count -gt 0){
 $Status = " Tomcat log grooming -NOT OK"
        $MailBody =  "Please investigate, removal of these files were not successful: <br>" + $OldTomCatHTMLFormat + "<br>" + (Get-Date).ToString() + $Error[0].toString()
        Clear($Error)
 }else{
     $MailBody = $MailBody +  "No old logs found " + (Get-Date).ToString()
 }


 Send-MailMessage -SmtpServer $smtpserver -To $To -Cc $cc -from "" -Subject "$env:COMPUTERNAME $Status" -BodyAsHtml -Body $MailBody
