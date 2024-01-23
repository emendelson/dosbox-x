@echo off	
cd /D "%~dp0"

SETLOCAL DisableDelayedExpansion    
FOR /F "tokens=1,3 delims=:; " %%I IN ('%SystemRoot%\System32\systeminfo.exe 2^>nul ^| %SystemRoot%\System32\find.exe ";"') DO SET "Locale%%I=%%J"

rem Above retuns LocaleSystem and LocaleInput (two letters)

set "codepage=850"
set "papertype=A4"
if %LocaleSystem%==en-us (
	set "codepage=437"
	set "papertype=US"
)
if %LocaleSystem%==en-ca (
	set "codepage=437"
	set "papertype=US"
)

rem win_iconv.exe -f 850 -t 1252 %1 >1252.txt
win_iconv.exe -f %codepage% -t 1252 %1 >1252.txt

:CheckForFile
IF EXIST 1252.txt GOTO FoundIt
TIMEOUT /T 1 >nul
GOTO CheckForFile
:FoundIt

rem timeout /t 1


start /wait /min RawPrint.exe 1252.txt

del 1252.txt
del %1
