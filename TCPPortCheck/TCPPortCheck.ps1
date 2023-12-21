$ip1 = "<Primary server IP address>"
$ip2 = "<Secondary server IP address>"

date /t | Select-String $d
time /t | Select-String $t
echo "$d $t"

hostname | Select-String $name
echo "My hostname is $name"

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
Test-NetConnection -ComputerName $targetip -Port 29002
Test-NetConnection -ComputerName $targetip -Port 29003
Test-NetConnection -ComputerName $targetip -Port 29004
Test-NetConnection -ComputerName $targetip -Port 29005
echo "If you use ECX 4.0 or earlier, please ignore the following results because it does not use the following ports."
Test-NetConnection -ComputerName $targetip -Port 29008
Test-NetConnection -ComputerName $targetip -Port 29009
Test-NetConnection -ComputerName $targetip -Port 29010
Read-Host "Press Enter to close this window..."
