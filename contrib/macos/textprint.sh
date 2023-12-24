#!/bin/bash

cd "$(dirname "$0")"

# test for available printers
PTRS=$( lpstat -p | grep -c "enabled")
if [ ! "$PTRS" -gt 0 ]; then
	message="No printers available."
	osascript -e "tell app \"System Events\" to display dialog \"$message\" buttons {\"OK\"} with title \"DOSBox-X Printing\""
	exit
fi

LOC=$( defaults read "Apple Global Domain" AppleLocale )
PAPER="a4"
if [ "$LOC" = "en_US" ] || [ "$LOC" = "en_CA" ] ; then
   PAPER="us"
fi

./nenscript -p temp.ps -fCourier9 -B -T $PAPER "$1"
./gs -sBATCH -dNOPAUSE -sDEVICE=pdfwrite -sOutputFile=temp.pdf temp.ps

lpr -r temp.pdf
rm temp.ps
rm "$1"

sleep 1

# queue=$(lpq | grep "entries")

for ((n=0;n<30;n++)); do
   if lpq | grep -q 'entries'; then 
   		#  osascript -e "tell app \"System Events\" to display dialog \"OK\" buttons {\"OK\"} with title {\"DOSBox-X Printing\"}"
	 	exit 0
	else
		sleep 1
	fi
done

if lpq | grep -q 'entries'; then 
	exit 0
else
  
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
fi

exit 0


