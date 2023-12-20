#!/bin/bash

# convert text file to arbitrarily-named PDF on desktop

cd "$(dirname "$0")"

./gpcl6 -dBATCH -dNOPAUSE -sDEVICE=txtwrite -sOutputFile=pcltemp.txt clip.txt
# ./gs -dBATCH -dNOPAUSE -sDEVICE=txtwrite -sOutputFile=pcltemp.txt pstemp.ps

cat pcltemp.txt | pbcopy
rm "$1"
rm pcltemp.txt
# rm pstemp.ps


