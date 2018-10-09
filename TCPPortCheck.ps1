$ip1="<Primary Server IP Address>"
$ip2="<Secondary Server IP Address>"

$ret = ipconfig | Select-String $ip1
if ( $ret -eq "" )
{
  $targetip=$ip1
  echo "My IP is $ip2"
}
else{
  $targetip=$ip2
  echo "My IP is $ip1"
}

echo "Other IP is $targetip"

Test-NetConnection -ComputerName $targetip -Port 29001
if ( $? -eq $true ){
  echo "Port 29001(TCP): Opend"
}
else{
  echo "Port 29001(TCP): Closed. Please open this port!"
}  

Test-NetConnection -ComputerName $targetip -Port 29002
if ( $? -eq $true ){
  echo "Port 29002(TCP): Opend."
}
else{
  echo "Port 29002(TCP): Closed. Please open this port!"
}  

Test-NetConnection -ComputerName $targetip -Port 29003
if ( $? -eq $true ){
  echo "Port 29003(TCP): Opend."
}
else{
  echo "Port 29003(TCP): Closed. Please open this port!"
}  

Test-NetConnection -ComputerName $targetip -Port 29004
if ( $? -eq $true ){
  echo "Port 29004(TCP): Opend."
}
else{
  echo "Port 29004(TCP): Closed. Please open this port!"
}  

Test-NetConnection -ComputerName $targetip -Port 29005
if ( $? -eq $true ){
  echo "Port 29005(TCP): Opend."
}
else{
  echo "Port 29005(TCP): Closed. Please open this port!"
}  

Test-NetConnection -ComputerName $targetip -Port 29007
if ( $? -eq $true ){
  echo "Port 29007(TCP): Opend."
}
else{
  echo "Port 29007(TCP): Closed. Please open this port!"
}

Read-Host "Press Enter to close this window..."
