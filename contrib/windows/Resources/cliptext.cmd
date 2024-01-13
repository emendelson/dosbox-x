if not DEFINED IS_MINIMIZED set IS_MINIMIZED=1 && start "" /min "%~0" %* && exit

@echo off	
cd /D "%~dp0"

clip.exe < %1

del %1

exit
