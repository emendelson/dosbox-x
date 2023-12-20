#!/bin/bash

cd "$(dirname "$0")"

NOW=$( date '+%F_%H:%M:%S' )

# osascript -e ' tell application "System Events" to display dialog "path is:'"$FULLPATH"' " buttons {"OK"}'

./gs -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -sOutputFile="$HOME/Desktop/$NOW.pdf" "$1" 

rm "$1"
