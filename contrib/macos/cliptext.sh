#!/bin/bash

# convert text file to arbitrarily-named PDF on desktop

cd "$(dirname "$0")"

cat "$1" | pbcopy
rm "$1"

