param(
[string]$fn
)

Add-Type -AssemblyName System.Windows.Forms | Out-Null

# Get the list of installed printers
$printers = Get-Printer | Select-Object -Property Name

# Check if there are any printers installed
if ($printers.Count -eq 0) {
		[System.Windows.Forms.MessageBox]::Show('No printers are installed.', 'DOSBox-X Printing')
    Write-Host "No printers are installed."
    exit
}

Start-Process -FilePath $fn -Verb Print -PassThru | %{sleep 10;$_} | kill

exit