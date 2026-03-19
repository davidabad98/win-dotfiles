param(
    [string]$DotfilesRoot = $PSScriptRoot,
    [switch]$Nvim,
    [switch]$VsVim,
    [switch]$LazyGit,
    [switch]$GlazeWM,
    [switch]$OpenCode,
    [switch]$WindowsTerminal,
    [switch]$Help
)

function Show-Help {
    Write-Host @"

Windows Dotfiles Bootstrap Script
==================================

USAGE:
    .\bootstrap-windows.ps1 [-Nvim] [-VsVim] [-LazyGit] [-GlazeWM] [-OpenCode] [-WindowsTerminal] [-Help]

PARAMETERS:
    -Nvim       Create symlink for Neovim configuration
                Links: `$env:LOCALAPPDATA\nvim -> win-dotfiles\nvim

    -VsVim      Create symlink for Visual Studio VsVim configuration
                Links: `$HOME\.vimrc -> win-dotfiles\vsvim\.vimrc

    -LazyGit    Create symlink for LazyGit configuration
                Links: `$env:LOCALAPPDATA\lazygit\config.yml -> win-dotfiles\lazygit\config.yml

    -GlazeWM    Create symlink for GlazeWM window manager configuration
                Links: `$HOME\.glzr\glazewm\config.yaml -> win-dotfiles\glazewm\config.yaml

    -OpenCode   Create symlink for OpenCode configuration
                Links: `$HOME\.config\opencode\opencode.jsonc -> win-dotfiles\opencode\opencode.jsonc

    -WindowsTerminal  Create symlink for Windows Terminal configuration
                Links: `$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_*\LocalState\settings.json
                       -> win-dotfiles\terminal\settings.json
                Note: Package path is resolved dynamically via Get-AppxPackage

    -Help       Display this help message

EXAMPLES:
    # Install all dotfiles (default behavior)
    .\bootstrap-windows.ps1

    # Install only Neovim configuration
    .\bootstrap-windows.ps1 -Nvim

    # Install multiple specific configurations
    .\bootstrap-windows.ps1 -Nvim -VsVim

NOTES:
    - Run with Administrator privileges to create symbolic links
    - Existing files/symlinks will be backed up before replacement
    - If the symlink already exists and points to the correct target, it will be skipped

"@
}

function Test-SymlinkCorrect {
    param(
        [string]$Path,
        [string]$Target
    )
    
    if (-not (Test-Path $Path)) {
        return $false
    }
    
    $item = Get-Item $Path -ErrorAction SilentlyContinue
    if ($item.LinkType -eq "SymbolicLink") {
        $currentTarget = $item.Target
        if ($currentTarget -eq $Target) {
            return $true
        }
    }
    
    return $false
}

function Install-Neovim {
    Write-Host "`n[Neovim]" -ForegroundColor Cyan
    
    $nvimDotfiles = Join-Path $DotfilesRoot "nvim"
    $nvimConfig   = "$env:LOCALAPPDATA\nvim"
    
    if (Test-SymlinkCorrect -Path $nvimConfig -Target $nvimDotfiles) {
        Write-Host "  Symlink already exists and is correct, skipping..." -ForegroundColor Green
        return
    }
    
    if (Test-Path $nvimConfig) {
        $backup = "$($nvimConfig)_backup_$(Get-Date -Format yyyyMMddHHmmss)"
        Write-Host "  Backing up existing config to: $backup" -ForegroundColor Yellow
        Rename-Item $nvimConfig $backup
    }
    
    Write-Host "  Creating symlink: $nvimConfig -> $nvimDotfiles" -ForegroundColor Green
    New-Item -ItemType SymbolicLink -Path $nvimConfig -Target $nvimDotfiles | Out-Null
    Write-Host "  Done!" -ForegroundColor Green
}

function Install-VsVim {
    Write-Host "`n[VsVim]" -ForegroundColor Cyan
    
    $vsvimDotfiles = Join-Path $DotfilesRoot "vsvim\.vimrc"
    $vsvimConfig   = "$HOME\.vimrc"
    
    if (Test-SymlinkCorrect -Path $vsvimConfig -Target $vsvimDotfiles) {
        Write-Host "  Symlink already exists and is correct, skipping..." -ForegroundColor Green
        return
    }
    
    if (Test-Path $vsvimConfig) {
        $backup = "$($vsvimConfig)_backup_$(Get-Date -Format yyyyMMddHHmmss)"
        Write-Host "  Backing up existing config to: $backup" -ForegroundColor Yellow
        Rename-Item $vsvimConfig $backup
    }
    
    Write-Host "  Creating symlink: $vsvimConfig -> $vsvimDotfiles" -ForegroundColor Green
    New-Item -ItemType SymbolicLink -Path $vsvimConfig -Target $vsvimDotfiles | Out-Null
    Write-Host "  Done!" -ForegroundColor Green
}

