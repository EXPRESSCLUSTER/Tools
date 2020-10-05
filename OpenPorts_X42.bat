@echo off

ver | find "Version 6." > nul
if not errorlevel 1 goto :win2012

ver | find "Version 10." > nul
if not errorlevel 1 goto :win2016_2019

rem = It is newer than Windows Server 2019
goto :win2016_2019


:win2012
:win2016_2019

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
    name="EXPRESSCLUSTER Information Base Communication" ^
    dir=in protocol=TCP localport=29008 action=allow > nul
    
netsh advfirewall firewall add rule ^
    name="EXPRESSCLUSTER Restful API Communication (TCP)" ^
    dir=in protocol=TCP localport=29010 action=allow > nul

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

netsh advfirewall firewall add rule ^
    name="EXPRESSCLUSTER Restful API Communication (UDP)" ^
    dir=in protocol=UDP localport=29009 action=allow > nul

rem = Server to WebManager
netsh advfirewall firewall add rule ^
    name="EXPRESSCLUSTER HTTP Connection" ^
    dir=in protocol=TCP localport=29003 action=allow > nul

goto :end


:end
