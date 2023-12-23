#!/bin/bash

cd "$(dirname "$0")"

DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
PDF=("$DIR"/select.pdf)

osascript - "$PDF" <<EndOfScript

	on run argv
	
	set pdfPosix to argv

	set msgTitle to "DOSBox-X Printing"
		
	set thePrinter to ""
	set theQueue to ""
	
	
	set printerNames to (do shell script "lpstat  -l -p | grep -i Description: | cut -d' ' -f2- ")
	set queueNames to (do shell script "lpstat -a | grep accepting | cut -f1 -d\" \" " )
	
	set printerList to (every paragraph of printerNames) as list
	set queueList to (every paragraph of queueNames) as list
	
	if the (count of printerList) is 1 then
	
		set thePrinter to {item 1 of printerList} as string
		set theQueue to {item 1 of queueList} as string
		
	else
	
		tell application "SystemUIServer"
			activate
			try
				set thePrinter to (choose from list printerList with title "Printers" with prompt "Select a printer:")
			end try
		end tell
		
		if thePrinter is false then

			tell application "System Events"
				activate
				display dialog "Printing cancelled." buttons {"OK"} default button 1 with title msgTitle giving up after 3
			end tell
			do shell script "rm " & pdfPosix

		else
			set thePrinter to item 1 of thePrinter
			
			repeat with i from 1 to the count of PrinterList
				if item i of PrinterList is thePrinter then 
					set item_num to i
				end if
			end repeat
		
			set theQueue to item item_num in queueList
			
			try
				do shell script "lpr -r -P " & "\"" & theQueue & "\"" & " " & pdfPosix
			on error err
				tell application "System Events"
					activate
					display dialog err
					display dialog "Could not send PDF file to printer." buttons {"OK"} with title msgTitle giving up after 10
				end tell
			end try
			try
				do shell script "rm " & pdfPosix
			end try
		
			delay 1
			set prtDone to false
			repeat with i from 1 to 10
				try
					set ptrState to do shell script "lpq -P " & "\"" & theQueue & "\""
					if ptrState contains "entries" then
						set prtDone to true
						exit repeat
					else 
						delay 1
					end if
				end try
			end repeat
			
			if prtDone is false then 
				tell application "System Events"
					activate
					display dialog thePrinter & return & "may be offline. If so, please cancel the print job and choose a different printer." buttons {"OK"} with title msgTitle 
				end tell
			end if
		
		end if
	end if
end run
	
EndOfScript

exit
