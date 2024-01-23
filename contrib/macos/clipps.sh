#!/bin/bash

cd "$(dirname "$0")"

./gs -dBATCH -dNOPAUSE -sDEVICE=txtwrite -sOutputFile=pstemp.txt "$1" 

LOC=$( defaults read "Apple Global Domain" AppleLocale )
export LANG="$LOC.UTF-8"

cat pstemp.txt | pbcopy
rm "$1"
rm pstemp.txt

