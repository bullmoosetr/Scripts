##################################################################################################################################################################
$ComName = gc env:computername
IF (($ComName -Like '*CORP*') -or ($ComName -Like '*40NY1*')) {
    $smtpServer = "nycmail.ideal.corp.local"
}
IF ($ComName -Like '*20NY1*' -OR $ComName -Like '*30NY1*' -OR $ComName -Like '*60NY1*' -OR $ComName -Like '*70NY1*' -OR $ComName -Like '*30NY1*' -OR $ComName -Like '*1NJ2*') {
    $smtpServer = "smtp-pmta"
}
IF ($ComName -Like '*1DC3*' ) {
    $smtpServer = "smtp-dc3"
}
##################################################################################################################################################################
$smtpFrom = 'NOCTasks@i-Deal.com'
$smtpTo = 'FIDev-.Net@i-deal.com'
$smtpCC = 'NOC@ipreo.com'
$messageSubject = $ComName + ' - IssueBook ASP IIS Logs - Grooming Job (All Folders)'
$EStart = "<font face='verdana' size='2'>"
$EEnd = "</Font>"
##################################################################################################################################################################
$Date = 
$DirFiles = Get-ChildItem  -Path C:\Users\lafferic\Desktop -Recurse | where {$_.LastWriteTime -gt (Get-Date).AddDays(-4)} |  Remove-Item 
    
