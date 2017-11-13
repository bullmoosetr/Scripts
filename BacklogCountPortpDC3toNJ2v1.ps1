function BacklogCount {
    [CmdletBinding()]
    param
    ()
    try {
        

        Clear-Content S:\STORAGE\#GNOCDFSLog\BacklogCountNJ2toDC3.txt
        $Date = Get-Date
        Add-Content S:\STORAGE\#GNOCDFSLog\BacklogCountNJ2toDC3.txt "$Date" 
        $VerboseMessage = (Get-DfsrBacklog -GroupName "*" -SourceComputerName $env:COMPUTERNAME -DestinationComputerName "DFS1DC3US03" -Verbose 4>&1)
        $has_logs = $VerboseMessage -like "*The replicated folder has a backlog of files*" | Out-String
        $no_logs = $VerboseMessage -like "*No backlog for the replicated folder named*" | Out-String
        
        $has_logs.Split("`r").Trim()
        $no_logs.Split("`r").Trim()
        if ($VerboseMessage -like "*The replicated folder has a backlog of files*") {
            for ($i = 0; $i -le 5; $i++) {
                Get-DfsrBacklog -GroupName "*" -SourceComputerName $env:COMPUTERNAME -DestinationComputerName "DFS1DC3US03" -Verbose
            }
        }


        Add-Content S:\STORAGE\#GNOCDFSLog\BacklogCountNJ2toDC3.txt "$($no_logs.Trim())"

        Add-Content S:\STORAGE\#GNOCDFSLog\BacklogCountNJ2toDC3.txt "$($has_logs.Trim())"
         
        (gc S:\STORAGE\#GNOCDFSLog\BacklogCountNJ2toDC3.txt) | ? {$_.trim() -ne "" } | set-content S:\STORAGE\#GNOCDFSLog\BacklogCountNJ2toDC3.txt   
        
    }
    catch {
        #Write-Host $Error
        Add-Content S:\STORAGE\#GNOCDFSLog\ErrorsDC3toNJ2.txt "$Date ~ $Error"
    }
}
BacklogCount

function UploadBacklogFile  {
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
        $file = "BackLogTest.txt"
        $uri = New-Object System.Uri($ftp+$file)

        foreach($file in (dir $Dir "*.txt")){
                 $uri = New-Object System.Uri($ftp+$file.Name)
                 $webclient.UploadFile($uri,$file.FullName)
                    }
}