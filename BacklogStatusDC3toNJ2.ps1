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
    function GetLastLine {
        [CmdletBinding()]

        param(
            [Parameter(Mandatory, ValueFromPipeline)]
            [pscustomobject]$TextInputObject

        )
        process {
     
            $selectLines = Get-Content $TextInputObject.ContentPath |  select -Last 12 
            $selectLines.Split("`n")
            $arr = @($selectLines.Split("`n"))
            foreach ($line in $arr) {
                if (($line.SubString(0, 3)).Trim() -like "0:OK") {
                    $time1 = $line.Substring(15, 9)
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
                        Write-Host "The backlog check data is stale, last checked at" $line.SubString(15, 9)  "please check the scheduled task"
                        exit 0
                    }
                    else {
                        Write-Host "0:OK"
                        exit 0
                    }
                }
                else {
                    $time1 = $line.Substring(16, 8)
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
                        $Text = $line.Substring(0, 105)
                        $LogCount = $line.Substring(84, 1)
                        Write-Host "$LogCount : $Text"
                        exit 0
                    }
                }
             
            }
             
        }  
    }
    function CheckTimeStamp {
        param
        (
            [Parameter(ValueFromPipeline)]
            [pscustomobject]$TextInput
        )
        process { 
            try {
                $arr = @($TextInput.Split("`n"))
                foreach ($line in $arr) {
                    if (($line.SubString(0, 2)).Trim() -eq "No") {
                        $time1 = $line.Substring(15, 9)
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
                            Write-Host "The backlog check data is stale, last checked at" $line.SubString(15, 9)  "please check the scheduled task"
                            exit 0
                        }
                        else {
                            Write-Host "0:OK"
                            exit 0
                        }
                    }
                    else {
                        $time1 = $line.Substring(96, 9)
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
                            Write-Host "The backlog check data is stale, last checked at"  $line.SubString(96, 9)  "please check the scheduled task"
                            exit 0
                        }
                        else {
                            $Text = $line.Substring(0, 105)
                            $LogCount = $line.Substring(84, 1)
                            Write-Host "$LogCount : $Text"
                            exit 0
                        }
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

GetContent -ContentPath C:\Users\lafferic\Desktop\BackLogTest.txt| GetLastLine 
