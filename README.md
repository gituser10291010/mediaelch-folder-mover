# Folder Organizer by Years

A PowerShell script that automatically organizes folders into year-based directories by extracting year information from folder names with parentheses notation.

## Overview

This script scans a root directory for subfolders containing years in parentheses (e.g., "Movie Title (2023)") and automatically moves them into organized year subdirectories under a "years" folder. It's particularly useful for organizing media collections, project archives, or any folder structure where year-based organization is desired.

## Features

- **Automatic Year Detection**: Extracts years from folder names using regex pattern `(YYYY)`
- **Safe Path Validation**: Checks for invalid characters and validates paths before moving
- **Year Range Validation**: Only processes years between 1900-2100 to avoid false matches
- **Progress Tracking**: Real-time progress bar showing processing status
- **Duplicate Handling**: Automatically renames folders if destination already exists
- **Comprehensive Error Handling**: Graceful handling of file system errors with detailed reporting
- **Summary Statistics**: Displays completion summary with success/failure counts

## Prerequisites

- Windows PowerShell 5.1 or PowerShell Core 6+
- Appropriate file system permissions for the target directory
- Windows operating system (uses Windows-specific path validation)

## Installation

1. Download the `folderbyyears.ps1` script
2. Place it in your desired location
3. Ensure PowerShell execution policy allows script execution:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

## Usage

### Basic Usage

1. Run the script:
   ```powershell
   .\folderbyyears.ps1
   ```

2. When prompted, enter the root folder path:
   ```
   Please enter the root folder path (e.g., C:\Movies): C:\MyMovies
   ```

### Example Directory Structure

**Before:**
```
C:\Movies\
├── The Matrix (1999)\
├── Inception (2010)\
├── Blade Runner 2049 (2017)\
├── The Godfather (1972)\
└── Avatar (2009)\
```

**After:**
```
C:\Movies\
├── years\
│   ├── 1972\
│   │   └── The Godfather (1972)\
│   ├── 1999\
│   │   └── The Matrix (1999)\
│   ├── 2009\
│   │   └── Avatar (2009)\
│   ├── 2010\
│   │   └── Inception (2010)\
│   └── 2017\
│       └── Blade Runner 2049 (2017)\
```

## How It Works

1. **Input Validation**: Verifies the root path exists and is accessible
2. **Year Folder Creation**: Creates a "years" subfolder in the root directory
3. **Folder Scanning**: Identifies all subdirectories (excluding the "years" folder)
4. **Year Extraction**: Uses regex to find year patterns in format `(YYYY)`
5. **Path Validation**: Checks for invalid filename characters
6. **Year Validation**: Ensures extracted year is within reasonable range (1900-2100)
7. **Directory Organization**: Creates year subdirectories and moves folders accordingly
8. **Conflict Resolution**: Handles duplicate destinations by appending random suffixes

## Supported Folder Name Formats

✅ **Supported:**
- `Movie Title (2023)`
- `Project Name (1995)`
- `Document Archive (2001)`

❌ **Not Supported:**
- `Movie Title 2023` (no parentheses)
- `Movie Title (23)` (2-digit year)
- `Movie Title (Year 2023)` (additional text in parentheses)
- Folders with invalid filename characters

## Error Handling

The script handles various error scenarios:

- **Invalid root paths**: Validates existence before processing
- **Invalid characters**: Skips folders with filesystem-invalid characters
- **Duplicate destinations**: Automatically renames with random suffix
- **File system errors**: Catches and reports move operation failures
- **Invalid years**: Skips folders with years outside 1900-2100 range

## Output Messages

- 🟢 **Green**: Successful operations and directory creations
- 🟡 **Yellow**: Warnings for skipped folders or renamed duplicates
- 🔴 **Red**: Errors during processing
- 🔵 **Cyan**: Summary information

## Limitations

- Only processes folders with years in parentheses at the end of the name
- Designed for Windows file systems
- Requires appropriate permissions for moving folders
- Does not process nested subdirectories (only direct children of root)
- Year range limited to 1900-2100

## Safety Features

- **Non-destructive**: Only moves folders, doesn't delete anything
- **Validation**: Multiple validation layers prevent invalid operations
- **Backup-friendly**: Original folder structure preserved in year-based organization
- **Conflict resolution**: Never overwrites existing folders

## Troubleshooting

### Common Issues

**"Execution policy" error:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**"Path does not exist" error:**
- Verify the path is correct and accessible
- Check for proper drive letter and directory separators

**Folders not being moved:**
- Ensure folder names contain years in format `(YYYY)`
- Check that years are within 1900-2100 range
- Verify folder names don't contain invalid characters

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly with different folder structures
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Author

Created for organizing folder structures with year-based classification needs.

---

**Note**: Always test on a backup copy of your data before running on important folders.
