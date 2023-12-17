#!/bin/bash

## TODO: add this to PJL string
LOC=$( defaults read "Apple Global Domain" AppleLocale )
PAPER="a4"
if [ $LOC = "en_US" ] || [ $LOC = "en_CA" ] ; then
   PAPER="us"
fi

cd "$(dirname "$0")"

./gpcl6 -dNOPAUSE -sDEVICE=pdfwrite -sOutputFile=temp.pdf "$1"

/usr/bin/lpr -r temp.pdf
rm "$1"
