function BacklogCount {
    [CmdletBinding()]
    param
    ()
    try {
        $VerbosePreference = 'Continue'
        for ($i = 0; $i -le 5; $i++) {
            Start-Sleep -Seconds 5
             $VerboseMessage = (Get-DfsrBacklog -GroupName "*" -SourceComputerName $env:COMPUTERNAME -DestinationComputerName "DFS1NJ2US03" -Verbose 4>&1)  
            $outputString = $VerboseMessage | Out-String 

            

            $Date = Get-Date
            if ($VerboseMessage -like "*The replicated folder has a backlog of files*") {
    
                $Status = $outputString.Substring(0, 85)
                $LogCount = $outputString.Substring(86, 1)
                Add-Content \\ideal.prod.local\STORAGE\~NOC\DFSBacklogCheckLog\BacklogCountDC3.txt  "$LogCount : $Status $Date"
   
            }
            elseif ($VerboseMessage -like "*No backlog for the replicated folder named*") {
    
                Add-Content \\ideal.prod.local\STORAGE\~NOC\DFSBacklogCheckLog\BacklogCountDC3.txt "0:OK $Date" 
                break
            }
        }
    }
    catch {
        #Write-Host $Error
    
        Add-Content \\ideal.prod.local\STORAGE\~NOC\DFSBacklogCheckLog\ErrorsDC3toNJ2 "$Date" "$Error"

    }
}
BacklogCount
