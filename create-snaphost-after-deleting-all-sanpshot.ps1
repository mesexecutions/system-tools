# Define the list of VM names
$vmNames = "VBRKYOPS01", "VBRKYHUB01"
# Specify the description for the new snapshot
$snapshotDescription = "Node Exporter Deployed, Connected to Prometheus, Default Gateway Disabled"

# Set to $true if you want to power on the VM after snapshot operations
$powerOnVM = $false

# Get the date in the desired format
$FormattedDate = Get-Date -Format 'ddMMMyyyy_HHmm'

# Output the formatted date for debugging
Write-Host "Formatted Date: $FormattedDate"

# Convert to uppercase
$SnapshotName = $FormattedDate.ToUpper()

# Loop through the list of VMs and perform the operations

foreach ($vmName in $vmNames) {

    Write-Host "Working on VM $vmName..."

    # Check if the VM is running and power off if needed
    $vmStatus = & "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" showvminfo $vmName --machinereadable | Select-String -Pattern 'VMState="running"'
    
    if ($vmStatus) {
        Write-Host "VM $vmName is running. Powering off..."
        & "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm $vmName poweroff
    }

    # Get the list of snapshots for the VM
    $snapshots = & "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" snapshot $vmName list --machinereadable
    $snapshotNames = $snapshots | Select-String -Pattern 'SnapshotName="(.+?)"' | ForEach-Object { $_.Matches.Groups[1].Value }

    # Delete all existing snapshots
    foreach ($snapshot in $snapshotNames) {
        Write-Host "Deleting snapshot '$snapshot' on VM $vmName..."
        & "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" snapshot $vmName delete "$snapshot"
    }

    # Take a new snapshot with description
    Write-Host "Taking a new snapshot '$snapshotName' with description '$snapshotDescription' on VM $vmName..."
    & "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" snapshot $vmName take "$snapshotName" --description "$snapshotDescription"

    # Power on the VM if specified
    if ($powerOnVM) {
        Write-Host "Powering on VM $vmName..."
        & "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" startvm $vmName --type headless
    }
}

# Print or use the generated snapshot name
Write-Host "Generated Snapshot Name: $snapshotName"