# Trae Config — Windows Update Script (PowerShell)
# Pulls latest changes and updates ~/.trae-cn/ or ~/.trae/
# Usage: .\scripts\update.ps1

$ErrorActionPreference = "Stop"

$REPO_URL = "https://github.com/zhuzhiqianggg/trae-config.git"
$CLONE_DIR = "$HOME\.trae-config"

# Detect Trae directory
$TRAE_DIR = $null
$CANDIDATES = @("$HOME\.trae-cn", "$HOME\.trae")
foreach ($c in $CANDIDATES) {
    if (Test-Path $c) {
        $TRAE_DIR = $c
        break
    }
}
if (-not $TRAE_DIR) {
    Write-Host "[WARN] No Trae directory found. Run install.ps1 first." -ForegroundColor Yellow
    exit 1
}

Write-Host "[INFO] Updating trae-config..." -ForegroundColor Green

if (-not (Test-Path "$CLONE_DIR\.git")) {
    Write-Host "[WARN] Clone not found at $CLONE_DIR, running install first..." -ForegroundColor Yellow
    & "$PSScriptRoot\install.ps1"
    exit
}

Set-Location $CLONE_DIR
git fetch origin
$localHash = (git rev-parse HEAD)
$remoteHash = (git rev-parse origin/main)

if ($localHash -eq $remoteHash) {
    Write-Host "[INFO] Already up to date" -ForegroundColor Green
    exit
}

git pull --quiet origin main
Write-Host "[INFO] Pulled latest changes" -ForegroundColor Green

# Sync function
function Sync-TraeDir {
    param([string]$src, [string]$dst, [string]$label)
    
    if (-not (Test-Path $src)) { return }
    
    if (Test-Path $dst) {
        Remove-Item -Recurse -Force $dst
    }
    Copy-Item -Recurse $src $dst
    Write-Host "[INFO] $label synced" -ForegroundColor Green
}

Sync-TraeDir "$CLONE_DIR\skills" "$TRAE_DIR\skills" "Skills"
Sync-TraeDir "$CLONE_DIR\agents" "$TRAE_DIR\agents" "Agents"
Sync-TraeDir "$CLONE_DIR\rules" "$TRAE_DIR\rules" "Rules"

# Sync user_rules.md
if (Test-Path "$CLONE_DIR\user_rules.md") {
    Copy-Item "$CLONE_DIR\user_rules.md" "$TRAE_DIR\user_rules.md" -Force
    Write-Host "[INFO] user_rules.md synced" -ForegroundColor Green
}

Write-Host "[INFO] === Update Complete ===" -ForegroundColor Green
