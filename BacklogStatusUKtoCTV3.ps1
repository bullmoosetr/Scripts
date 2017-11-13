try {

    function  GetContent {
        [CmdletBinding()]
        [OutputType([System.Management.Automation.PSCustomObject])]
        # Parameter help description
        param
        (
            [Parameter(Mandatory)]
            [string]$ContentPath

        )   
        [pscustomobject]@{'ContentPath' = $ContentPath}
  
             
    }
    function GetLastLine {
        [CmdletBinding()]

        param(
            [Parameter(Mandatory, ValueFromPipeline)]
            [pscustomobject]$TextInputObject

        )
        process {
            Get-Content $TextInputObject.ContentPath | select -Last 1


         
        }
    }
    function CheckTimeStamp {
        param
        (
            [Parameter(Mandatory, ValueFromPipeline)]
            [pscustomobject]$TextInput
        )
        process { 
            try { 
                if (($TextInput.SubString(0, 4)).Trim() -eq "0:OK") {
                    $time1 = $TextInput.Substring(15, 9)
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
                        Write-Host "0:The backlog check data is stale, last checked at" $TextInput.SubString(15, 9)  "please check the scheduled task"
                        exit 0
                    }
                    else {
                        Write-Host "0:OK"
                        exit 0
                    }
                }
                else {
                    $time1 = $TextInput.Substring(99, 8)
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
                        Write-Host "0:The backlog check data is stale, last checked at"  $TextInput.SubString(99, 8)  "please check the scheduled task"
                        exit 0
                    }
                    else {
                        $Text = $TextInput.Substring(0, 107)
                        $LogCount = $TextInput.Substring(86, 1)
                        Write-Host "$LogCount : $Text"
                        exit 0
                    }
                }
            }
            catch {
                Write-Host $Error
                exit 4
            }
        }
    


    }
}
catch {
    Write-Host $Error
    exit 4
}

    
try {
    
    GetContent -ContentPath "\\uk.corp.local\STORAGE\PROJECTS\IT\GNOC\PRTG\BackLogDocs\BacklogCountUKtoCT.txt" | GetLastLine | CheckTimeStamp

}
catch {
    Write-Host $Error
    exit 4
}