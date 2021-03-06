function BacklogCount {
    [CmdletBinding()]
    param
    ()
    try {
        $VerbosePreference = 'Continue'
        for ($i = 0; $i -le 5; $i++) {
            Start-Sleep -Seconds 5
             $VerboseMessage = (Get-DfsrBacklog -GroupName "*" -SourceComputerName $env:COMPUTERNAME -DestinationComputerName "" -Verbose 4>&1)  
            $outputString = $VerboseMessage | Out-String 

            

            $Date = Get-Date
            if ($VerboseMessage -like "*The replicated folder has a backlog of files*") {
    
                $Status = $outputString.Substring(0, 85)
                $LogCount = $outputString.Substring(86, 1)
                Add-Content   "$LogCount : $Status $Date"
   
            }
            elseif ($VerboseMessage -like "*No backlog for the replicated folder named*") {
    
                Add-Content  "0:OK $Date" 
                break
            }
        }
    }
    catch {
        #Write-Host $Error
    
        Add-Content  "$Date" "$Error"

    }
}
BacklogCount
