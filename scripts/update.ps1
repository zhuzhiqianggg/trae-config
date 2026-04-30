# Trae Config — Windows Update Script (PowerShell)
# Auto-detects ~/.trae-cn and ~/.trae, updates BOTH
# Usage: irm "https://raw.githubusercontent.com/zhuzhiqianggg/trae-config/main/scripts/update.ps1" | iex

$ErrorActionPreference = "Stop"

$REPO_URL = "https://github.com/zhuzhiqianggg/trae-config.git"
$CLONE_DIR = "$HOME\.trae-config"

function Write-Green($msg)  { Write-Host "[INFO] $msg" -ForegroundColor Green }
function Write-Yellow($msg) { Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Write-Cyan($msg)   { Write-Host "[STEP] $msg" -ForegroundColor Cyan }

function Sync-TraeDir {
    param([string]$src, [string]$dst, [string]$label)
    
    if (-not (Test-Path $src)) { return }
    if (Test-Path $dst) { Remove-Item -Recurse -Force $dst }
    Copy-Item -Recurse $src $dst
    Write-Green "$label synced"
}

Write-Green "=========================================="
Write-Green "  Trae Config Updater"
Write-Green "=========================================="
Write-Host ""

# Update repo
if (-not (Test-Path "$CLONE_DIR\.git")) {
    Write-Yellow "Clone not found, running install first..."
    $url = "https://raw.githubusercontent.com/zhuzhiqianggg/trae-config/main/scripts/install.ps1"
    Invoke-Expression (Invoke-RestMethod -Uri $url)
    exit
}

Set-Location $CLONE_DIR
git fetch origin
$localHash = (git rev-parse HEAD)
$remoteHash = (git rev-parse origin/main)

if ($localHash -eq $remoteHash) {
    Write-Green "Already up to date"
    exit
}

git pull --quiet origin main
Write-Green "Repo updated"

# Sync to all detected Trae directories
$dirsFound = 0

if (Test-Path "$HOME\.trae-cn") {
    Write-Cyan "Syncing to: $HOME\.trae-cn (Trae-CN)"
    Sync-TraeDir "$CLONE_DIR\skills" "$HOME\.trae-cn\skills" "Skills"
    Sync-TraeDir "$CLONE_DIR\agents" "$HOME\.trae-cn\agents" "Agents"
    Sync-TraeDir "$CLONE_DIR\rules" "$HOME\.trae-cn\rules" "Rules"
    if (Test-Path "$CLONE_DIR\user_rules.md") {
        Copy-Item "$CLONE_DIR\user_rules.md" "$HOME\.trae-cn\user_rules.md" -Force
        Write-Green "user_rules.md synced"
    }
    $dirsFound++
    Write-Host ""
}

if (Test-Path "$HOME\.trae") {
    Write-Cyan "Syncing to: $HOME\.trae (Trae Overseas)"
    Sync-TraeDir "$CLONE_DIR\skills" "$HOME\.trae\skills" "Skills"
    Sync-TraeDir "$CLONE_DIR\agents" "$HOME\.trae\agents" "Agents"
    Sync-TraeDir "$CLONE_DIR\rules" "$HOME\.trae\rules" "Rules"
    if (Test-Path "$CLONE_DIR\user_rules.md") {
        Copy-Item "$CLONE_DIR\user_rules.md" "$HOME\.trae\user_rules.md" -Force
        Write-Green "user_rules.md synced"
    }
    $dirsFound++
    Write-Host ""
}

if ($dirsFound -eq 0) {
    Write-Yellow "No ~/.trae-cn or ~/.trae found"
    exit 1
}

Write-Green "=========================================="
Write-Green "  Update complete! ($dirsFound dir(s))"
Write-Green "=========================================="
