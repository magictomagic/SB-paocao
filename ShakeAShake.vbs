dim i
i = 0
rem stop1 = inputbox("&")
do while i <  450

rem for yesheng
rem d = "d: & cd D:\Program Files\Nox\bin & nox_adb.exe connect  127.0.0.1:62001"

rem for leidian
d = "d: & cd D:\ChangZhi\dnplayer2 & adb connect 127.0.0.1:5555"

set q=createobject("scripting.filesystemobject") 
set a=WScript.CreateObject("WScript.Shell") 
a.run "%Comspec% /c"&d 


set object = CreateObject("wscript.shell")
object.SendKeys "^(6)"

WScript.sleep 1000
i = i + 1
loop