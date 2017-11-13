function BacklogCount {
    [CmdletBinding()]
    param
    ()
    try {
        $VerbosePreference = 'Continue'
        $Date = Get-Date
        Add-Content \\ideal.prod.local\STORAGE\~NOC\DFSBacklogCheckLog\BacklogCountDC3toNJ2.txt "$Date" 
        $VerboseMessage = (Get-DfsrBacklog -GroupName "*" -SourceComputerName $env:COMPUTERNAME -DestinationComputerName "DFS1NJ2US03" -Verbose 4>&1)
        if($VerboseMessage -like "*The replicated folder has a backlog of files*")
        {
            for ($i = 0; $i -lt 5; $i++) {
               $VerboseMessage = (Get-DfsrBacklog -GroupName "*" -SourceComputerName $env:COMPUTERNAME -DestinationComputerName "DFS1NJ2US03" -Verbose 4>&1) 
            }
        $outputString = $VerboseMessage | Out-String
        $arr = @($outputString)
        foreach ($line in $arr) {
            if ($line -like "*The replicated folder has a backlog of files*" -or "*No backlog for the replicated folder named*" -and -not $null) {
                Add-Content \\ideal.prod.local\STORAGE\~NOC\DFSBacklogCheckLog\BacklogCountDC3toNJ2.txt "$($line.Trim())"    
            }   
        }         
        }
        else{
        $outputString = $VerboseMessage | Out-String
        $arr = @($outputString)
        foreach ($line in $arr) {
            if ($line -like "*The replicated folder has a backlog of files*" -or "*No backlog for the replicated folder named*" -and -not $null) {
                Add-Content \\ideal.prod.local\STORAGE\~NOC\DFSBacklogCheckLog\BacklogCountDC3toNJ2.txt "$($line.Trim())"    
            }   
        }         
        }
                         
    }
    catch {
        #Write-Host $Error
        Add-Content \\ideal.prod.local\STORAGE\~NOC\DFSBacklogCheckLog\ErrorsDC3toNJ2.txt "$Date ~ $Error"
    }
}
BacklogCount