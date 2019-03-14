$confPath = "C:\Program Files\EXPRESSCLUSTER\etc\clp.conf"
$confXml = [xml](Get-Content $confPath)
$ownhostname = hostname

if($confXml.root.server[0].name -eq $ownhostname){
  $otherhostname = $confXml.root.server[1].name
}else{
  $otherhostname = $confXml.root.server[0].name
}

$result = clpstat
if($? -eq $false){
  Read-Host "Exit: Failed to get cluster status. Check if cluster is started or not on this server."
  exit
}

Read-Host "Start Secondary Server cluster service [Enter]"
clpcl -s -h $otherhostname
If($? -eq $false){
  Read-Host "Exit: Failed to start cluster service on Secondary Server. Check if the server is started or not."
  exit
}

Read-Host "Re-add md and regsync resources to cluster configuration [Enter]"
Copy-Item $confPath".bak" $confPath

Read-Host "Apply the configuration to cluster [Enter]"
clpcfctrl --push
clpcl --suspend
clpcl --resume

Read-Host "Start failover group on this server [Enter]"
clpgrp -s
If($? -eq $false){
  Read-Host "Exit: Failed to start failovergroup."
  exit
}

while($true){
  Read-Host "Now Mirroring. Wait for Mirroring is completed [Enter]"
  $mdwStatus = clpstat | Select-String "mdw" | ForEach-Object { $($_ -split":")[1] }
  if($mdwStatus.Trim() -eq "Normal"){
    break
  }
  Start-Sleep -s 1
}

Remove-Item $confPath $confPath".bak"

Read-Host "Finish [Enter]"