function Install-LazyGit {
    Write-Host "`n[LazyGit]" -ForegroundColor Cyan
    
    $lzDotfiles = Join-Path $DotfilesRoot "lazygit\config.yml"
    $lzDir      = "$env:LOCALAPPDATA\lazygit"
    $lzConfig   = Join-Path $lzDir "config.yml"
    
    if (-not (Test-Path $lzDotfiles)) {
        Write-Host "  LazyGit dotfile not found at: $lzDotfiles" -ForegroundColor Yellow
        Write-Host "  Skipping..." -ForegroundColor Yellow
        return
    }
    
    if (Test-SymlinkCorrect -Path $lzConfig -Target $lzDotfiles) {
        Write-Host "  Symlink already exists and is correct, skipping..." -ForegroundColor Green
        return
    }
    
    if (-not (Test-Path $lzDir)) {
        Write-Host "  Creating directory: $lzDir" -ForegroundColor Yellow
        New-Item -ItemType Directory -Path $lzDir | Out-Null
    }
    
    if (Test-Path $lzConfig) {
        $backup = "$($lzConfig)_backup_$(Get-Date -Format yyyyMMddHHmmss)"
        Write-Host "  Backing up existing config to: $backup" -ForegroundColor Yellow
        Rename-Item $lzConfig $backup
    }
    
    Write-Host "  Creating symlink: $lzConfig -> $lzDotfiles" -ForegroundColor Green
    New-Item -ItemType SymbolicLink -Path $lzConfig -Target $lzDotfiles | Out-Null
    Write-Host "  Done!" -ForegroundColor Green
}

function Install-GlazeWM {
    Write-Host "`n[GlazeWM]" -ForegroundColor Cyan
    
    $glazewmDotfiles = Join-Path $DotfilesRoot "glazewm\config.yaml"
    $glazewmDir      = "$HOME\.glzr\glazewm"
    $glazewmConfig   = Join-Path $glazewmDir "config.yaml"
    
    if (-not (Test-Path $glazewmDotfiles)) {
        Write-Host "  GlazeWM dotfile not found at: $glazewmDotfiles" -ForegroundColor Yellow
        Write-Host "  Skipping..." -ForegroundColor Yellow
        return
    }
    
    if (Test-SymlinkCorrect -Path $glazewmConfig -Target $glazewmDotfiles) {
        Write-Host "  Symlink already exists and is correct, skipping..." -ForegroundColor Green
        return
    }
    
    if (-not (Test-Path $glazewmDir)) {
        Write-Host "  Creating directory: $glazewmDir" -ForegroundColor Yellow
        New-Item -ItemType Directory -Path $glazewmDir -Force | Out-Null
    }
    
    if (Test-Path $glazewmConfig) {
        $backup = "$($glazewmConfig)_backup_$(Get-Date -Format yyyyMMddHHmmss)"
        Write-Host "  Backing up existing config to: $backup" -ForegroundColor Yellow
        Rename-Item $glazewmConfig $backup
    }
    
    Write-Host "  Creating symlink: $glazewmConfig -> $glazewmDotfiles" -ForegroundColor Green
    New-Item -ItemType SymbolicLink -Path $glazewmConfig -Target $glazewmDotfiles | Out-Null
    Write-Host "  Done!" -ForegroundColor Green
}

