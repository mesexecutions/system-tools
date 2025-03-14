# Set source and destination paths
$SourceFile = "G:\My Drive\Storage\my_drive\personal_artifacts\Master.xlsm"
$DestinationFolder = "Z:\my_drive\data_backups\pc\master"

# Extract the source file's name and extension
$FileName = [System.IO.Path]::GetFileNameWithoutExtension($SourceFile)
$FileExtension = [System.IO.Path]::GetExtension($SourceFile)

# Create a timestamp in the format YYYYMMDD_HH-MM-SS
$Timestamp = (Get-Date).ToString("yyyyMMdd_HH-mm-ss")

# Construct the destination file name in the desired format
$NewFileName = "$Timestamp`_$FileName$FileExtension"

# Combine the destination folder and the new file name
$DestinationFile = Join-Path -Path $DestinationFolder -ChildPath $NewFileName

# Debugging Outputs (to verify final file path)
Write-Output "Final Destination File Path: $DestinationFile"

# Copy the file to the destination folder with the new name
Copy-Item -Path $SourceFile -Destination $DestinationFile -Force

# Output confirmation
Write-Output "File copied successfully to: $DestinationFile"