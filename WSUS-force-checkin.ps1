# If you want to run centrally from your WSUS server, I found that you can't use PowerShell remoting because of a permissions issue.  
# There probibly is a way around that, but for now psexec works fine. 
##### Ask for computer name
$Computer = Read-Host ("Enter Hostname")
#### start
clear
Write-host "Just in case, starting window upadte automatic update service." -ForegroundColor green
psexec.exe -s \\$Computer powershell.exe -command {Start-Service wuauserv}
Start-sleep -seconds 2
   # Have to use psexec with the -s parameter as otherwise we receive an "Access denied" message loading the comobject
$Cmd = '$updateSession = new-object -com "Microsoft.Update.Session";$updates=$updateSession.CreateupdateSearcher().Search($criteria).Updates'
clear
    Write-host "Clearing the client's reporting schedule." -ForegroundColor green
    psexec.exe -s \\$Computer powershell.exe -command $Cmd
    Start-sleep -seconds 2
clear
   Write-host "Waiting 10 seconds for SyncUpdates webservice to complete." -ForegroundColor green
   Start-sleep -seconds 10
clear 
 Write-host "Forcing $Computer to report in now." -ForegroundColor green
psexec.exe -s \\$Computer powershell.exe -command {wuauclt /reportnow}
clear 
Write-host "Tasks are Complete! Please check WSUS for $Computer status." -ForegroundColor green
Write-host ""
Pause

 # Noet: Differnate commands to actually trigger the report in operation
     # wuauclt /detectnow
     # (New-Object -ComObject Microsoft.Update.AutoUpdate).DetectNow()
     # wuauclt /reportnow
     # c:\windows\system32\UsoClient.exe startscan
     # Usoclient startinteractivescan (this will start the download and install process if updates are detected)
