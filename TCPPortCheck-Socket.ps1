$tcpCl = New-Object Sytem.Net.Sockets.tcpClient
# $tcpCl.connect("IP address", port)
$tcpCl.connect("192.168.0.100", 80)
# If TCP connection cannot be established, the "Connect" error is shown.
$tcpCl.connected
# True or False
$tcpCl.close()
