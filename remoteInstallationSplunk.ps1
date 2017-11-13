#-----------------------------#
#--- Remote Install Script ---# 
#-----------------------------#

#--- List of servers to install Forwarder On ---#
$list = Get-Content -Path "D:\Temp\servers.txt" 

#--- Downloads latest Universal Forwadering from FTP ---# 
$ftpFile = "ftp://10.27.5.99/NOC/Splunk/UniForwarding.msi" 
$ftpClient = New-Object system.Net.WebClient
$localPath = "D:\Temp\UniForwarding.msi" 
$uri = New-Object System.Uri($ftpFile)
$ftpClient.DownloadFile($uri,$localPath)

#--- Creating local file to verify installations ---# 
$domain = $env:USERDOMAIN
$localComputerInstallFile = ("\\$env:COMPUTERNAME\rm\SplunkInstallationLog.csv")
if(!(Test-Path $localComputerInstallFile))
{
    $header = "Domain,Server,Installed (Y/N), TimeStamp, Notes" | Add-Content ("\\$env:COMPUTERNAME\rm\SplunkInstallationLog.csv")

}

#--- Loop through each server/Installing Forwardering ---# 
$i=0 
foreach($server in $list)
{ 
   Write-Progress -Activity "Installation In Progress..." "% Completed: " -perc ($i/$list.Count*100)  
   $destPath = ("\\$server\rm")
    
    if(Test-Path $destPath)
    {    
        Copy-Item $localPath -Destination $destPath 
        $args = { & cmd /c "msiexec.exe /i D:\rm\UniForwarding.msi" /qn AGREETOLICENSE=Yes DEPLOYMENT_SERVER=10.27.5.122:8089 RECEIVING_INDEXER=10.27.5.120:9997 /log D:\rm\MSI_Install.log /quiet}
        $PSSession = New-PSSession -ComputerName $server 
        Invoke-Command -Session $PSSession -ScriptBlock $args
        $timeStamp = Get-Date -Format ("MM/dd/yyyy hh:mm:ss") 
        $log = Get-Content -Path ($destPath + "\MSI_Install.log")
        $check = $log[$logCheck.Count - 5]
        if($check.EndsWith("Installation completed successfully."))
        {
          $line = ($domain + "," +  $server + ",Yes," + $timeStamp + ",Installed Successfully") | Add-Content -Path $localComputerInstallFile
        }
        else
        {
          $line = ($domain + "," + $server + ",No," + $timeStamp + ",Failed Installation") | Add-Content -Path $localComputerInstallFile 
        }
    }
    else
    {
        $line = ($domain + "," + $server + ",No," + $timeStamp + ",RM Shared Folder Doesn't Exist on Server") | Add-Content -Path $localComputerInstallFile
    }
$i++ 
}


