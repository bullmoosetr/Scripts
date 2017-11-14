



function sortFile ($source)
{

$path = Get-ChildItem $source #| Where-Object {$_.Extension -notmatch ".zip"}
 
foreach ($file in $path)
{
$zip = [datetime](Get-ItemProperty -Path $file -name LastWriteTime).LastWriteTime
if ($file | Where-Object{$_.extension -notmatch ".zip"})
{  
$files = [datetime](Get-ItemProperty -Path $file -name LastWriteTime).LastWriteTime 
}
$files | Where-Object {$_.DateTime -match $zip} | Copy-Item -Destination $zip -Verbose

}

}


sortFile("C:\*") -verbose
