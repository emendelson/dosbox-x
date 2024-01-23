#!/bin/bash

cd "$(dirname "$0")"

LOC=$( defaults read "Apple Global Domain" AppleLocale )
export LANG="$LOC.UTF-8"
CODEPAGE="CP850"
if [ $LOC = "en_US" ] || [ $LOC = "en_CA" ] ; then
   CODEPAGE="CP437"
fi

iconv -f $CODEPAGE -t UTF-8 "$1" > new.txt

cat new.txt | pbcopy

rm "$1"
rm new.txt
