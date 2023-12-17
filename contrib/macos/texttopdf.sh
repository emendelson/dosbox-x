#!/bin/bash

# convert text file to arbitrarily-named PDF on desktop

cd "$(dirname "$0")"

LOC=$( defaults read "Apple Global Domain" AppleLocale )
PAPER="a4"
if [ $LOC = "en_US" ] || [ $LOC = "en_CA" ] ; then
   PAPER="us"
fi

NOW=$( date '+%F_%H:%M:%S' )

./nenscript -p temp.ps -fCourier9 -B -T $PAPER "$1"
./gs -sBATCH -dNOPAUSE -sDEVICE=pdfwrite -sOutputFile=temp.pdf temp.ps

mv temp.pdf "$HOME/Desktop/$NOW.pdf"
rm temp.ps
rm "$1"

