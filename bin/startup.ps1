# Working with Terminal, Tabs, and Panes: https://learn.microsoft.com/en-us/windows/terminal/command-line-arguments
# Quake Mode: https://learn.microsoft.com/en-us/windows/terminal/tips-and-tricks#quake-mode
# For more info on Default Apps: 
# See "App execution aliases" in Settings
$startupLocation = Get-Location;

# Add the necessary .NET assembly for Windows Forms
Add-Type -AssemblyName System.Windows.Forms

$installed = winget ls

$count = 0
foreach ($app in $installed) {
  $count = $count + 1
}

# Show a popup prompt
$Title = "IMGNX winget packages"
$Message = "There are $count apps installed."
$Form = New-Object System.Windows.Forms.Form
$Form.TopMost = $true

[System.Windows.Forms.MessageBox]::Show($Form, $Message, $Title, [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)

# $Message = "The current location is: $startupLocation.Path"
# [System.Windows.Forms.MessageBox]::Show($Form, $Message, $Title, [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)

# New-BurntToastNotification -Text "Hello from PowerShell!", "The current location is: $startupLocation.Path"
# Start-Sleep 10
# return 0;

wt -w 0 -p PowerShell sudo netstat -abfiq 1; 

# wt -w 0 sp -V -p PowerShell -c pwsh.exe ./ps.ps1;
Set-Location $startupLocation

# # GameBarElevatedFT_Alias.exe
# Set-Location "C:\Program Files\Corsair\Corsair iCUE5 Software\"
# ./iCUE.exe

# Set-Location $startupLocation
