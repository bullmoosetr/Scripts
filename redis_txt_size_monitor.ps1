
function CheckFolder  {
para(
    $threshhold
)
    $Dir = D:\Program Files

    $checkfolder = Get-ChildItem      

    $filesize = Get-ChildItem $filePath | Measure-Object -Property Length -Sum

    #Convert from Bytes into GBs
    $filesize = $filesize.sum / 1Gb
    if ($filesize -gt $threshhold)
    {

    } 

}