#!/bin/bash

cd "$(dirname "$0")"

DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
PDF=("$DIR"/temp.pdf)

# osascript -e ' tell application "System Events" to display dialog "path is:'"$FULLPATH"' " buttons {"OK"}'

./gs -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -sOutputFile=temp.pdf "$1" 
lpr temp.pdf
rm "$1"

sleep 1

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