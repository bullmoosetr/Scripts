##################################################################################################################################################################
$ComName = gc env:computername
IF (($ComName -Like '**') -or ($ComName -Like '**')) {
    $smtpServer = "Email Server"
}
}
##################################################################################################################################################################
$smtpFrom = 'Email'
$smtpTo = 'Email'
$smtpCC = 'Email'
$messageSubject = $ComName + ' - Logs - Grooming Job (All Folders)'
$EStart = "<font face='verdana' size='2'>"
$EEnd = "</Font>"
##################################################################################################################################################################
$Date = 
$DirFiles = Get-ChildItem  -Path C:\Users\lafferic\Desktop -Recurse | where {$_.LastWriteTime -gt (Get-Date).AddDays(-4)} |  Remove-Item 
    