function Install-OpenCode {
    Write-Host "`n[OpenCode]" -ForegroundColor Cyan
    
    $opencodeDotfiles = Join-Path $DotfilesRoot "opencode\opencode.jsonc"
    $opencodeDir      = "$HOME\.config\opencode"
    $opencodeConfig   = Join-Path $opencodeDir "opencode.jsonc"
    
    if (-not (Test-Path $opencodeDotfiles)) {
        Write-Host "  OpenCode dotfile not found at: $opencodeDotfiles" -ForegroundColor Yellow
        Write-Host "  Skipping..." -ForegroundColor Yellow
        return
    }
    
    if (Test-SymlinkCorrect -Path $opencodeConfig -Target $opencodeDotfiles) {
        Write-Host "  Symlink already exists and is correct, skipping..." -ForegroundColor Green
        return
    }
    
    if (-not (Test-Path $opencodeDir)) {
        Write-Host "  Creating directory: $opencodeDir" -ForegroundColor Yellow
        New-Item -ItemType Directory -Path $opencodeDir -Force | Out-Null
    }
    
    if (Test-Path $opencodeConfig) {
        $backup = "$($opencodeConfig)_backup_$(Get-Date -Format yyyyMMddHHmmss)"
        Write-Host "  Backing up existing config to: $backup" -ForegroundColor Yellow
        Rename-Item $opencodeConfig $backup
    }
    
    Write-Host "  Creating symlink: $opencodeConfig -> $opencodeDotfiles" -ForegroundColor Green
    New-Item -ItemType SymbolicLink -Path $opencodeConfig -Target $opencodeDotfiles | Out-Null
    Write-Host "  Done!" -ForegroundColor Green
}

function Install-WindowsTerminal {
    Write-Host "`n[Windows Terminal]" -ForegroundColor Cyan

    $wtDotfiles = Join-Path $DotfilesRoot "terminal\settings.json"

    if (-not (Test-Path $wtDotfiles)) {
        Write-Host "  Windows Terminal dotfile not found at: $wtDotfiles" -ForegroundColor Yellow
        Write-Host "  Skipping..." -ForegroundColor Yellow
        return
    }

    $pkg = Get-AppxPackage -Name "Microsoft.WindowsTerminal" -ErrorAction SilentlyContinue
    if (-not $pkg) {
        Write-Host "  Windows Terminal is not installed, skipping..." -ForegroundColor Yellow
        return
    }

    $wtDir    = "$env:LOCALAPPDATA\Packages\$($pkg.PackageFamilyName)\LocalState"
    $wtConfig = Join-Path $wtDir "settings.json"

    if (Test-SymlinkCorrect -Path $wtConfig -Target $wtDotfiles) {
        Write-Host "  Symlink already exists and is correct, skipping..." -ForegroundColor Green
        return
    }

    if (-not (Test-Path $wtDir)) {
        Write-Host "  Creating directory: $wtDir" -ForegroundColor Yellow
        New-Item -ItemType Directory -Path $wtDir -Force | Out-Null
    }

    if (Test-Path $wtConfig) {
        $backup = "$($wtConfig)_backup_$(Get-Date -Format yyyyMMddHHmmss)"
        Write-Host "  Backing up existing config to: $backup" -ForegroundColor Yellow
        Rename-Item $wtConfig $backup
    }

    Write-Host "  Creating symlink: $wtConfig -> $wtDotfiles" -ForegroundColor Green
    New-Item -ItemType SymbolicLink -Path $wtConfig -Target $wtDotfiles | Out-Null
    Write-Host "  Done!" -ForegroundColor Green
}

# Main execution
if ($Help) {
    Show-Help
    exit 0
}

Write-Host "Windows Dotfiles Bootstrap" -ForegroundColor Magenta
Write-Host "==========================" -ForegroundColor Magenta
Write-Host "Dotfiles root: $DotfilesRoot" -ForegroundColor Gray

# Determine what to install
$installAll = -not ($Nvim -or $VsVim -or $LazyGit -or $GlazeWM -or $OpenCode -or $WindowsTerminal)

if ($installAll) {
    Write-Host "`nInstalling all configurations..." -ForegroundColor White
    Install-Neovim
    Install-VsVim
    Install-LazyGit
    Install-GlazeWM
    Install-OpenCode
    Install-WindowsTerminal
} else {
    Write-Host "`nInstalling selected configurations..." -ForegroundColor White
    if ($Nvim) { Install-Neovim }
    if ($VsVim) { Install-VsVim }
    if ($LazyGit) { Install-LazyGit }
    if ($GlazeWM) { Install-GlazeWM }
    if ($OpenCode) { Install-OpenCode }
    if ($WindowsTerminal) { Install-WindowsTerminal }
}

Write-Host "`n==========================" -ForegroundColor Magenta
Write-Host "Bootstrap complete!" -ForegroundColor Magenta
Write-Host ""
