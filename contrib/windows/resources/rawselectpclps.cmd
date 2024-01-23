@echo off	
cd /D "%~dp0"

start /wait /min SelectPrinterForRawFile.exe %1

del %1


