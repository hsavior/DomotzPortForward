@echo off
title Domotz Pro - local port forward

echo ============================================
echo      Domotz Pro - Local Port Forward
echo ============================================
echo.

:: Ask for loopback last octet
set "loopback_octet="
set /p loopback_octet=Enter the last octet for the loopback IP (127.0.0.X), e.g. 100: 

if "%loopback_octet%"=="" (
    echo No value entered. Exiting...
    goto :eof
)

set "loopback_ip=127.0.0.%loopback_octet%"

:: Ask for Domotz TCP tunnel details
set "hostdomotz="
set /p hostdomotz=Enter TCP tunnel HOST (e.g. us-west-2-tcp.domotz.co): 

set "portdomotz1="
set /p portdomotz1=Enter TCP tunnel PORT for the Extron device port 80 (e.g. 32700): 

set "portdomotz2="
set /p portdomotz2=Enter TCP tunnel PORT for the Extron device port 8080 (e.g. 32701): 

echo.
echo Creating loopback IP %loopback_ip% (ignore error if it already exists)...
netsh interface ipv4 add address "Loopback Pseudo-Interface 1" %loopback_ip% 255.255.255.255 >nul 2>&1

echo.
echo Creating portproxy rules...
netsh interface portproxy add v4tov4 ^
    listenport=80 listenaddress=%loopback_ip% ^
    connectport=%portdomotz1% connectaddress=%hostdomotz%

netsh interface portproxy add v4tov4 ^
    listenport=8080 listenaddress=%loopback_ip% ^
    connectport=%portdomotz2% connectaddress=%hostdomotz%

echo.
echo Local port forward created.
echo Configure the AV SignPRO device to use: %loopback_ip%
echo The Domotz TCP Tunnel will be used to reach the remote player.
echo.
echo When done, press any key to remove the port forwards...
pause >nul

echo.
echo Removing portproxy rules...
netsh interface portproxy delete v4tov4 listenport=80   listenaddress=%loopback_ip%
netsh interface portproxy delete v4tov4 listenport=8080 listenaddress=%loopback_ip%

echo Port forwards deleted.
echo Press any key to exit.
pause >nul
Save the script above as a .bat file and run it as Administrator.
It will create the appropriate port forwards, and in your application you can simply point the device to the local address you chose (for example, 127.0.0.100).
My recommendation is to still use the VPN on Demand if available.
If you need assistance with the above script, reach out to our support support@domotz.com we can assist you with it.
