# How to use TCPPortCheck
## Overview

TCPPortCheck.ps1 and TCPPortCheck-Socket.ps1 check if TCP ports 29001, 29002, 29003, 29004, 29005, 29007 open.
These ports are used for EXPRESSCLUSTER.

- If you use this script on Windows Server 2012 R2 or earlier, please use **TCPPortCheck-Socket.ps1**

- If you use this script on Windows Server 2016 or later, please use **TCPPortCheck.ps1**

## How to use TCPPortCheck-Socket.ps1
1. Copy **TCPPortCheck-Socket.ps1** to the server where you want to execute this script.

    https://github.com/EXPRESSCLUSTER/Tools/blob/master/TCPPortCheck/TCPPortCheck-Socket.ps1

2. Execute **TCPPortCheck-Socket.ps1** on Powershell

    .\TCPPortCheck-Socket.ps1

    e.g.
    ```
    > .\TCPPortCheck-Socket.ps1
    Input target server IP address: 192.168.145.1
    * 192.168.145.1:29001 is NG!
      192.168.145.1:29002 is OK.
      192.168.145.1:29003 is OK.
      192.168.145.1:29004 is OK.
    * 192.168.145.1:29005 is NG!
      192.168.145.1:29007 is OK.
    ```

3. If TCP connection cannot be established, error logs will be outputed in the same folder with this script.

    \<Target IP address\>-TcpPortCheck.txt

    Error sample:
    
    - The port is not listening

      ```
      Exception calling "Connect" with "2" argument(s): "No connection could be made because the target machine actively refused it 192.168.145.1:29005"
      At E:\github\Tools\TCPPortCheck-Socket.ps1:8 char:5
      +     $tcpCl.Connect($targetIP,$ports[$i])
      +     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      + CategoryInfo          : NotSpecified: (:) [], MethodInvocationException
      + FullyQualifiedErrorId : SocketException
      ```
    - The port is blocked by Firewall

      ```
      Exception calling "Connect" with "2" argument(s): "A connection attempt failed because the connected party did not properly respond after a period of time, or established connection failed because connected host has failed to respond 192.168.145.1:29001"
      At E:\github\Tools\TCPPortCheck-Socket.ps1:8 char:5
      +     $tcpCl.Connect($targetIP,$ports[$i])
      +     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      + CategoryInfo          : NotSpecified: (:) [], MethodInvocationException
      + FullyQualifiedErrorId : SocketException
      ```


## How to use TCPPortCheck.ps1
1. Copy **TCPPortCheck-Socket.ps1** to the server where you want to execute this script.

    https://github.com/EXPRESSCLUSTER/Tools/blob/master/TCPPortCheck/TCPPortCheck.ps1
    
2. Edit **TCPPortCheck-Socket.ps1**
    - Input Primary and Secondary server IP addresses to $ip1 and $ip2.

3. Execute **TCPPortCheck-Socket.ps1** on Powershell
