d:
cd D:\Program Files\Nox\bin

nox_adb.exe connect  127.0.0.1:62001
rem @echo off
rem Wn = 34.248500, Ws = 34.247400, Jw = 108.980950, Je = 108.981750

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
rem parameter estimation
set /a delayed = 1
set /a DivJ = 100
set /a DivW = 50
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set /a Wn = 34248500, Ws = 34247400, Jw = 108980950, Je = 108981750
set /a StepW = (%Wn% - %Ws%)/100 		rem set 100 as variable
set /a StepJ = (%Je% - %Jw%)/50		rem set 50 according to 100
::pause
								rem search latitude and longitude correspond to meters
set /a WnM = Wn						rem "WnM" means start from 1, Cumulative sub latitude
set /a JeM = Je						rem "JeM" means start from 0, Cumulative sub longitude
set /a JwM = Jw						rem "JwM" means start from 2, Cumulative add longitude
set /a WsM = Ws						rem "WsM" means start from 3, Cumulative add latitude

rem lazy for type
::echo WnM = %WnM% StepW = %StepW%
::echo WnM = %WnM% WsM = %WsM% JwM = %JwM% JeM = %JeM%

rem convert integer to float 
set Wnl=%Wn:~,-6%.%Wn:~-6,6% 		rem do not put space on both side of "="
set Wsl=%Ws:~,-6%.%Ws:~-6,6%
set Jwl=%Jw:~,-6%.%Jw:~-6,6%
set Jel=%Je:~,-6%.%Je:~-6,6%

rem set initial point
rem adb -s 127.0.0.1:62001  shell setprop persist.nox.gps.latitude %Wnl%
rem adb -s 127.0.0.1:62001  shell setprop persist.nox.gps.longitude %Jel%

:InitialPoint
rem 0
adb -s 127.0.0.1:62001  shell setprop persist.nox.gps.latitude %Wnl%
call delay  %delayed%
:continue0
set /a JeM = %JeM% - %StepJ%
if %JeM% LEQ %Jw% (goto next1)
set JelM=%JeM:~,-6%.%JeM:~-6,6%
adb -s 127.0.0.1:62001  shell setprop persist.nox.gps.longitude %JelM%
call delay %delayed%
goto continue0

:next1
rem 1
adb -s 127.0.0.1:62001  shell setprop persist.nox.gps.longitude %Jwl%
call delay  %delayed%
:continue1
set /a WnM = %WnM% - %StepW%				 
if %WnM% LEQ %Ws% (goto next2)
set WnlM=%WnM:~,-6%.%WnM:~-6,6%				
adb -s 127.0.0.1:62001  shell setprop persist.nox.gps.latitude %WnlM%
call delay %delayed%
goto continue1

:next2

set /a WnM = Wn						
set /a JeM = Je						
set /a JwM = Jw						
set /a WsM = Ws	
echo WnM = %WnM% WsM = %WsM% JwM = %JwM% JeM = %JeM%
			
rem 2
adb -s 127.0.0.1:62001  shell setprop persist.nox.gps.latitude %Wsl%
call delay  %delayed%
:continue2
set /a JwM = %JwM% + %StepJ%
if %JwM% GEQ %Je% (goto next3)
set JwlM=%JwM:~,-6%.%JwM:~-6,6%
adb -s 127.0.0.1:62001  shell setprop persist.nox.gps.longitude %JwlM%
call delay %delayed%
goto continue2

:next3
rem 3
adb -s 127.0.0.1:62001  shell setprop persist.nox.gps.longitude %Jel%
call delay  %delayed%
:continue3
set /a WsM = %WsM% + %StepW%
if %WsM% GEQ %Wn% (goto next0)
set WslM=%WsM:~,-6%.%WsM:~-6,6%
echo WslM = %WslM%
adb -s 127.0.0.1:62001  shell setprop persist.nox.gps.latitude %WslM%
call delay %delayed%
goto continue3

:next0
set /a WnM = Wn						
set /a JeM = Je						
set /a JwM = Jw						
set /a WsM = Ws
goto InitialPoint

cmd

