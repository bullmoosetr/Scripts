param(
    $ContentPath
)
try {

    function  GetContent {
        [CmdletBinding()]
        [OutputType([System.Management.Automation.PSCustomObject])]
        # Made this mandatory so there will always be a file passing the data
        param
        (
            [Parameter(Mandatory)]
            [string]$ContentPath

        )   
        [pscustomobject]@{'ContentPath' = $ContentPath}
  
             
    }
    function GetLastLine 
    {
        [CmdletBinding()]

        param(
            [Parameter(Mandatory, ValueFromPipeline)]
            [pscustomobject]$TextInputObject

        )
        process {
     
            $selectLines = Get-Content $TextInputObject.ContentPath |  select -Last 11 
            while ($null -ne ($Line = $selectLines.ReadLine())) {
                $FirstQuoteIndex = $Line.IndexOf('"') + 1 #remove ' itself by adding 1 to index
                $LastQuoteIndex = $Line.LastIndexOf('"')
                $SubStringLength = $LastQuoteIndex - $FirstQuoteIndex 
                if ($Line -match "(\s\d+)\s*") { $Count = [int]$Matches[1].Trim() } else { $Count = 0 } #match for decimals  
                if ($FirstQuoteIndex -and $LastQuoteIndex -and $SubStringLength -gt 0) {       
                    $FolderInfo = [PSCustomObject]@{
                        Value = $Count
                        Name  = $Line.Substring($FirstQuoteIndex, $SubStringLength)            
                    }          
                }
                else {
                    $FolderInfo = [PSCustomObject]@{
                        Value = $Count
                        Name  = $Line #just print what line is not able to parse as name
                    }
                }
                $Folders += $FolderInfo #add in each folder object into array  
            }  
        $Total = 0#keep a count of all backlogs
        #build the prtg return xml FYI it can be one line, this just looks nicer
    
        foreach ($Folder in $Folders) { 
            #log to file check was done during DFS task on dfs box fyi, this is just when script parsed
            write-host "$((Get-Date).ToString("MMddyyyy hh:mm:ss.fff")) $($Folder.Name)  Count: $($Folder.Value)" -Path $LogFilePath    
            $Total += $Folder.Value
            $Output += "
    <result>
    <channel>$($Folder.Name)</channel>
    <value>$($Folder.Value)</value>
    </result>" 
        }
        Write-Output "
<prtg>$($Output)
    <result>
    <channel>Backlogs</channel>
    <value>$($Total)</value>
    </result>
      <result>
    <channel>LastUpdateOnFile</channel>
    <CustomUnit>Minutes</CustomUnit>    
    <value>$($LastMod.Minutes)</value>
    </result>
</prtg>"



        $selectLines.Split("`n")
        $arr = @($selectLines.Split("`n"))

        foreach ($line in $arr) {
        
            if (($line.SubString(0, 3)) -like "The") {
                $time1 = $line.Substring(94, 8)
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
                    Write-Host "The backlog check data is stale, last checked at"  $line.SubString(16, 8)  "please check the scheduled task"
                    exit 0
                }
                else {
                    $Text = $line.Substring(0, 102)
                    $LogCount = $line.Substring(84, 1)
                    Write-Host "$LogCount : $Text"
                    exit 0
                    

                }

            }

   
             
        }
    }        
     
}  

}
catch {
    Write-Host $Error
    exit 4
}

GetContent -ContentPath C:\Users\lafferic\Desktop\BackLogTest.txt | GetLastLine 
