$date = (Get-date).Minute
$time = New-TimeSpan $($date) $(Get-Date -Minute 15)