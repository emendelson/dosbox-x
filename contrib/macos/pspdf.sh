#!/bin/bash

cd "$(dirname "$0")"

NOW=$(date '+%F_%H:%M:%S')
FULLPATH="$HOME/Desktop/$NOW.pdf"

# osascript -e ' tell application "System Events" to display dialog "path is:'"$FULLPATH"' " buttons {"OK"}'

./gs -sBATCH -dNOPAUSE -sDEVICE=pdfwrite -sOutputFile="$FULLPATH" "$1" 

rm "$1"
