param(
    [string]$DotfilesRoot = "$HOME\win-dotfiles"
)

# Neovim
$nvimDotfiles = Join-Path $DotfilesRoot "nvim"
$nvimConfig   = "$env:LOCALAPPDATA\nvim"

if (Test-Path $nvimConfig) {
    Rename-Item $nvimConfig "$($nvimConfig)_backup_$(Get-Date -Format yyyyMMddHHmmss)"
}
New-Item -ItemType SymbolicLink -Path $nvimConfig -Target $nvimDotfiles

# LazyGit (optional)
# $lzDotfiles = Join-Path $DotfilesRoot "lazygit\config.yml"
# $lzDir      = "$env:LOCALAPPDATA\lazygit"
# $lzConfig   = Join-Path $lzDir "config.yml"
#
# if (Test-Path $lzDotfiles) {
#     if (-not (Test-Path $lzDir)) {
#         New-Item -ItemType Directory -Path $lzDir | Out-Null
#     }
#     if (Test-Path $lzConfig) {
#         Rename-Item $lzConfig "$($lzConfig)_backup_$(Get-Date -Format yyyyMMddHHmmss)"
#     }
#     New-Item -ItemType SymbolicLink -Path $lzConfig -Target $lzDotfiles
# }

