#!/bin/bash

cd "$(dirname "$0")"

DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

PDF="$1"

# PDF=("$DIR"/temp.pdf)

osascript - "$PDF" <<EndOfScript

use AppleScript version "2.4"
use scripting additions

on run argv 

	set pdfPosix to argv
	set pdfPosix to "\"" & pdfPosix & "\""
	
	set msgTitle to "DOSBox-X Printing"

	try
		set printerName to word 4 of (do shell script "lpstat  -d")
	on error
		activate
		display dialog "No default printer found." buttons {"OK"}
		return
	end try
	if printerName = "" then
		activate
		display dialog "No default printer found." buttons {"OK"}
	end if
	
	try
		set queueNames to (do shell script "lpstat -a | grep accepting | cut -f1 -d\" \" ")
	on error err
		display dialog err
	end try
	
	try
		tell application "Bonjour Events 2.1"
			if (exists browser "MyBrowser") then
				set IPPBrowser to browser "MyBrowser"
			else
				set IPPBrowser to make new browser with properties {name:"MyBrowser"}
			end if
			tell IPPBrowser
				scan for type "_printer._tcp" in domain "local"
				if (count services) > 0 then
					set nameList to name of services
					-- set addressList to IPv4 address of services
				else
					set nameList to {}
					-- set addressList to {}
				end if
				quit
				-- Bonjour Events quits automatically after 2 minutes of inactivity
			end tell
		end tell
	on error errorMessage number errorNumber
		display dialog "An error occurred: " & errorMessage & " (" & errorNumber & ")"
	end try
	
	set dnsURL to do shell script "lpstat -v " & printerName
	set dnsString to (do shell script "perl -e 'use URI::Escape; print uri_unescape(\"" & dnsURL & "\")';")
	
	set ipPrinterFound to false
	repeat with currentItem in nameList
		if currentItem is in dnsString then
			set ipPrinterFound to true
			exit repeat
		end if
	end repeat
	
	activate
	if ipPrinterFound is false then
		display dialog "The default printer" & return & return & printerName & return & return & "seems to be offline." buttons {"OK"} with title msgTitle
	else
		try
		do shell script "lpr -r" & space & pdfPosix
		on error err
			tell application "System Events"
			activate
			display dialog err
			end tell
		end try
	end if

	try
		do shell script "rm" & space & pdfPosix	
	end try
	
end run

EndOfScript

exit
