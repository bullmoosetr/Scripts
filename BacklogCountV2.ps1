

function BacklogCount {
    [CmdletBinding()]
    param
    ()
    try {
        $VerbosePreference = 'Continue'
        for ($i = 0; $i -le 5; $i++) {

            $computers = @("STOR45CT1ZA01")
            foreach ($computer in $computers) {$VerboseMessage = (Get-DfsrBacklog -GroupName "*" -SourceComputerName $env:COMPUTERNAME -DestinationComputerName $computer -Verbose 4>&1)   } 
            $outputString = $VerboseMessage | Out-String 


            $Date = Get-Date
            if ($VerboseMessage -like "*The replicated folder has a backlog of files*") {
    
                $Status = $outputString.Substring(0, 85)
                $LogCount = $outputString.Substring(86, 1)
                Add-Content C:\Users\lafferic\Desktop\BackLogTest.txt  "$LogCount : $Status $Date"
   
            }
            elseif ($VerboseMessage -like "*No backlog for the replicated folder named*") {
    
                Add-Content C:\Users\lafferic\Desktop\BackLogTest.txt "0:OK $Date" 
                break
            }
        }
    }
    catch {
        #Write-Host $Error
    
        Add-Content \\uk.corp.local\STORAGE\PROJECTS\IT\GNOC\PRTG\BackLogDocs\BacklogCountError.txt "$Date" "$Error"

    }
}
BacklogCount
