@echo off

ver | find "Version 5." > nul
if not errorlevel 1 goto :win2003

ver | find "Version 6." > nul
if not errorlevel 1 goto :win2008_2012

rem = It is newer than Windows Server 2012
goto :win2008_2012


:win2003

rem = Server to Server
netsh firewall add portopening TCP 29001 "EXPRESSCLUSTER Internal Communication" > nul
netsh firewall add portopening TCP 29002 "EXPRESSCLUSTER Data Forwarding" > nul
netsh firewall add portopening UDP 29003 "EXPRESSCLUSTER Alert Synchronization" > nul
netsh firewall add portopening TCP 29004 "EXPRESSCLUSTER Disk Agents Communication" > nul
netsh firewall add portopening TCP 29005 "EXPRESSCLUSTER Mirror Drivers Communication" > nul
netsh firewall add portopening UDP 29106 "EXPRESSCLUSTER Heartbeat" > nul

rem = Server to Client
netsh firewall add portopening TCP 29007 "EXPRESSCLUSTER Client Service Communication (TCP)" > nul
netsh firewall add portopening UDP 29007 "EXPRESSCLUSTER Client Service Communication (UDP)" > nul

rem = Server to WebManager
netsh firewall add portopening TCP 29003 "EXPRESSCLUSTER HTTP Connection" > nul
netsh firewall add portopening UDP 29010 "EXPRESSCLUSTER UDP Connection" > nul

goto :end


:win2008_2012

rem = Server to Server
netsh advfirewall firewall add rule ^
    name="EXPRESSCLUSTER Internal Communication" ^
    dir=in protocol=TCP localport=29001 action=allow > nul

netsh advfirewall firewall add rule ^
    name="EXPRESSCLUSTER Data Forwarding" ^
    dir=in protocol=TCP localport=29002 action=allow > nul

netsh advfirewall firewall add rule ^
    name="EXPRESSCLUSTER Alert Synchronization" ^
    dir=in protocol=UDP localport=29003 action=allow > nul

netsh advfirewall firewall add rule ^
    name="EXPRESSCLUSTER Disk Agents Communication" ^
    dir=in protocol=TCP localport=29004 action=allow > nul

netsh advfirewall firewall add rule ^
    name="EXPRESSCLUSTER Mirror Drivers Communication" ^
    dir=in protocol=TCP localport=29005 action=allow > nul

netsh advfirewall firewall add rule ^
    name="EXPRESSCLUSTER Heartbeat" ^
    dir=in protocol=UDP localport=29106 action=allow > nul

rem = Server to Client
netsh advfirewall firewall add rule ^
    name="EXPRESSCLUSTER Client Service Communication (TCP)" ^
    dir=in protocol=TCP localport=29007 action=allow > nul

netsh advfirewall firewall add rule ^
    name="EXPRESSCLUSTER Client Service Communication (UDP)" ^
    dir=in protocol=UDP localport=29007 action=allow > nul

rem = Server to WebManager
netsh advfirewall firewall add rule ^
    name="EXPRESSCLUSTER HTTP Connection" ^
    dir=in protocol=TCP localport=29003 action=allow > nul

netsh advfirewall firewall add rule ^
    name="EXPRESSCLUSTER UDP Connection" ^
    dir=in protocol=UDP localport=29010 action=allow > nul

goto :end


:end
