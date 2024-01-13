if not DEFINED IS_MINIMIZED set IS_MINIMIZED=1 && start "" /min "%~0" %* && exit

@echo off	
cd /D "%~dp0"

:: Check WMIC is available
WMIC.EXE Alias /? >NUL 2>&1 || GOTO s_error

:: Use WMIC to retrieve date and time
FOR /F "skip=1 tokens=1-6" %%G IN ('WMIC Path Win32_LocalTime Get Day^,Hour^,Minute^,Month^,Second^,Year /Format:table') DO (
   IF "%%~L"=="" goto s_done
      Set _yyyy=%%L
      Set _mm=00%%J
      Set _dd=00%%G
      Set _hour=00%%H
      SET _minute=00%%I
      SET _second=00%%K
)
:s_done

:: Pad digits with leading zeros
      Set _mm=%_mm:~-2%
      Set _dd=%_dd:~-2%
      Set _hour=%_hour:~-2%
      Set _minute=%_minute:~-2%
      Set _second=%_second:~-2%

Set logtimestamp=%_yyyy%-%_mm%-%_dd%_%_hour%_%_minute%_%_second%
goto make_dump

:s_error
echo WMIC is not available, using default log filename
Set logtimestamp=_

:make_dump

@ECHO OFF
SETLOCAL DisableDelayedExpansion    
FOR /F "tokens=1,3 delims=:; " %%I IN ('%SystemRoot%\System32\systeminfo.exe 2^>nul ^| %SystemRoot%\System32\find.exe ";"') DO SET "Locale%%I=%%J"

rem Above retuns LocaleSystem and LocaleInput (two letters)

set "codepage=850"
set "PAPER=-pps7"
if %LocaleSystem%==en-us (
	set "codepage=437"
	set "PAPER=-pps0"
)
if %LocaleSystem%==en-ca (
	set "codepage=437"
	set "PAPER=-pps0"
)

rem win_iconv.exe -f 850 -t 1252 %1 >1252.txt
win_iconv.exe -f %codepage% -t 1252 %1 >1252.txt

:CheckForFile
IF EXIST 1252.txt GOTO FoundIt
TIMEOUT /T 1 >nul
GOTO CheckForFile
:FoundIt

set FILENAME=%TEMP%\%logtimestamp%.pdf

rem https://www.verypdf.com/txt2pdf/help.htm
rem -pps0 is letter, -pps7 is A4
txt2pdf.exe 1252.txt %FILENAME% %PAPER% -pfs10 -pfc100 -pffCourier 

powershell.exe -ExecutionPolicy Bypass -File .\printpdf.ps1 %FILENAME%

del %FILENAME%
del 1252.txt
del %1
exit

