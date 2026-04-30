# Trae Config — Windows Install Script (PowerShell)
# Installs skills, agents, and rules to ~/.trae-cn/ or ~/.trae/
# Usage: .\scripts\install.ps1
#   Flags:
#     -Force    Overwrite existing files
#     -DryRun   Show what would be done without making changes

$ErrorActionPreference = "Stop"

$REPO_URL = "https://github.com/zhuzhiqianggg/trae-config.git"
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$ROOT_DIR = Split-Path -Parent $SCRIPT_DIR

# Detect Trae directory (.trae-cn or .trae)
$TRAE_DIR = $null
$CANDIDATES = @("$HOME\.trae-cn", "$HOME\.trae")
foreach ($c in $CANDIDATES) {
    if (Test-Path $c) {
        $TRAE_DIR = $c
        break
    }
}
if (-not $TRAE_DIR) {
    $TRAE_DIR = "$HOME\.trae-cn"
    Write-Host "[INFO] No .trae-cn or .trae found, creating $TRAE_DIR" -ForegroundColor Green
    New-Item -ItemType Directory -Path $TRAE_DIR -Force | Out-Null
}

Write-Host "[INFO] === Trae Config Installer ===" -ForegroundColor Green
Write-Host "[INFO] Target: $TRAE_DIR" -ForegroundColor Green

# Clone or update repo
$CLONE_DIR = "$HOME\.trae-config"
if (Test-Path "$CLONE_DIR\.git") {
    Write-Host "[INFO] Updating existing clone..." -ForegroundColor Green
    Set-Location $CLONE_DIR
    git pull --quiet origin main
} else {
    Write-Host "[INFO] Cloning trae-config..." -ForegroundColor Green
    git clone --quiet --depth 1 $REPO_URL $CLONE_DIR
}

Write-Host ""

# Copy function
function Copy-TraeDir {
    param([string]$src, [string]$dst, [string]$label)
    
    if (-not (Test-Path $src)) {
        Write-Host "[WARN] $label source not found: $src" -ForegroundColor Yellow
        return
    }
    
    if ((Test-Path $dst) -and (-not $Force)) {
        Write-Host "[WARN] $label already exists: $dst (use -Force to overwrite)" -ForegroundColor Yellow
        return
    }
    
    if ($DryRun) {
        Write-Host "[DRY-RUN] Would install $label: $src -> $dst" -ForegroundColor Green
        return
    }
    
    if (Test-Path $dst) { Remove-Item -Recurse -Force $dst }
    Copy-Item -Recurse $src $dst
    Write-Host "[INFO] Installed $label -> $dst" -ForegroundColor Green
}

# Parse parameters
param(
    [switch]$Force,
    [switch]$DryRun
)

# Install components
Set-Location $CLONE_DIR

Copy-TraeDir "$CLONE_DIR\skills" "$TRAE_DIR\skills" "Skills"
Copy-TraeDir "$CLONE_DIR\agents" "$TRAE_DIR\agents" "Agents"
Copy-TraeDir "$CLONE_DIR\rules" "$TRAE_DIR\rules" "Rules"

# Install user_rules.md
if (Test-Path "$CLONE_DIR\user_rules.md") {
    $dst = "$TRAE_DIR\user_rules.md"
    if ($DryRun) {
        Write-Host "[DRY-RUN] Would install user_rules.md -> $dst" -ForegroundColor Green
    } elseif ((Test-Path $dst) -and (-not $Force)) {
        Write-Host "[WARN] user_rules.md already exists (use -Force to overwrite)" -ForegroundColor Yellow
    } else {
        if (Test-Path $dst) { Remove-Item -Force $dst }
        Copy-Item "$CLONE_DIR\user_rules.md" $dst
        Write-Host "[INFO] Installed user_rules.md -> $dst" -ForegroundColor Green
    }
}

Write-Host ""
if ($DryRun) {
    Write-Host "[INFO] Dry run complete. No changes were made." -ForegroundColor Green
} else {
    Write-Host "[INFO] === Installation Complete ===" -ForegroundColor Green
    Write-Host "[INFO] Skills: $TRAE_DIR\skills\" -ForegroundColor Green
    Write-Host "[INFO] Agents: $TRAE_DIR\agents\" -ForegroundColor Green
    Write-Host "[INFO] Rules:  $TRAE_DIR\rules\" -ForegroundColor Green
    Write-Host ""
    Write-Host "[INFO] Run '.\scripts\update.ps1' to update." -ForegroundColor Green
}
