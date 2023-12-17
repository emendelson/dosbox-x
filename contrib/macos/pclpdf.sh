#!/bin/bash

cd "$(dirname "$0")"

## TODO: add this to PJL string
LOC=$( defaults read "Apple Global Domain" AppleLocale )
PAPER="A4"
if [ $LOC = "en_US" ] || [ $LOC = "en_CA" ] ; then
   PAPER="LETTER"
fi
PJLPAPER="@PJL SET PAPER=$PAPER"

NOW=$(date '+%F_%H:%M:%S')
FULLPATH="$HOME/Desktop/$NOW.pdf"

./gpcl6 -dNOPAUSE -sDEVICE=pdfwrite -sOutputFile=temppdf.pdf "$1"

mv temppdf.pdf "$FULLPATH"
rm "$1"
