#Debt Log Archiver
#Created by Eric Laff

##########################################################Email Settings##########################################################
##########################################################Determine SMTP Server##################################################
$ComName= gc env:computername
IF (($ComName -Like '*CORP*') -or ($ComName -Like '*40NY1*'))
{
$smtpServer = "nycmail.ideal.corp.local"
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
$smtpTo = 'FIDev-.Net@i-deal.com'
$smtpCC = 'NOC@ipreo.com'
$messageSubject= $ComName + ' - IssueBook ASP IIS Logs - Grooming Job (All Folders)'
$EStart="<font face='verdana' size='2'>"
$EEnd="</Font>"
##################################################################################################################################################################
##################################################################################################################################################################
#Zip String for email
$zip = ".zip"
#Index
$Checker = 0
#Yesterdays date
$Datestamp = (Get-Date).AddDays(-1).ToString('yyyyMMdd')
#Destination Directory
$destination = "C:\Users\lafferic\Desktop\"
$directory = @("C:\Users\lafferic\Desktop")
#Search Directory for the Filetypes
$source = @(Get-ChildItem "C:\Users\lafferic\Desktop\TestDir" | where{((Get-Date)-$_.LastWriteTime).days -ge 5} |Where-Object{$_.Name -like "*General*" -or $_.Name -like "*Api*" -or $_.Name -like "*Incoming*" -or $_.Name -like "*Outgoing*"} | Copy-Item -Destination "C:\Users\lafferic\Desktop\TempTest")
#Temporary Destination Directy. This is were the files are zipped from after being copied from D:\Temp
$files = "C:\Users\lafferic\Desktop\TempTest"
#Destination and naming scheme
$FileZip = $destination + $Datestamp + ".zip"
Add-Type -Assembly "System.IO.Compression.FileSystem"
#Zips Files moves them to Destination  ` 
[System.IO.Compression.ZipFile]::CreateFromDirectory($files, $FileZip) `

#Sleep before deleting
Start-Sleep -s 10

#Delete Temp Files from Temp Folder
Get-ChildItem "C:\Users\lafferic\Desktop\TempTest" | Remove-Item -Recurse 

#Delete the files from previous day
$delete = Get-ChildItem "C:\Users\lafferic\Desktop\TestDir" | where{((Get-Date)-$_.LastWriteTime).days -ge 1} | Where-Object{$_.Name -like "*General*" -or $_.Name -like "*Api*" -or $_.Name -like "*Incoming*" -or $_.Name -like "*Outgoing*"} |Remove-Item 


#Looks for the Zipfiles if Zips exist Sends a Success email
foreach ($file in $directory)
{
$file = $file.name
$dir = $directory
$zipFile = $Datestamp + ".zip"
If (Test-Path $dir\$zipFile)
{
$Checker++
}
}
If ($Checker -gt '0')
{
    $Body= "Previous day's logfiles in D:\Temp\$Datestamp" + $zip
}
ELSE
{
    $Body= "Files prior to yesterday should have been zipped and deleted-- Please double check all folders in D:\Temp\$Datestamp" + $zip
}

$Ebody= $EStart + $Body + $EEnd

send-mailmessage -from "$smtpFrom" -to "$smtpTo" -cc $smtpCC -subject "$messageSubject" -body "$EBody" -BodyAsHtml -smtpServer "$smtpserver"
