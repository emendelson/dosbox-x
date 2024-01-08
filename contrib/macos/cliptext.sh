#!/bin/bash

# convert text file to arbitrarily-named PDF on desktop

cd "$(dirname "$0")"

export LANG="en_US.UTF-8"

iconv -f CP437 -t UTF-8 "$1" > new.txt

cat new.txt | pbcopy

rm "$1"
rm new.txt

