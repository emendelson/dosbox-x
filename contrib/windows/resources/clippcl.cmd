if not DEFINED IS_MINIMIZED set IS_MINIMIZED=1 && start "" /min "%~0" %* && exit

@echo off	
cd /D "%~dp0"

gpcl6win32.exe -dBATCH -dNOPAUSE -sDEVICE=txtwrite -sOutputFile=pcltemp.txt %1

win_iconv.exe -f UTF8 -t UTF16LE pcltemp.txt > forclip.txt

:CheckForFile
IF EXIST forclip.txt GOTO FoundIt
TIMEOUT /T 1 >nul
GOTO CheckForFile
:FoundIt

clip.exe < forclip.txt

del pcltemp.txt  
del forclip.txt
del %1

exit

