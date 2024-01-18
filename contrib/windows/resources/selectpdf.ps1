param(
[string]$fn
)

Clear-Host

<#
$printers = Get-Printer
$menu = @{}
for ($i=1;$i -le $printers.count; $i++) {
    Write-Host "$i. $($printers[$i-1].name)" 
    $menu.Add($i,($printers[$i-1].name))
    } 
[int]$ans = Read-Host 'Select a printer for this document'
$selection = $menu.Item($ans)
$choice = Get-Printer $selection
#>

# Get the list of installed printers
$printers = Get-Printer | Select-Object -Property Name

# Check if there are any printers installed
if ($printers.Count -eq 0) {
    Write-Host "No printers are installed."
    exit
}

# Display the list of printers and prompt the user to select one
$selection = $printers | Out-GridView -Title "Select a printer for this document" -PassThru

# Check if the user made a selection
if ($null -eq $selection) {
    Write-Host "No printer selected."
} else {
    Write-Host "You selected: $($selection.Name)"
}

Clear-Host

Start-Process -FilePath $fn -Verb PrintTo("$($selection.Name)") -PassThru | %{sleep 10;$_} | kill

exit
