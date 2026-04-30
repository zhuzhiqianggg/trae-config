# Trae Config - Windows Install Script (PowerShell)
# Auto-detects ~/.trae-cn and ~/.trae, installs to BOTH
param(
    [switch]$Force,
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"
$REPO_URL = "https://github.com/zhuzhiqianggg/trae-config.git"
$CLONE_DIR = "$HOME\.trae-config"

function Write-Green($msg)  { Write-Host "[INFO] $msg" -ForegroundColor Green }
function Write-Yellow($msg) { Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Write-Cyan($msg)   { Write-Host "[STEP] $msg" -ForegroundColor Cyan }

function Install-ToDir {
    param([string]$traeDir, [string]$label)

    Write-Cyan "=========================================="
    Write-Cyan "Installing to: $traeDir ($label)"
    Write-Cyan "=========================================="

    $src = "$CLONE_DIR\skills"
    $dst = "$traeDir\skills"
    if ($DryRun) {
        Write-Green "[DRY-RUN] Skills: $src -> $dst"
    } elseif (Test-Path $src) {
        if (Test-Path $dst) { Remove-Item -Recurse -Force $dst }
        Copy-Item -Recurse $src $dst
        $count = (Get-ChildItem -Directory $dst).Count
        Write-Green "Skills: $count installed"
    }

    $src = "$CLONE_DIR\agents"
    $dst = "$traeDir\agents"
    if ($DryRun) {
        Write-Green "[DRY-RUN] Agents: $src -> $dst"
    } elseif (Test-Path $src) {
        New-Item -ItemType Directory -Path $dst -Force | Out-Null
        Copy-Item "$src\code-reviewer.md" "$dst\" -Force -ErrorAction SilentlyContinue
        Copy-Item "$src\implementer.md" "$dst\" -Force -ErrorAction SilentlyContinue
        Copy-Item "$src\spec-reviewer.md" "$dst\" -Force -ErrorAction SilentlyContinue
        Copy-Item "$src\code-quality-reviewer.md" "$dst\" -Force -ErrorAction SilentlyContinue
        Remove-Item "$dst\spec-reviewer-prompt.md" -Force -ErrorAction SilentlyContinue
        Remove-Item "$dst\code-quality-reviewer-prompt.md" -Force -ErrorAction SilentlyContinue
        Remove-Item "$dst\implementer-prompt.md" -Force -ErrorAction SilentlyContinue
        $count = (Get-ChildItem -Filter "*.md" $dst).Count
        Write-Green "Agents: $count installed"
    }

    $src = "$CLONE_DIR\rules"
    $dst = "$traeDir\rules"
    if ($DryRun) {
        Write-Green "[DRY-RUN] Rules: $src -> $dst"
    } elseif (Test-Path $src) {
        if (Test-Path $dst) { Remove-Item -Recurse -Force $dst }
        Copy-Item -Recurse $src $dst
        $names = (Get-ChildItem $dst).Name -join ", "
        Write-Green "Rules: $names"
    }

    $src = "$CLONE_DIR\user_rules.md"
    $dst = "$traeDir\user_rules.md"
    if ($DryRun) {
        Write-Green "[DRY-RUN] user_rules.md -> $dst"
    } elseif (Test-Path $src) {
        Copy-Item $src $dst -Force
        Write-Green "user_rules.md installed"
    }

    Write-Host ""
}

Write-Green "=========================================="
Write-Green "  Trae Config Installer"
Write-Green "  Auto-detecting Trae-CN and Trae"
Write-Green "=========================================="
Write-Host ""

if (Test-Path "$CLONE_DIR\.git") {
    Write-Green "Updating trae-config repo..."
    Set-Location $CLONE_DIR
    git pull --quiet origin main 2>$null
    Write-Green "Repo updated"
} else {
    Write-Green "Cloning trae-config repo..."
    git clone --quiet --depth 1 $REPO_URL $CLONE_DIR
    Write-Green "Clone complete"
}

Write-Host ""

$dirsFound = 0

if (Test-Path "$HOME\.trae-cn") {
    Install-ToDir "$HOME\.trae-cn" "Trae-CN"
    $dirsFound++
}

if (Test-Path "$HOME\.trae") {
    Install-ToDir "$HOME\.trae" "Trae Overseas"
    $dirsFound++
}

if ($dirsFound -eq 0) {
    Write-Yellow "No ~/.trae-cn or ~/.trae found"
    Write-Green "Please install Trae or Trae-CN first"
    exit 1
}

Write-Green "=========================================="
Write-Green "  Installation complete! ($dirsFound dir(s))"
Write-Green "=========================================="
Write-Host ""
Write-Green "Run update: irm https://raw.githubusercontent.com/zhuzhiqianggg/trae-config/main/scripts/update.ps1 | iex"
