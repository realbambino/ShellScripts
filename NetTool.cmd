set wkey=Please type in the SSID
set lclhost=127.0.0.1
set pingIP=13.107.4.52

@ECHO THIS MAY HELP TO REPAIR / RECTIFY,
@ECHO VERY, SIMPLE NETWORK DIFFICULTIES.
@ECHO SOME ETHERNET / WIRELESS PROBLEMS.
@ECHO THE RESULTS WILL VARY ACCORDING TO
@ECHO YOUR CONFIGURATION AND USER LEVEL.
@ECHO A RE-BOOT MUST BE DONE AFTER DOING
@ECHO SOME OF THE CHECKS OPTIONED BELOW.
@ECHO...................................
:MENU
@ECHO TYPE IN YOUR PREFERRED MENU CHOICE
@ECHO...................................
@ECHO.
@ECHO 0 - FINISHD Close this Command Box
@ECHO 1 - PING_LR Ping Local and Remote.
@ECHO 2 - ISP_MDM Ping Modem 192.168.X.1
@ECHO 3 - TRACERT Trace Route to Remote.
@ECHO 4 - MAC_IFS Get MAC and InterFaceS
@ECHO 5 - SEE_IFS See Network InterFaceS
@ECHO 6 - SH_CONN Show I/Face Connection
@ECHO 7 - DR_WLAN Drivers WLAN interface
@ECHO 8 - IP_CONF Display Network Config
@ECHO 9 - INFO_32 Shows MSINFO32 Screens
@ECHO A - IPvFOUR Reset to remove errors
@ECHO B - WINSOCK Reset to remove errors
@ECHO C - IP_RNEW Force/Renew IP address
@ECHO D - PROFILE Displays SSID listings
@ECHO E - WIFIKEY Displays as clear text
@ECHO F - CONNECT Manual WiFi connection

@ECHO ..................................
@ECHO OFF
COLOR B1
SET /P M= Press 0-F, and then ENTER: 

IF /I %M%==0 GOTO FINISHD
IF /I %M%==1 GOTO PING_LR
IF /I %M%==2 GOTO ISP_MDM
IF /I %M%==3 GOTO TRACERT
IF /I %M%==4 GOTO MAC_IFS
IF /I %M%==5 GOTO SEE_IFS
IF /I %M%==6 GOTO SH_CONN
IF /I %M%==7 GOTO DR_WLAN
IF /I %M%==8 GOTO IP_CONF
IF /I %M%==9 GOTO INFO_32
IF /I %M%==A GOTO IPvFOUR
IF /I %M%==B GOTO WINSOCK
IF /I %M%==C GOTO IP_RNEW
IF /I %M%==D GOTO PROFILE
IF /I %M%==E GOTO WIFIKEY
IF /I %M%==F GOTO CONNECT

:FINISHD
EXIT

:PING_LR
@ECHO OVER 2, and 20ms is a POOR result IMO.
ping %lclhost% & ping %pingIP%
echo.
PAUSE
GOTO MENU

:ISP_MDM
@ECHO Covers most ISP modems.
ping 192.168.0.1 & ping 192.168.1.1
echo.
PAUSE
GOTO MENU

:TRACERT
tracert %pingIP%
echo.
PAUSE
GOTO MENU

:MAC_IFS
@ECHO Listing MAC and Adapter details.
getmac & netsh interface ip show interface
echo.
PAUSE
GOTO MENU

:SEE_IFS
netsh wlan show interfaces & netsh lan show interfaces
echo.
PAUSE
GOTO MENU

:SH_CONN
powershell Get-NetConnectionProfile
echo.
PAUSE
GOTO MENU

:DR_WLAN
netsh wlan show drivers & powershell get-netadapter
pause
echo.
GOTO MENU

:IP_CONF
ipconfig /all
echo.
PAUSE
GOTO MENU

:INFO_32
msinfo32
echo.
PAUSE
GOTO MENU

:IPvFOUR
netsh int ipv4 reset reset.log
echo.
PAUSE
GOTO MENU

:WINSOCK 
netsh winsock reset catalog
echo.
GOTO MENU

:IP_RNEW
ipconfig /release
ipconfig /renew
echo.
PAUSE
GOTO MENU

:PROFILE
netsh wlan show profiles
echo.
@ECHO PLEASE NOTE every NETWORK-SSID
@ECHO NAME and KEY for a connection.
echo.
PAUSE
GOTO MENU

:WIFIKEY
netsh wlan show profile name="%wkey%" key=clear
echo.
PAUSE
GOTO MENU

:CONNECT
netsh wlan set profileparameter name="%wkey%" connectionmode=auto
echo.
PAUSE
GOTO MENU

