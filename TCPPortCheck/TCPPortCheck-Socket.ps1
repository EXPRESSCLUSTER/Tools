$targetIP = Read-Host "Input target server IP address"
$ErrorActionPreference = "silentlycontinue"
$ports=@(29001,29002,29003,29004,29005,29007)
$file = $targetIP + "-TcpPortCheck.txt"
for($i=0; $i -lt $ports.Length; $i++){
  try {
    $tcpCl = New-Object System.Net.Sockets.TcpClient
    $tcpCl.Connect($targetIP,$ports[$i])
  } catch {
    $error[0] | Out-String | Add-Content $file
    echo "* ${targetIP}:$($ports[${i}]) is NG!"
  } 

  $ret = $tcpCl.Connected
  if($ret -eq $true){
    echo "  ${targetIP}:$($ports[${i}]) is OK."
  }
  $tcpCl.Close()
}