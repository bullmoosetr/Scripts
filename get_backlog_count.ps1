        #Backlog Count Script
        #Created By Eric Laff

        #Description: This script was created with the intention of gathing the current backlog number between StorCT and STORCHUK
        #The sctipt add the backlog count and details to a .txt on S:\STORAGE\PROJECTS\IT\GNOC\PRTG\BackLogDocs\BacklogCountCTtoCHUK.txt
        #Further details about the process can be found on the wiki page for PRTG

        try
        {
        #Clears the content log.txt file on the S: to avoid cached data
        Clear-Content S:\STORAGE\PROJECTS\IT\GNOC\PRTG\BackLogDocs\BacklogCountCTtoCHUK.txt
        #Set the $Content variable to Null to avoid any kind of cached data
        $Content = $null 
        $Date = Get-Date
        #Adds current date/time to the log
        Add-Content S:\STORAGE\PROJECTS\IT\GNOC\PRTG\BackLogDocs\BacklogCountCTtoCHUK.txt "$Date"
        #Runs the Get-DfsrBacklog which gets the backlog cound between the two DFS servers and reroutes the verbose output into the variable
        $Content = Get-DfsrBacklog -GroupName "*" -SourceComputerName $env:COMPUTERNAME -DestinationComputerName "STOR45CHUK01" -Verbose 4>&1
        #the if statement below is to determine if the backlog count is a false and not returning incorrect counts
        if ($Content -like "*The replicated folder has a backlog of files*"){
            for ($i = 0;$i -le 5;$i++)
                {
                    Get-DfsrBacklog -GroupName "*" -SourceComputerName $env:COMPUTERNAME -DestinationComputerName "STOR45CHUK01" -Verbose
                }
        }
        #Adds the count ti the log file on the S:
        Add-Content S:\STORAGE\PROJECTS\IT\GNOC\PRTG\BackLogDocs\BacklogCountCTtoCHUK.txt "$Content"
        #removes all white and black spaces from the log file to avoid any errors in the reader script
        (gc S:\STORAGE\PROJECTS\IT\GNOC\PRTG\BackLogDocs\BacklogCountCTtoCHUK.txt) | ? {$_.trim() -ne "" } | set-content S:\STORAGE\PROJECTS\IT\GNOC\PRTG\BackLogDocs\BacklogCountCTtoCHUK.txt
        }
        catch {
        #Write-Host $Error
        Add-Content S:\STORAGE\PROJECTS\IT\GNOC\PRTG\BackLogDocs\BacklogCountCTtoCHUKErrors.txt "$Date ~ $Error"
    }