#!/bin/bash

cd "$(dirname "$0")"



## TODO: add this to PJL string
LOC=$( defaults read "Apple Global Domain" AppleLocale )
PAPER="A4"
if [ $LOC = "en_US" ] || [ $LOC = "en_CA" ] ; then
   PAPER="LETTER"
fi
PJLPAPER="@PJL SET PAPER=$PAPER"

FILE=./BDrive/PDFNAME.TMP
TMP=./BDrive/temp.tmp
UNX=./BDrive/pdfname.unx

if [ -f "$FILE" ]; then
    sed 's#\\#/#g' $FILE > $TMP; rm $FILE; mv $TMP $FILE
    tr -d '\015\' <$FILE >$UNX
    PDFNAME="$(head -n 1 $UNX | tail -1)"
    DOSPATH="$(head -n 2 $UNX | tail -1)"
    ENDPATH="$(echo $DOSPATH | cut -c 4-)"
    MNTMSG="$(head -n 3 $UNX | tail -1)"
    MNTPATH="$(echo $MNTMSG | cut -c 46-)"
    SLH="/"
    rm $FILE
    rm $UNX
    FULLPATH="$MNTPATH$ENDPATH$SLH$PDFNAME.pdf"
else
    NOW=$(date '+%F_%H:%M:%S')
    FULLPATH=~/Desktop/$NOW.pdf
fi

# osascript -e ' tell application "System Events" to display dialog "path is:'"$FULLPATH"' " buttons {"OK"}'

if [ -f "$FULLPATH" ]; then
    RESP=$(/usr/bin/osascript<<END
     tell application "System Events"
     set writeFile to button returned of (display dialog "Output PDF exists. Overwrite it?" buttons {"Ok", "Quit"} default button 2 with title "Output PDF exists")
     end tell
     return writeFile
     END)
    
    if [ $RESP == "Quit" ]; then
        osascript -e 'tell application "System Events" to display dialog "PDF writing cancelled." buttons {"OK"} giving up after 2 with title "Cancelled" '
        exit 0
    fi
fi

myName=`basename "$0"`
if [[ $myName =~ "pcl" ]]; then
    ./pcl6 -dNOPAUSE -sDEVICE=pdfwrite -sOutputFile=temppdf.pdf "$1"
else
    /usr/bin/pstopdf "$1" -o temppdf.pdf 
fi
mv temppdf.pdf $FULLPATH
rm "$1"
