param(
[string]$fn
)

Clear-Host

$printers = Get-Printer
$menu = @{}
for ($i=1;$i -le $printers.count; $i++) {
    Write-Host "$i. $($printers[$i-1].name)" 
    $menu.Add($i,($printers[$i-1].name))
    } 
[int]$ans = Read-Host 'Select a printer for this document'
$selection = $menu.Item($ans)
$choice = Get-Printer $selection

Clear-Host

Start-Process -FilePath $fn -Verb PrintTo("$selection") -PassThru | %{sleep 10;$_} | kill

exit
