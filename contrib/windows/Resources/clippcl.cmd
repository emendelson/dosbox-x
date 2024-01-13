if not DEFINED IS_MINIMIZED set IS_MINIMIZED=1 && start "" /min "%~0" %* && exit

@echo off	
cd /D "%~dp0"

@ECHO OFF
SETLOCAL DisableDelayedExpansion    
FOR /F "tokens=1,3 delims=:; " %%I IN ('%SystemRoot%\System32\systeminfo.exe 2^>nul ^| %SystemRoot%\System32\find.exe ";"') DO SET "Locale%%I=%%J"

rem Above retuns LocaleSystem and LocaleInput (two letters)

set "codepage=850"
if %LocaleSystem%==en-us (
	set "codepage=437"
)
if %LocaleSystem%==en-ca (
	set "codepage=437"
)

pcl6.exe -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -sOutputFile=pcltemp.pdf %1

gswin32c.exe -dBATCH -dNOPAUSE -sDEVICE=ps2write -sOutputFile=pcltemp.ps pcltemp.pdf

gswin32c.exe -dBATCH -dNOPAUSE -sDEVICE=txtwrite -sOutputFile=pcltemp.txt pcltemp.ps

win_iconv.exe -f UTF8 -t %codepage% pcltemp.txt > forclip.txt

:CheckForFile
IF EXIST forclip.txt GOTO FoundIt
TIMEOUT /T 1 >nul
GOTO CheckForFile
:FoundIt

clip < forclip.txt

del pcltemp.pdf
del pcltemp.ps
del pcltemp.txt
del forclip.txt
del %1

exit

