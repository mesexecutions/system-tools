# Define VM lists
$vmNames = "VBRHELHYB03", "VBRHELHYB04", "VBRHELHYB05"
# $VMList = "VBRHELHYB01", "VBRHELHYB02", "VBRHELANS02", "VBRHELMON01"

# Function to power on a VM using VBoxManage.exe
function PowerOn-VM {
    param (
        [string]$VMName
    )

    # Check if the VM is already running
    $vmStatus = & "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" showvminfo $VMName --machinereadable | Select-String -Pattern 'VMState="running"'
    
    if ($vmStatus) {
        Write-Host "VM $VMName is already running."
    }
    else {
        Write-Host "Powering on VM: $VMName"
        & "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" startvm $VMName --type headless
    }
}

# Specify the VM list to power on
$vmlisttopoweron = $vmNames

# Loop through the VM list and power on each VM
foreach ($vm in $vmlisttopoweron) {
    PowerOn-VM -VMName $vm
}

Write-Host "Power-on process completed for the specified VMs."