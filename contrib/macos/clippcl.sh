#!/bin/bash

# convert text file to arbitrarily-named PDF on desktop

cd "$(dirname "$0")"

./gpcl6 -dBATCH -dNOPAUSE -sDEVICE=txtwrite -sOutputFile=pcltemp.txt "$1"

export LANG="en_US.UTF-8"

cat pcltemp.txt | pbcopy

rm "$1"

rm pcltemp.txt



