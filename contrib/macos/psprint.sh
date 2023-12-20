#!/bin/bash

cd "$(dirname "$0")"

# osascript -e ' tell application "System Events" to display dialog "path is:'"$FULLPATH"' " buttons {"OK"}'

./gs -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -sOutputFile=temppdf.pdf "$1" 
lpr -r temppdf.pdf
rm "$1"
