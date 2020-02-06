rem 步频180/min

d:

rem for yesheng
::cd D:\Program Files\Nox\bin
::nox_adb.exe connect  127.0.0.1:62001

rem for leidian
cd D:\ChangZhi\dnplayer2
adb connect 127.0.0.1:5555

rem start D:\default\shell\run-XJTY\floatTest.vbs

@echo off

rem Wn = 34.248500, Ws = 34.247400, Jw = 108.980950, Je = 108.981750

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
rem parameter estimation

rem XJTY-Playground
set /a Wn = 34248500, Ws = 34247400, Jw = 108980950, Je = 108981750		

rem reset to get 1s/time, consider delay. 	GPS renew time
rem for yesheng 
	::set /a delayed = 700
rem for leidian 
	set /a delayed = 500

	
rem set them Linkaged.						step: decide the total time
rem record 	(1:	1.6628)		[length, time]		round: 5.4 == 6 
::			(18, 29) 		[2.01, 8'48''] 		5.15
::			(13, 22) 		[2.02, 6'43''] 		5.25
::==delayed==700==^^
set /a DivJ = 18
set /a DivW = 29

rem start off, to calibration the first point. meters 
set /a SOC = 25															

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

set /a SOCW=%SOC%*1000000/111322

set /a StepW = (%Wn% - %Ws%)/%DivW% 		
set /a StepJ = (%Je% - %Jw%)/%DivJ%		

rem "WnM" means start from 1, Cumulative sub latitude							
set /a WnM = Wn						

rem "JeM" means start from 0, Cumulative sub longitude
set /a JeM = Je						

rem "JwM" means start from 2, Cumulative add longitude
set /a JwM = Jw						

rem "WsM" means start from 3, Cumulative add latitude
set /a WsM = Ws						

rem lazy for type
::echo WnM = %WnM% StepW = %StepW%
echo WnM = %WnM% WsM = %WsM% JwM = %JwM% JeM = %JeM% StepW = %StepW% StepJ = %StepJ% Wn = %Wn%
::pause

rem convert integer to float. Attention: do not put space on both side of "="
set Wnl=%Wn:~,-6%.%Wn:~-6,6% 		 
set Wsl=%Ws:~,-6%.%Ws:~-6,6%
set Jwl=%Jw:~,-6%.%Jw:~-6,6%
set Jel=%Je:~,-6%.%Je:~-6,6%

rem set initial point in movement
set /a Ini = %Wn% - %SOCW% 
set /a IniM = %Ini%
:initial
set /a IniM = %IniM% + %StepW%
if %IniM% GEQ %Wn% goto startC
set InilM=%IniM:~,-6%.%IniM:~-6,6%
::adb -s 127.0.0.1:5555  shell setprop persist.nox.gps.latitude %InilM%
::adb -s 127.0.0.1:5555  shell setprop persist.nox.gps.longitude %Jel%
ldconsole.exe locate --index 0 --LLI %Jel%,%InilM%

::call delay %delayed%
goto initial
:startC
pause

rem Statistical Cycles
set /a SC = 0

rem start cycling
:InitialPoint
echo :::::: the %SC% round :::::: 
rem 0
::adb -s 127.0.0.1:5555  shell setprop persist.nox.gps.latitude %Wnl%
ldconsole.exe locate --index 0 --LLI %Jel%,%Wnl%

call delay  %delayed%
:continue0
set /a JeM = %JeM% - %StepJ%
if %JeM% LEQ %Jw% (goto next1)
set JelM=%JeM:~,-6%.%JeM:~-6,6%
::adb -s 127.0.0.1:5555  shell setprop persist.nox.gps.longitude %JelM%
ldconsole.exe locate --index 0 --LLI %JelM%,%Wnl%

echo point0 %time%
call delay %delayed%
goto continue0

:next1
rem 1
::adb -s 127.0.0.1:5555  shell setprop persist.nox.gps.longitude %Jwl%
:continue1
set /a WnM = %WnM% - %StepW%				 
if %WnM% LEQ %Ws% (goto next2)
set WnlM=%WnM:~,-6%.%WnM:~-6,6%				
::adb -s 127.0.0.1:5555  shell setprop persist.nox.gps.latitude %WnlM%
ldconsole.exe locate --index 0 --LLI %Jwl%,%WnlM%

echo point1 %time%
call delay %delayed%
goto continue1

:next2

set /a WnM = Wn						
set /a JeM = Je						
set /a JwM = Jw						
set /a WsM = Ws	
rem echo WnM = %WnM% WsM = %WsM% JwM = %JwM% JeM = %JeM%
			
rem 2
::adb -s 127.0.0.1:5555  shell setprop persist.nox.gps.latitude %Wsl%
:continue2
set /a JwM = %JwM% + %StepJ%
if %JwM% GEQ %Je% (goto next3)
set JwlM=%JwM:~,-6%.%JwM:~-6,6%
::adb -s 127.0.0.1:5555  shell setprop persist.nox.gps.longitude %JwlM%
ldconsole.exe locate --index 0 --LLI %JwlM%,%Wsl%

echo point2 %time%
call delay %delayed%
goto continue2

:next3
if %SC% GEQ 5 pause
rem 3
::adb -s 127.0.0.1:5555  shell setprop persist.nox.gps.longitude %Jel%
:continue3
set /a WsM = %WsM% + %StepW%
if %WsM% GEQ %Wn% (goto next0)
set WslM=%WsM:~,-6%.%WsM:~-6,6%
::adb -s 127.0.0.1:5555  shell setprop persist.nox.gps.latitude %WslM%
ldconsole.exe locate --index 0 --LLI %Jel%,%WslM%

echo point3 %time%
call delay %delayed%
goto continue3

:next0
set /a WnM = Wn						
set /a JeM = Je						
set /a JwM = Jw						
set /a WsM = Ws

set /a SC=%SC%+1
goto InitialPoint
