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

gswin32c.exe -dBATCH -dNOPAUSE -sDEVICE=txtwrite -sOutputFile=pstemp.txt %1

win_iconv.exe -f UTF8 -t %codepage% pstemp.txt > forclip.txt

clip < forclip.txt

del %1
del pstemp.txt
del forclip.txt

exit

