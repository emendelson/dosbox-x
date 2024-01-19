param(
[string]$fn
)

Clear-Host

# Load Windows Forms and drawing libraries
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Select a Printer'
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = 'CenterScreen'

# Add a label
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,10)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Please select a printer:'
$form.Controls.Add($label)

# Add a list box
$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(10,40)
$listBox.Size = New-Object System.Drawing.Size(260,100)
$form.Controls.Add($listBox)


# Populate the list box with printer names
$printers = Get-Printer | Select-Object -ExpandProperty Name

# Check if no printers installed
if ($printers.Count -eq 0) {
		[System.Windows.Forms.MessageBox]::Show('No printers are installed.', 'DOSBox-X Printing')
    Write-Host "No printers are installed."
    exit
}

# Finish populating list box
foreach ($printer in $printers) {
    $listBox.Items.Add($printer)
}

# Add a button
$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(10,150)
$button.Size = New-Object System.Drawing.Size(100,20)
$button.Text = 'OK'
$form.Controls.Add($button)

# Add button click event
$button.Add_Click({
    $script:selectedPrinter = $listBox.SelectedItem
    $form.Close()
})

# Show the form
$form.Add_Shown({$form.Activate()})
[void] $form.ShowDialog()

# Output the selected printer
if ($global:selectedPrinter) {
    Write-Host "Selected printer: $selectedPrinter"
    # [System.Windows.Forms.MessageBox]::Show("$selectedPrinter", 'DOSBox-X Printing')
} else {
    Write-Host "No printer selected."
}

Start-Process -FilePath $fn -Verb PrintTo "$selectedPrinter" -PassThru | %{sleep 10;$_} | kill 

exit
