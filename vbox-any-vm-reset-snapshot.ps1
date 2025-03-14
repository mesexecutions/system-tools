# Define the list of VM names
# $vmNames = "VBRHELHYB03", "VBRHELHYB04", "VBRHELHYB05"
$vmNames = "VBFEDOPS01"

# Specify the snapshot name as a variable
$snapshotName = "TILL-NFTABLES-SSH-ALLOW-ONLY"
# $snapshotName = "BASE_BEFORE_PYTHON"


# Loop through the list of VMs and perform the operations
foreach ($vmName in $vmNames) {
    Write-Host "Working on VM $vmName..."

    # Get the VM status
    $vmStatus = & "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" showvminfo $vmName --machinereadable
    $vmState = $vmStatus | Select-String -Pattern 'VMState="(.+?)"' | ForEach-Object { $_.Matches.Groups[1].Value }

    # Check if the VM is running and stop it if it is
    if ($vmState -eq "running") {
        Write-Host "Stopping VM $vmName..."
        & "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm $vmName poweroff
    }

    # Revert to the specified snapshot
    Write-Host "Reverting to snapshot '$snapshotName' on VM $vmName..."
    & "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" snapshot $vmName restore "$snapshotName"

    # Start the VM in headless mode
    Write-Host "Starting VM $vmName..."
    & "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" startvm $vmName --type headless
}

Write-Host "All VM operations completed."