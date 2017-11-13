#Sites and Services Status Check
#Created By Eric Laff

#Creates the files and obtains the correct path
#[string]$path = "C:\Users\lafferic\Desktop\Test-Output-5.txt"
#[xml]$xmlFile = Get-Content $path

#$xmlNode = $xmlFile.configuration.FileTransferFeeds.FileTransferJob
#$xmlArray = @($xmlNode)
#$xmlArray |  Format-Table -Property name -AutoSize
#Checks the Enviorment You are in
if ($env:COMPUTERNAME -eq "20"){$env = "20"}elseif($env:COMPUTERNAME -eq "60"){$env = "60"}elseif($env:COMPUTERNAME -eq "70"){$env = "70"}elseif($env:COMPUTERNAME -eq "NJ2"){$env = "NJ2"}elseif($env:COMPUTERNAME -eq "SC8"){$env = "SC8"}
#XML Paths
$XMLpaths = @("C:\Users\lafferic\Desktop\testservicestatus.xml")
foreach($xml in $XMLpaths)
{
#Check for missing XML Files
$checkPath = Test-Path $xml
if ($checkPath -eq $false)
{
Write-Host  "Cannot find"  $xml -ForegroundColor DarkRed
}

}
foreach($xml in $XMLpaths)
{
[xml]$xmlFile = Get-Content $xml
$xmlNode = $xml.ServerClasses
$xmlArray = @($xmlNode)

}


#[xml]$path0 = Get-Content "\\DEBT1NJ2US06\Program Files\I-Deal\Phoenix\PhoenixFIConfigurations\PhoenixDebtNTServices.xml"
#[xml]$path1 = Get-Content "\\EQMTE1NJ2US01\Program Files\I-Deal\Phoenix\Configurations\Phoenix Equity System\PhoenixEquityNTServices.xml"
#[xml]$path2 = Get-Content "\\CASA1NJ2US12\Program Files\I-Deal\CASA\Configurations\Phoenix Casa System\Core\CasaNTServices.xml"
#[xml]$path3 = Get-Content "\\RETL1NJ2US01\Program Files\I-Deal\RetailConfigurations\RetailNTServices\PROD\Retail NT Services - PROD.xml"
#[xml]$path4 = Get-Content "\\REPT1NJ2US30\Program Files\I-Deal\Phoenix\Configurations\ReportingServers\ReportingServerNTServices.xml"
#[xml]$path5 = Get-Content "\\BFIIS1NJ2US06\Bigdough\Config\BillfoldNTServices.xml"
#[xml]$path6 = Get-Content "\\MSIIS1NJ2US01\Program Files\i-Deal\Phoenix\Configurations\Phoenix Equity System - MS\PhoenixEquityNTServices - MS.xml"
#[xml]$path7 = Get-Content "\\EQMWK1NJ2US01\Program Files\I-Deal\IssueNetHub Configuration\Configurations\IssueNetHub Configuration\IssueNetHubNTServices.xml"
#[xml]$path8 = Get-Content "D:\Scripts\PRODSQLServicesCheck.xml"











