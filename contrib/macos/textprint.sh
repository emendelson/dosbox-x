#!/bin/bash

# convert text file to pdf and print

# Get the default printer's name
default_printer=$(lpstat -d 2>&1)
# Check if a default printer is set
if [[ $default_printer == *"no system default destination"* ]]; then
    message="No default printer set. I cannot print the printer output."
    # Use osascript to display the message in a dialog box
	osascript -e "tell app \"System Events\" to display dialog \"$message\" buttons {\"OK\"} with title {\"DOSBox-X Printing\"}"
	exit
fi

cd "$(dirname "$0")"

LOC=$( defaults read "Apple Global Domain" AppleLocale )
PAPER="a4"
if [ $LOC = "en_US" ] || [ $LOC = "en_CA" ] ; then
   PAPER="us"
fi

./nenscript -p temp.ps -fCourier9 -B -T $PAPER "$1"
./gs -sBATCH -dNOPAUSE -sDEVICE=pdfwrite -sOutputFile=temp.pdf temp.ps

/usr/bin/lpr -r temp.pdf
rm temp.ps
rm "$1"

sleep 2

empty="no entries"

SECONDS=0
until queue=$(lpq | grep "$empty")
do 
  if (( SECONDS > 10 ))
  then
  
  description=$(awk '
/system default destination:/    { defprt = $NF; next }       # make note of default printer name
$2==defprt && $1=="printer"      { print_desc = 1; next }     # if this is the line for the default printer then set flag (print_desc) to "1"
print_desc && $1=="Description:" { pos = index($0,": ")       # if print flag is set (==1) and this is a description line then find the ": " and ...
                                   print substr($0,pos+2)     # print the textual description to stdout
                                   exit
                                 }

' <(lpstat -dlp))
	
     message="If nothing printed, the default printer
     
      $description 

may be offline. If so, cancel the print job and set another printer as the default."

   osascript -e "tell app \"System Events\" to display dialog \"$message\" buttons {\"OK\"} with title {\"DOSBox-X Printing\"}"
	exit
	
  fi
done

exit

