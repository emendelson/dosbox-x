@echo off	
cd /D "%~dp0"

start /wait /min RawPrint.exe %1

del %1


