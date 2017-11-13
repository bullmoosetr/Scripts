# $folder = $line -match '"([^"]*)"'
# $Count = $line -match "(\s\d+)\s*"
$OutputXml = $null
$totalCount = $null
$SourceFile = Get-Content '\\ideal.prod.local\STORAGE\#GNOCDFSLog\BacklogCountDC3toNJ2.txt' | select -Last 11
$TimeStamp = get-content '\\ideal.prod.local\STORAGE\#GNOCDFSLog\BacklogCountDC3toNJ2.txt' | select -Last 1  -skip 11

$time1 = $TimeStamp.Substring(11, 8)
$time2 = Get-Date -Format HH:mm:ss
$timeDiff = New-TimeSpan $time1 $time2
if ($timeDiff.Hours -lt 1) {
    $Hrs = ($timeDiff.Hours) + 0
    $Mins = ($timeDiff.Minutes) + 0
    $Secs = ($timeDiff.Seconds) + 0

} 
else {
    $Hrs = $TimeDiff.Hours
    $Mins = $TimeDiff.Minutes
    $Secs = $TimeDiff.Seconds       
}
$Difference = '{0:00}:{1:00}:{2:00}' -f $Hrs, $Mins, $Secs
if ($Difference -ge "01:00:00") {   
    $TimeCheck = "The backlog check data is stale, last checked at $($TimeStamp.SubString(0, 19).Trim())  please check the scheduled task"
    $TimeCheckValue = 1 
}
else {
    $TimeCheck = "The Backlog information is up to date."
    $TimeCheckValue = 0
    
}


$files = $SourceFile -match "(\d+)\s*"
foreach ($line in $SourceFile) {
    $Folders = [regex]::Matches($line, '"([^"]*)"').captures.groups[1].value
    if ($line -match "(\d+)\s*") {
        $Count = [regex]::Matches($line, "(\d+)\s*").captures.groups[1].value   
    }
    else {
        $Count = 0
    }
   
    $totalCount += $Count
      # Write-Host $Folders
    
    $OutputXml += "
     <result>
         <channel>$Folders</channel>
         <Value>$Count</Value>
     </result>"  
}
Write-Host "<prtg>$OutputXml<result><channel>BacklogCount</channel><value>$totalCount</value></result><result><channel>$TimeCheck</channel><value>$TimeCheckValue</value></result></prtg>"


function DownloadBacklogFile  {
    [CmdletBinding()]
    param
    ($Dir,
     $ftp,
     $user,
     $pass,
     $string) 

        # $Dir = "C:\Users\lafferic\Desktop\BacklogFile"
        #  #ftp server
        #  $ftp = "ftp://10.27.5.99/NOC/DFSBacklogCount/PortP/"
        #  $user = "anonymous"
        #  $pass = ""

        $webclient = New-Object System.Net.WebClient

        $webclient.Credentials = New-Object System.Net.NetworkCredential($user,$pass)
        $uri = New-Object System.Uri($ftp+$file)

        foreach($file in (dir $Dir "*.txt")){
                 $uri = New-Object System.Uri($ftp+$file.Name)
                 $webclient.UploadFile($uri,$file.FullName)
                    }
}