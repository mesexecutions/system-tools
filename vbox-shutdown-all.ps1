# Define the list of VM names in the desired order
# $vmNames = "VBRHELHYB01", "VBRHELHYB02", "VBRHELHYB03", "VBRHELHYB04", "VBRHELHYB05", "VBRHELANS01", "VBRHELANS02"
$vmNames = "VBRHELHYB03", "VBRHELHYB04", "VBRHELHYB05"

# Loop through the list of VMs and shut them down in order
foreach ($vmName in $vmNames) {
    Write-Host "Shutting down VM $vmName..."
    & "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm $vmName acpipowerbutton
}

Write-Host "All VMs have been shut down in order."