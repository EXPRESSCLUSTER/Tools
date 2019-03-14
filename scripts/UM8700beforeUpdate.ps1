$confPath = "C:\Program Files\EXPRESSCLUSTER\etc\clp.conf"
$confXml = [xml](Get-Content $confPath)
$ownhostname = hostname

Copy-Item $confPath $confPath".bak"

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

$activeServer = $result | Select-String "current" | ForEach-Object { $($_ -split":")[1] }
if($activeServer.Trim() -eq $otherhostname){
  Read-Host "Exit: This server is Standby Server. Execute this script on Active Server."
  exit
}

$mdwStatus = $result | Select-String "mdw" | ForEach-Object { $($_ -split":")[1] }
if($mdwStatus.Trim() -ne "Normal"){
  Read-Host "Exit: Mirror Disk Data is not synchronized. Check md status."
  exit
}

$otherStatus = $result | Select-String $otherhostname | ForEach-Object { $($_ -split":")[1] }
if($otherStatus.Trim() -ne "Online"){
  Read-Host "Exit: Cluster service is not started on Standby server. Start it."
  exit
}

Read-Host "Stop failover group [Enter]"
clpgrp -t

Read-Host "Remove md and regsync resources from cluster configuraiton [Enter]"
$node = $confXml.root.monitor.types | Where{$_.name -eq "mdw"}
$confXml.root.monitor.RemoveChild($node)
if($? -eq $false){
  Read-Host "Exit: Failed to remove mdw. Check configuration is changed or not."
  exit
}
$node = $confXml.root.monitor.mdw
$confXml.root.monitor.RemoveChild($node)
if($? -eq $false){
  Read-Host "Exit: Failed to remove mdw. Check configuration is changed or not."
  exit
}

$node = $confXml.root.monitor.types | Where{$_.name -eq "mdnw"}
$confXml.root.monitor.RemoveChild($node)
if($? -eq $false){
  Read-Host "Exit: Failed to remove mdnw. Check configuration is changed or not."
  exit
}
$node = $confXml.root.monitor.mdnw
$confXml.root.monitor.RemoveChild($node)
if($? -eq $false){
  Read-Host "Exit: Failed to remove mdnw. Check configuration is changed or not."
  exit
}

$node = $confXml.root.monitor.types | Where{$_.name -eq "regsyncw"}
$confXml.root.monitor.RemoveChild($node)
if($? -eq $false){
  Read-Host "Exit: Failed to remove regsyncw. Check configuration is changed or not."
  exit
}
$node = $confXml.root.monitor.regsyncw
$confXml.root.monitor.RemoveChild($node)
if($? -eq $false){
  Read-Host "Exit: Failed to remove regsyncw. Check configuration is changed or not."
  exit
}

$node = $confXml.root.resource.types | Where{$_.name -eq "md"}
$confXml.root.resource.RemoveChild($node)
if($? -eq $false){
  Read-Host "Exit: Failed to remove md. Check configuration is changed or not."
  exit
}
$node = $confXml.root.resource.md
$confXml.root.resource.RemoveChild($node)
if($? -eq $false){
  Read-Host "Exit: Failed to remove md. Check configuration is changed or not."
  exit
}

$node = $confXml.root.resource.types | Where{$_.name -eq "regsync"}
$confXml.root.resource.RemoveChild($node)
if($? -eq $false){
  Read-Host "Exit: Failed to remove regsync. Check configuration is changed or not."
  exit
}
$node = $confXml.root.resource.regsync
$confXml.root.resource.RemoveChild($node)
if($? -eq $false){
  Read-Host "Exit: Failed to remove regsync. Check configuration is changed or not."
  exit
}

$node = $confXml.root.group.resource | Where{$_.name -eq "md@md"}
$confXml.root.group.RemoveChild($node)
if($? -eq $false){
  Read-Host "Exit: Failed to remove md@md. Check configuration is changed or not."
  exit
}

$node = $confXml.root.group.resource | Where{$_.name -eq "regsync@regsync"}
$confXml.root.group.RemoveChild($node)
if($? -eq $false){
  Read-Host "Exit: Failed to remove regsync@regsync. Check configuration is changed or not."
  exit
}

$confXml.root.group.start = "0"

$confXml.Save($confPath)

Read-Host "Apply the new configuration to the cluster [Enter]"

clpcfctrl --push
clpcl --suspend
clpcl --resume

Read-Host "Stop Secondary Server cluster service disable failover while updating [Enter]"
clpcl -t -h $otherhostname

Read-Host "Finish. Pleae update UM8700 [enter]"
