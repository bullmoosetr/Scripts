# Log Archiver
#Created by Eric Laff

##########################################################Email Settings##########################################################
##########################################################Determine SMTP Server##################################################
$ComName= gc env:computername
IF (($ComName -Like '**') -or ($ComName -Like '**'))
{
$smtpServer = ""
}

}
##########################################################Send To & Subject######################################################
$smtpFrom = ''
$smtpTo = ''
$smtpCC = ''
$messageSubject= $ComName + ' -  - Grooming Job (All Folders)'
$EStart="<font face='verdana' size='2'>"
$EEnd="</Font>"
##################################################################################################################################################################
##################################################################################################################################################################
#Zip String for email
$zip = ".zip"
#Index
$Checker = 0
#Yesterdays date
$YDate=(Get-Date).AddDays(-1).ToString('yyyyMMdd') #Yesterdays date
$Datestamp = (Get-Date).AddDays(-1).ToString('yyyyMMdd')
#Destination Directory
$destination = "D:\Temp\"
#Places files into an array
$directory = @("D:\Temp")
#Search Directory for the Filetypes
$source = @(Get-ChildItem "D:\Temp"  | Where-Object {$_.Fullname -match $YDate -and $_.Fullname -notmatch '.zip'}  | Where-Object {$_.Name -like "*log*"} | Copy-Item -Destination "D:\Temp\") 
#Temporary Destination Directy. This is were the files are zipped from after being copied from D:\Temp
$files = "" 

#Sleep before deleting
Start-Sleep -s 20 -Verbose

#Destination and naming scheme
$FileZip = $destination + $Datestamp + ".zip"
Add-Type -Assembly "System.IO.Compression.FileSystem"
#Zips Files moves them to Destination  ` 
[System.IO.Compression.ZipFile]::CreateFromDirectory($files, $FileZip) `

#Sleep before deleting
Start-Sleep -s 20

#Delete Temp Files from Temp Folder
Get-ChildItem "D:\Temp\" | Remove-Item -Recurse 

#Delete the files from previous day
$delete = Get-ChildItem "D:\Temp" | Where-Object {$_.Fullname -match $YDate -and $_.Fullname -notmatch '.zip'}  | Where-Object{$_.Name -like "*Bridge*" -or $_.Name -like "*Events*" -or $_.Name -like "*Integration*" -or $_.Name -like "*Phx*" -or $_.Name -like "*Order*" -or $_.Name -like "*Schedule*" -or $_.Name -like "*Retries*" -or $_.Name -like "*log*"}  |Remove-Item 


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
