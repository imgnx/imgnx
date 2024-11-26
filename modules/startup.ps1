# startup.ps1
# Example of a startup script for PowerShell.
# Author: Donald Moore (@imgnx/@imgnxtion)

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

$shell = sudo wt -w 0 -p "powershell_ise" netstat -abfiq 1;

if (! $shell) {
  sudo powershell_ise.exe netstat -abfiq 1;
}

wt -w 0 sp -V -p "powershell_ise" -d $startupLocation;

powershell_ise.exe code I:\IMGNX\bin\editwsl.ps1

# wt -w 0 sp -V -p PowerShell -c pwsh.exe ./ps.ps1;
Set-Location $startupLocation
