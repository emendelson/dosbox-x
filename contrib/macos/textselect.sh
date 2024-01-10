#!/bin/bash

cd "$(dirname "$0")"

# test for available printers
PTRS=$( lpstat -p | grep -c "enabled")
if [ ! "$PTRS" -gt 0 ]; then
	message="No printers available."
	osascript -e "tell app \"System Events\" to display dialog \"$message\" buttons {\"OK\"} with title \"DOSBox-X Printing\""
	exit
fi

LOC=$( defaults read "Apple Global Domain" AppleLocale )
PAPER="a4"
if [ $LOC = "en_US" ] || [ $LOC = "en_CA" ] ; then
   PAPER="us"
fi
./nenscript -p temp.ps -fCourier9 -B -T $PAPER "$1"
./gs -sBATCH -dNOPAUSE -sDEVICE=pdfwrite -sOutputFile=select.pdf temp.ps

rm temp.ps
rm "$1"

source ./selectprint.sh 
exit