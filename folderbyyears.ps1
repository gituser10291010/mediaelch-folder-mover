# Script to sort folders into year-based directories based on year in parentheses

# Function to sanitize path and check for invalid characters
function Test-ValidPath {
    param (
        [string]$path
    )
    
    try {
        # Only check for truly invalid characters, not the full path
        $invalidChars = [IO.Path]::GetInvalidFileNameChars()
        $fileName = Split-Path $path -Leaf
        $invalidCharsFound = $fileName.IndexOfAny($invalidChars) -ge 0
        
        return -not $invalidCharsFound
    }
    catch {
        Write-Host "Error validating path: $path" -ForegroundColor Red
        return $false
    }
}

# Function to extract year from folder name with validation
function Get-YearFromFolderName {
    param (
        [string]$folderName
    )
    
    try {
        if ($folderName -match '\((\d{4})\)$') {
            $year = $matches[1]
            # Validate year is reasonable (e.g., between 1900 and 2100)
            $yearNum = [int]$year
            if ($yearNum -ge 1900 -and $yearNum -le 2100) {
                return $year
            }
        }
    }
    catch {
        Write-Host "Error parsing year from folder: $folderName" -ForegroundColor Red
    }
    return $null
}

# Function to ensure the destination path exists
function Ensure-PathExists {
    param (
        [string]$path
    )
    
    if (-not (Test-Path -Path $path)) {
        New-Item -Path $path -ItemType Directory | Out-Null
        Write-Host "Created directory: $path" -ForegroundColor Green
    }
}

try {
    # Get root folder path from user
    $rootPath = Read-Host "Please enter the root folder path (e.g., C:\Movies)"

    # Validate root path exists
    if (-not (Test-Path -Path $rootPath)) {
        throw "The specified root path does not exist: $rootPath"
    }

    # Create or ensure 'years' subfolder exists
    $yearsPath = Join-Path -Path $rootPath -ChildPath "years"
    Ensure-PathExists -path $yearsPath

    # Get all subfolders in root directory
    $subfolders = Get-ChildItem -Path $rootPath -Directory | 
                 Where-Object { $_.Name -ne "years" }  # Exclude the years folder

    $totalFolders = ($subfolders | Measure-Object).Count
    $processedCount = 0
    $successCount = 0
    $skipCount = 0

    # Process each subfolder
    foreach ($folder in $subfolders) {
        $processedCount++
        $percentComplete = ($processedCount / $totalFolders) * 100
        
        Write-Progress -Activity "Processing Folders" -Status "Processing: $($folder.Name)" `
                      -PercentComplete $percentComplete

        # Validate folder name
        if (-not (Test-ValidPath -path $folder.Name)) {
            Write-Host "Warning: Folder name contains invalid characters: $($folder.Name)" -ForegroundColor Yellow
            $skipCount++
            continue
        }

        # Extract year from folder name
        $year = Get-YearFromFolderName -folderName $folder.Name

        if ($year) {
            # Create year folder if it doesn't exist
            $yearPath = Join-Path -Path $yearsPath -ChildPath $year
            Ensure-PathExists -path $yearPath

            # Construct destination path
            $destinationPath = Join-Path -Path $yearPath -ChildPath $folder.Name

            # Check if destination already exists
            if (Test-Path -Path $destinationPath) {
                Write-Host "Warning: Destination already exists: $destinationPath" -ForegroundColor Yellow
                $newName = "$($folder.Name)_$(Get-Random)"
                $destinationPath = Join-Path -Path $yearPath -ChildPath $newName
                Write-Host "Renaming to: $newName" -ForegroundColor Yellow
            }

            # Move the folder
            try {
                Move-Item -Path $folder.FullName -Destination $destinationPath -ErrorAction Stop
                Write-Host "Moved '$($folder.Name)' to year $year" -ForegroundColor Green
                $successCount++
            }
            catch {
                Write-Host "Error moving '$($folder.Name)': $_" -ForegroundColor Red
                $skipCount++
            }
        }
        else {
            Write-Host "No valid year found in folder name: $($folder.Name)" -ForegroundColor Yellow
            $skipCount++
        }
    }

    Write-Progress -Activity "Processing Folders" -Completed
    Write-Host "`nProcess completed!" -ForegroundColor Green
    Write-Host "Summary:" -ForegroundColor Cyan
    Write-Host "Total folders processed: $totalFolders" -ForegroundColor Cyan
    Write-Host "Successfully moved: $successCount" -ForegroundColor Green
    Write-Host "Skipped/Failed: $skipCount" -ForegroundColor Yellow
}
catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
    Write-Host "Stack Trace: $($_.ScriptStackTrace)" -ForegroundColor Red
}