#!/bin/bash

cd "$(dirname "$0")"

DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
PDF=("$DIR"/select.pdf)

osascript - "$PDF" <<EndOfScript

use AppleScript version "2.4" 
use scripting additions

on run argv
	
	set pdfPosix to argv
	set msgTitle to "DOSBox-X Printing"
	
	set thePrinter to ""
	set theQueue to ""
	
	set printerNames to (do shell script "lpstat  -l -p | grep -i Description: | cut -d' ' -f2- ")
	set queueNames to (do shell script "lpstat -a | grep accepting | cut -f1 -d\" \" ")
	
	set printerList to (every paragraph of printerNames) as list
	set queueList to (every paragraph of queueNames) as list
	
	if printerList is {} then
		tell application "System Events"
			activate
			display dialog "No printers found" buttons {"OK"} with title msgTitle
		end tell
		do shell script "rm" & space & pdfPosix
		return
	end if
	
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
				display dialog "Printing cancelled." buttons {"OK"} default button 1 with title msgTitle giving up after 2
			end tell
			do shell script "rm " & pdfPosix
			return
			
		else
			
			set thePrinter to item 1 of thePrinter
			
			repeat with i from 1 to the count of printerList
				if item i of printerList is thePrinter then
					set item_num to i
				end if
			end repeat
			
			set theQueue to item item_num in queueList
			
			(*
			try
				set printerList to (every paragraph of printerNames) as list
				set queueList to (every paragraph of queueNames) as list
			end try
			*)
			
			set dnsURL to do shell script "lpstat -v " & theQueue
			set dnsString to (do shell script "perl -e 'use URI::Escape; print uri_unescape(\"" & dnsURL & "\")';")
			
			try
				tell application "./BonjourEvents.app"
					if (exists browser "MyBrowser") then
						set IPPBrowser to browser "MyBrowser"
					else
						set IPPBrowser to make new browser with properties {name:"MyBrowser"}
					end if
					tell IPPBrowser
						scan for type "_printer._tcp" in domain "local"
						if (count services) > 0 then
							set nameList to name of services
							set addressList to IPv4 address of services
						else
							set nameList to {}
							set addressList to {}
						end if
						quit
						-- Bonjour Events quits automatically after 2 minutes of inactivity
					end tell
				end tell
			on error errorMessage number errorNumber
				display dialog "An error occurred: " & errorMessage & " (" & errorNumber & ")"
			end try
			
			set ipPrinterFound to false
			repeat with currentItem in nameList
				if currentItem is in dnsString then
					set ipPrinterFound to true
					-- set currentListItem to currentItem as item
					-- set dnsNumber to my list_position(currentListItem, nameList)
					-- set printerIP to item dnsNumber in addressList
					-- display dialog thePrinter & return & return & "has the DNS instance name" & return & return & currentItem & return & return & "IP address:" & space & printerIP & return & return & "queue name:" & space & theQueue buttons {"OK"}
					exit repeat
				end if
			end repeat
			
			if ipPrinterFound is false then
				tell application "System Events"
					activate
					display dialog thePrinter & " may be offline." & return & return & "If you know the printer exists, should I try to print anyway?" buttons {"No", "Yes"} default button 1 with title msgTitle
					if button returned of result is "No" then
						do shell script "rm " & pdfPosix
						return
					end if
				end tell
			end if
			
			try
				do shell script "lpr -rP " & "\"" & theQueue & "\"" & " " & pdfPosix
			on error err
				tell application "System Events"
					activate
					display dialog err & return & return & "Could not send PDF file to printer." buttons {"OK"} with title msgTitle giving up after 10
				return
				end tell
			end try
			
			try
				do shell script "rm " & pdfPosix
			end try
			
		end if
	end if
end run

on list_position(this_item, this_list)
	repeat with i from 1 to the count of this_list
		if item i of this_list is this_item then return i
	end repeat
	return 0
end list_position

EndOfScript

exit
