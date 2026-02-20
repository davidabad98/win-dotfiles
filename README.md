# Windows Dotfiles

![Windows](https://img.shields.io/badge/Windows-0078D6?style=flat&logo=windows&logoColor=white)
![PowerShell](https://img.shields.io/badge/PowerShell-7-5391FE?style=flat&logo=powershell&logoColor=white)

A centralized repository for managing Windows configuration files (dotfiles) using symbolic links. This makes it easy to version control your configs, sync them across machines, and maintain consistent development environments.

## Features

- **Automatic Symlink Management**: Creates symbolic links from your system config locations to this repository
- **Smart Conflict Detection**: Automatically detects existing symlinks and skips them if already correct
- **Automatic Backups**: Backs up existing configurations before replacing them
- **Selective Installation**: Choose which configs to install, or install everything at once
- **Safe to Re-run**: Won't break or duplicate symlinks if you run the script multiple times
- **Color-Coded Feedback**: Clear visual feedback during installation

## What's Included

This repository manages configurations for:

| Config | Source in Repo | Target Location | Purpose |
|--------|---------------|-----------------|---------|
| **Neovim** | `nvim/` | `$env:LOCALAPPDATA\nvim` | Complete Neovim setup with LSP, plugins, and keybindings |
| **VsVim** | `vsvim/.vimrc` | `$HOME\.vimrc` | Vim keybindings for Visual Studio 2022 |
| **LazyGit** | `lazygit/config.yml` | `$env:LOCALAPPDATA\lazygit\config.yml` | LazyGit UI theme and settings |
| **GlazeWM** | `glazewm/config.yaml` | `$HOME\.glzr\glazewm\config.yaml` | GlazeWM tiling window manager configuration |

## Requirements

- **Windows 10/11**
- **PowerShell 7+** (required for proper symlink support)
- **Administrator privileges** (needed to create symbolic links)
- **Git** (to clone this repository)

## Quick Start

### Initial Setup (New Machine)

1. **Clone this repository** to your home directory:
   ```powershell
   cd ~
   git clone https://github.com/yourusername/win-dotfiles.git
   ```

2. **Run PowerShell as Administrator**

3. **Run the bootstrap script** to install all configurations:
   ```powershell
   cd ~\win-dotfiles
   .\bootstrap-windows.ps1
   ```

That's it! All your configurations are now symlinked and ready to use.

## Usage

### Install All Configurations

```powershell
.\bootstrap-windows.ps1
```

### Install Specific Configurations

Install only Neovim:
```powershell
.\bootstrap-windows.ps1 -Nvim
```

Install multiple specific configs:
```powershell
.\bootstrap-windows.ps1 -Nvim -VsVim
```

### View Help

```powershell
.\bootstrap-windows.ps1 -Help
```

### Safe to Re-run

The script is completely safe to run multiple times. It will:
- Skip symlinks that already exist and point to the correct location
- Back up any existing files before creating new symlinks
- Never overwrite or corrupt your existing configurations

## Repository Structure

```
win-dotfiles/
├── nvim/                      # Neovim configuration
│   ├── init.lua              # Main Neovim config entry point
│   ├── lua/
│   │   ├── plugins/          # Plugin configurations
│   │   ├── lsp/              # LSP server configs
│   │   ├── configs/          # Additional configurations
│   │   └── vim-options.lua   # Vim settings
│   └── lazy-lock.json        # Plugin version lockfile
│
├── vsvim/                     # Visual Studio VsVim
│   └── .vimrc                # VsVim configuration
│
├── lazygit/                   # LazyGit
│   └── config.yml            # LazyGit theme and settings
│
├── glazewm/                   # GlazeWM window manager
│   └── config.yaml           # GlazeWM configuration
│
├── bootstrap-windows.ps1      # Installation script
└── README.md                  # This file
```

## Adding New Configurations

Want to add a new tool's configuration to this repository? Here's how:

### Step 1: Create a Directory Structure

Create a new directory in the repo for your config:
```powershell
cd ~\win-dotfiles
mkdir new-tool
```

### Step 2: Add Your Configuration Files

Copy your config files into the new directory:
```powershell
Copy-Item "$env:APPDATA\new-tool\config.json" "new-tool\config.json"
```

### Step 3: Update the Bootstrap Script

Open `bootstrap-windows.ps1` and add a new function following this template:

```powershell
# Add a new parameter at the top
param(
    [string]$DotfilesRoot = "$HOME\win-dotfiles",
    [switch]$Nvim,
    [switch]$VsVim,
    [switch]$LazyGit,
    [switch]$NewTool,  # <-- Add this
    [switch]$Help
)

# Add a new function for your tool
function Install-NewTool {
    Write-Host "`n[NewTool]" -ForegroundColor Cyan
    
    $newToolDotfiles = Join-Path $DotfilesRoot "new-tool\config.json"
    $newToolConfig   = "$env:APPDATA\new-tool\config.json"
    
    if (Test-SymlinkCorrect -Path $newToolConfig -Target $newToolDotfiles) {
        Write-Host "  Symlink already exists and is correct, skipping..." -ForegroundColor Green
        return
    }
    
    # Create parent directory if needed
    $parentDir = Split-Path $newToolConfig -Parent
    if (-not (Test-Path $parentDir)) {
        Write-Host "  Creating directory: $parentDir" -ForegroundColor Yellow
        New-Item -ItemType Directory -Path $parentDir | Out-Null
    }
    
    if (Test-Path $newToolConfig) {
        $backup = "$($newToolConfig)_backup_$(Get-Date -Format yyyyMMddHHmmss)"
        Write-Host "  Backing up existing config to: $backup" -ForegroundColor Yellow
        Rename-Item $newToolConfig $backup
    }
    
    Write-Host "  Creating symlink: $newToolConfig -> $newToolDotfiles" -ForegroundColor Green
    New-Item -ItemType SymbolicLink -Path $newToolConfig -Target $newToolDotfiles | Out-Null
    Write-Host "  Done!" -ForegroundColor Green
}

# Update the main execution block
if ($installAll) {
    Write-Host "`nInstalling all configurations..." -ForegroundColor White
    Install-Neovim
    Install-VsVim
    Install-LazyGit
    Install-NewTool  # <-- Add this
} else {
    Write-Host "`nInstalling selected configurations..." -ForegroundColor White
    if ($Nvim) { Install-Neovim }
    if ($VsVim) { Install-VsVim }
    if ($LazyGit) { Install-LazyGit }
    if ($NewTool) { Install-NewTool }  # <-- Add this
}
```

### Step 4: Update the Help Function

Add documentation for your new parameter in the `Show-Help` function:

```powershell
PARAMETERS:
    -Nvim       Create symlink for Neovim configuration
                Links: $env:LOCALAPPDATA\nvim -> win-dotfiles\nvim

    -VsVim      Create symlink for Visual Studio VsVim configuration
                Links: $HOME\.vimrc -> win-dotfiles\vsvim\.vimrc

    -LazyGit    Create symlink for LazyGit configuration
                Links: $env:LOCALAPPDATA\lazygit\config.yml -> win-dotfiles\lazygit\config.yml

    -NewTool    Create symlink for NewTool configuration
                Links: $env:APPDATA\new-tool\config.json -> win-dotfiles\new-tool\config.json
```

### Step 5: Update the README

Add an entry to the "What's Included" table in this README.

### Step 6: Test It

Run the bootstrap script to test your new configuration:
```powershell
.\bootstrap-windows.ps1 -NewTool
```

### Step 7: Commit and Push

```powershell
git add .
git commit -m "Add NewTool configuration"
git push
```

## Uninstall

To remove the symlinks and restore your original configurations:

### Option 1: Manual Removal

Delete the symlinks manually (they won't delete the actual files in this repo):

```powershell
# Remove Neovim symlink
Remove-Item "$env:LOCALAPPDATA\nvim"

# Remove VsVim symlink
Remove-Item "$HOME\.vimrc"

# Remove LazyGit symlink
Remove-Item "$env:LOCALAPPDATA\lazygit\config.yml"

# Remove GlazeWM symlink
Remove-Item "$HOME\.glzr\glazewm\config.yaml"
```

### Option 2: Restore Backups

If you want to restore your original configs that were backed up:

```powershell
# Find your backups (they have timestamps)
Get-ChildItem "$env:LOCALAPPDATA" -Filter "*_backup_*"
Get-ChildItem "$HOME" -Filter "*_backup_*"

# Restore a backup (example)
Remove-Item "$HOME\.vimrc"
Rename-Item "$HOME\.vimrc_backup_20240220123456" "$HOME\.vimrc"
```

## How Symlinks Work

A **symbolic link** (symlink) is like a shortcut that programs treat as if it were the actual file or folder. When you edit a config file through a symlink, you're actually editing the file in this repository.

**Benefits:**
- Changes to configs are automatically version controlled
- Easy to sync across multiple machines
- Can revert changes using Git
- Keep all your configs organized in one place

## Troubleshooting

### "Access Denied" Error

You need to run PowerShell as Administrator to create symbolic links.

### Symlink Points to Wrong Location

Run the bootstrap script again - it will detect the incorrect symlink, back it up, and create a new one pointing to the correct location.

### Config Not Loading

Make sure the application is looking for configs in the expected location. Some applications allow you to customize config paths.

### PowerShell Version Too Old

Check your PowerShell version:
```powershell
$PSVersionTable.PSVersion
```

If it's less than 7.0, download PowerShell 7+ from the [official repository](https://github.com/PowerShell/PowerShell/releases).

## License

This repository contains personal configuration files. Feel free to use, modify, and adapt them for your own needs.

---

**Happy configuring!** If you have questions or run into issues, feel free to open an issue on this repository.
