#!/bin/bash

cd "$(dirname "$0")"

DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
PDF=("$DIR"/temp.pdf)

# Get the default printer's name
default_printer=$(lpstat -d 2>&1)
# Check if a default printer is set
if [[ $default_printer == *"no system default destination"* ]]; then
    message="No default printer set. I cannot print the printer output."
    # Use osascript to display the message in a dialog box
	osascript -e "tell app \"System Events\" to display dialog \"$message\" buttons {\"OK\"} with title {\"DOSBox-X Printing\"}"
	exit
fi

## TODO: add this to PJL string
LOC=$( defaults read "Apple Global Domain" AppleLocale )
PAPER="A4"
if [ $LOC = "en_US" ] || [ $LOC = "en_CA" ] ; then
 PAPER="LETTER"
fi
# PJLPAPER="@PJL SET PAPER=$PAPER"

./gpcl6 -dNOPAUSE -sDEVICE=pdfwrite -sOutputFile=temp.pdf "$1"

lpr temp.pdf
rm "$1"

sleep 1

# queue=$(lpq | grep "entries")

for ((n=0;n<30;n++)); do
   if lpq | grep -q 'entries'; then 
   		#  osascript -e "tell app \"System Events\" to display dialog \"OK\" buttons {\"OK\"} with title {\"DOSBox-X Printing\"}"
   		rm temp.pdf
	 	exit 0
	else
		sleep 1
	fi
done

if lpq | grep -q 'entries'; then 
	rm temp.pdf
	exit 0
fi

osascript - "$PDF" <<EndOfScript
   
   on run argv
   set pdfPosix to argv
   set msgTitle to "DOSBox-X Printing"
   
	try
		set defPtr to word 4 of (do shell script "lpstat -d")
	on error err
		activate
		tell application "System Events"
			display dialog err
		end tell
	end try
      		
	tell application "System Events"
		activate
		display dialog "If nothing printed, the default printer" & return &  return & "       " & defPtr & return & return & "may be offline. If so, I can either abandon the print job or create a PDF on the desktop." buttons {"Abandon", "Desktop PDF"} with title msgTitle 
		if button returned of result is "Desktop PDF" then
			try
				set timeNow to do shell script "date '+%F_%H:%M:%S' "
				do shell script "cp" & space & pdfPosix & space & quoted form of  ("$HOME/Desktop/" & timeNow & ".pdf")
			on error err
					display dialog err
			end try
		end if
	end tell
	
	try
		do shell script "rm" & space & pdfPosix
	end try

end run

EndOfScript

exit

