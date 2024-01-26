if not DEFINED IS_MINIMIZED set IS_MINIMIZED=1 && start "" /min "%~0" %* && exit

@echo off	
cd /D "%~dp0"

gswin32c.exe -dBATCH -dNOPAUSE -sDEVICE=txtwrite -sOutputFile=pstemp.txt %1

win_iconv.exe -f UTF8 -t UTF16LE pstemp.txt > forclip.txt

:CheckForFile
IF EXIST forclip.txt GOTO FoundIt
TIMEOUT /T 1 >nul
GOTO CheckForFile
:FoundIt

clip < forclip.txt

del %1
del pstemp.txt
del forclip.txt

exit

