#!/bin/bash

# convert text file to arbitrarily-named PDF on desktop

cd "$(dirname "$0")"

./gs -dBATCH -dNOPAUSE -sDEVICE=txtwrite -sOutputFile=pstemp.txt "$1" 

export LANG="en_US.UTF-8"

cat pstemp.txt | pbcopy
rm "$1"
rm pstemp.txt

