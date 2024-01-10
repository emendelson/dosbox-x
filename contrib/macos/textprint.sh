#!/bin/bash

cd "$(dirname "$0")"

# Get the default printer's name
default_printer=$(lpstat -d 2>&1)
# Check if a default printer is set
if [[ $default_printer == *"no system default destination"* ]]; then
    message="No default printer set. I cannot print the printer output."
    # Use osascript to display the message in a dialog box
	osascript -e "tell app \"System Events\" to display dialog \"$message\" buttons {\"OK\"} with title {\"DOSBox-X Printing\"}"
	exit
fi

LOC=$( defaults read "Apple Global Domain" AppleLocale )
PAPER="a4"
if [ "$LOC" = "en_US" ] || [ "$LOC" = "en_CA" ] ; then
   PAPER="us"
fi

./nenscript -p temp.ps -fCourier9 -B -T $PAPER "$1"
./gs -sBATCH -dNOPAUSE -sDEVICE=pdfwrite -sOutputFile=temp.pdf temp.ps

rm temp.ps
rm "$1"

DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
PDF=("$DIR"/temp.pdf)

source ./defaultprint.sh "$PDF"
exit





