d:
cd D:\Program Files\Nox\bin

nox_adb.exe connect  127.0.0.1:62001

rem 取整，小数点后6位

rem 5000 太短
set /a delayed = 10000


:InitialPoint
rem 6'o 108.981400,34.247200
adb -s 127.0.0.1:62001  shell setprop persist.nox.gps.latitude 34.247200
adb -s 127.0.0.1:62001  shell setprop persist.nox.gps.longitude 108.981400
call delay  %delayed%

rem 3'o-S 108.981700,34.247500
adb -s 127.0.0.1:62001  shell setprop persist.nox.gps.latitude 34.247500
adb -s 127.0.0.1:62001  shell setprop persist.nox.gps.longitude 108.981700
call delay  %delayed%

rem 3'o-N 108.981700,34.248400
adb -s 127.0.0.1:62001  shell setprop persist.nox.gps.latitude 34.248400
adb -s 127.0.0.1:62001  shell setprop persist.nox.gps.longitude 108.981700
call delay  %delayed%

rem 0'o 108.981400,34.248700
adb -s 127.0.0.1:62001  shell setprop persist.nox.gps.latitude 34.248700
adb -s 127.0.0.1:62001  shell setprop persist.nox.gps.longitude 108.981400
call delay  %delayed%

rem 9'o-N 108.981000,34.248400
adb -s 127.0.0.1:62001  shell setprop persist.nox.gps.latitude 34.248400
adb -s 127.0.0.1:62001  shell setprop persist.nox.gps.longitude 108.981000
call delay  %delayed%

rem 9'o-S 108.981000,34.247500
adb -s 127.0.0.1:62001  shell setprop persist.nox.gps.latitude 34.247500
adb -s 127.0.0.1:62001  shell setprop persist.nox.gps.longitude 108.981000

goto InitialPoint

cmd

