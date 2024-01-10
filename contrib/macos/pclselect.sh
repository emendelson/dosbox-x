#!/bin/bash

cd "$(dirname "$0")"

# test for available printers
PTRS=$( lpstat -p | grep -c "enabled")
if [ ! "$PTRS" -gt 0 ]; then
	message="No printers available."
	osascript -e "tell app \"System Events\" to display dialog \"$message\" buttons {\"OK\"} with title \"DOSBox-X Printing\""
	exit
fi

./gpcl6 -dNOPAUSE -sDEVICE=pdfwrite -sOutputFile=select.pdf "$1"

rm "$1"

DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
PDF=("$DIR/select.pdf")

source ./selectprint.sh "$PDF"
exit