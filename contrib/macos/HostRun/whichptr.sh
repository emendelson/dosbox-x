#!/bin/bash


PTRDF=$(lpstat -d | awk '{print $4}')
PTRNAME=$(lpstat -l -p $PTRDF | grep -i Description: | awk -F'Description: ' '{print $2}')
# echo $PTRNAME > ~/Desktop/name.txt
osascript -e 'tell application "System Events" to display dialog "'"$PTRNAME"'" with title "Default MacOS Printer" buttons {"OK"} giving up after 4'
