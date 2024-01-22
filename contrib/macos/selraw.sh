#!/bin/bash

cd "$(dirname "$0")"

# test for available printers
PTRS=$( lpstat -p | grep -c "enabled")
if [ ! "$PTRS" -gt 0 ]; then
	message="No printers available."
	osascript -e "tell app \"System Events\" to display dialog \"$message\" buttons {\"OK\"} with title \"DOSBox-X Printing\""
	exit
fi

DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
# PDF=("$DIR/Contents/Resources/Files/select.pdf")
# PDF=("$DIR/Contents/Resources/Files/")

source ./selectrawprint.sh "$DIR"
exit