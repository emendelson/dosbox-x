#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Run_After=d:\dropbox\signfilesem.exe "%out%"
#include <Array.au3>
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <FileConstants.au3>
#include <Constants.au3>
#include <WinAPI.au3>
#include <File.au3>

Global $gh

$qt = Chr(34)
$space = " "
$t = ""
$mydir = @ScriptDir

Local $cmln = $CmdLine[0] ;Total commandline parameters entered.
If $cmln = 0 Then    ;If no paramters given
	MsgBox(0, "DOSBox-X Printing", "Filename required.")
	Exit
EndIf


If $cmln = 1 Then
	If FileExists($CmdLine[1]) Then
		$outpdf= $CmdLine[1]
	Else
		MsgBox(0, $t, "File not found: " & $outpdf)
		Exit
	EndIf
EndIf

$outpdf = $qt & _PathFull($outpdf) & $qt

;;;;;;;;;;;;;;;;;;;;
; MsgBox(0,'', $outpdf)

$ptrselmsg = "Select a printer for this document"
$printername = 0
GetPrinter($ptrselmsg)
Do
	Sleep(100)
Until $printername
$noprinter = 0 ;; not needed - replace with dialog below
If $printername = "nul" Then
	$noprinter = 1  ;; not needed - replace with dialog
	Exit
EndIf

$printexe = "PDFXCview.exe"
$printtostring = " " & "/printto: " & $qt & $printername & $qt & " "

FileChangeDir(@ScriptDir)
If NOT @Compiled Then ConsoleWrite($printexe & " " & $printtostring & " " & $outpdf & @CRLF)
; MsgBox(0,'', $printexe & " " & $printtostring & " " & $outpdf)

RunWait(@ComSpec & " /c " & $printexe & " " & $printtostring & " " & $outpdf, @ScriptDir, @SW_HIDE)

FileDelete($outpdf)

Exit

Func GetPrinter($ptrselmsg)
	Global $printer_list[1]
	Global $printer_list_ext[1]
	Global $printer_radio_array[1]
	; $printer_list = 0
	; $printer_list_ext = 0
	; $printer_radio_array = 0
	$regprinters = "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Devices"
	$currentprinter = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Windows\", "Device")
	$defaultprinter = StringLeft($currentprinter, StringInStr($currentprinter, ",") - 1)
	Dim $i = 1
	Dim $error_reg = False
	While Not $error_reg
		$theprinter = RegEnumVal($regprinters, $i)
		$error_reg = @error
		If Not $error_reg Then
			_ArrayAdd($printer_list, $theprinter)
			_ArrayAdd($printer_list_ext, $theprinter & "," & RegRead($regprinters, $theprinter))
		EndIf
		$i = $i + 1
	WEnd
	_ArrayDelete($printer_list, 0)
	_ArrayDelete($printer_list_ext, 0)
	If UBound($printer_list) = 0 Then
		MsgBox(0, "", "No printers found.")
		Exit
	EndIf
	If UBound($printer_list) >= 2 Then ;if 2 or more printers available, we show the dialog
		Dim $groupheight = (UBound($printer_list) + 1) * 25 ;30
		Dim $guiheight = $groupheight + 50
		Dim $buttontop = $groupheight + 20
		Opt("GUIOnEventMode", 1)
		$gh = GUICreate($ptrselmsg, 400, $guiheight)
		Dim $font = "Verdana"
		GUISetFont(10, 400, 0, $font)
		GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
		GUISetFont(10, 400, 0, $font)
		GUICtrlCreateGroup("Available printers:", 10, 10, 380, $groupheight)
		Dim $position_vertical = 5 ; 0
		For $i = 0 To UBound($printer_list) - 1 Step 1
			GUISetFont(10, 400, 0, $font)
			$position_vertical = $position_vertical + 25 ;30
			$radio = GUICtrlCreateRadio($printer_list[$i], 20, $position_vertical, 350, 20)
			_ArrayAdd($printer_radio_array, $radio)
			If $currentprinter = $printer_list_ext[$i] Then
				GUICtrlSetState($radio, $GUI_CHECKED)
			EndIf
		Next
		_ArrayDelete($printer_radio_array, 0)
		GUISetFont(10, 400, 0, $font)
		$okbutton = GUICtrlCreateButton("OK", 10, $buttontop, 50, 25)
		GUICtrlSetOnEvent($okbutton, "OKButton")
		Local $AccelKeys[2][2] = [["{ENTER}", $okbutton], ["^O", $okbutton]]
		GUISetAccelerators($AccelKeys)
		GUISetState()
	EndIf
EndFunc   ;==>GetPrinter

Func GetDefaultPrinter()
	$currentprinter = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Windows\", "Device")
	$defaultprinter = StringLeft($currentprinter, StringInStr($currentprinter, ",") - 1)
	If $defaultprinter = "" Then $defaultprinter = 0
EndFunc   ;==>GetDefaultPrinter

Func CLOSEClicked()
	;$printername = $defaultprinter
	GUIDelete($gh)
	; Cancelled() ; MsgBox(0, "", $printername)
	; Return $printername
	; next two added 8 Dec 2012
	$printername = "nul"
	ConsoleWrite($printername & @LF)
EndFunc   ;==>CLOSEClicked

Func Cancelled()

	MsgBox(262144, $t, "Script cancelled.")

	Exit
EndFunc   ;==>Cancelled

Func OKButton()
	For $i = 0 To UBound($printer_radio_array) - 1 Step 1
		If GUICtrlRead($printer_radio_array[$i]) = 1 Then
			$printername = StringLeft($printer_list_ext[$i], StringInStr($printer_list_ext[$i], ",") - 1)
		EndIf
	Next
	GUIDelete($gh)
	; MsgBox(0, "", $printername)
	ConsoleWrite($printername & @LF)
EndFunc   ;==>OKButton
