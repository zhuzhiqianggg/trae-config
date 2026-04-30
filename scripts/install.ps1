# Trae Config — Windows Install Script (PowerShell)
# Auto-detects ~/.trae-cn and ~/.trae, installs to BOTH
# Usage: .\scripts\install.ps1 [-Force] [-DryRun]

$ErrorActionPreference = "Stop"

$REPO_URL = "https://github.com/zhuzhiqianggg/trae-config.git"
$CLONE_DIR = "$HOME\.trae-config"
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$ROOT_DIR = Split-Path -Parent $SCRIPT_DIR

param(
    [switch]$Force,
    [switch]$DryRun
)

# Colors
function Write-Green($msg)  { Write-Host "[INFO] $msg" -ForegroundColor Green }
function Write-Yellow($msg) { Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Write-Cyan($msg)   { Write-Host "[STEP] $msg" -ForegroundColor Cyan }

function Install-ToDir {
    param([string]$traeDir, [string]$label)

    Write-Cyan "═══════════════════════════════════════════"
    Write-Cyan "安装到: $traeDir ($label)"
    Write-Cyan "═══════════════════════════════════════════"

    # Skills
    $src = "$CLONE_DIR\skills"
    $dst = "$traeDir\skills"
    if ($DryRun) {
        Write-Green "[DRY-RUN] 将安装 Skills: $src -> $dst"
    } elseif (Test-Path $src) {
        if (Test-Path $dst) { Remove-Item -Recurse -Force $dst }
        Copy-Item -Recurse $src $dst
        $count = (Get-ChildItem -Directory $dst).Count
        Write-Green "Skills: $count 个"
    }

    # Agents
    $src = "$CLONE_DIR\agents"
    $dst = "$traeDir\agents"
    if ($DryRun) {
        Write-Green "[DRY-RUN] 将安装 Agents: $src -> $dst"
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
        Write-Green "Agents: $count 个"
    }

    # Rules
    $src = "$CLONE_DIR\rules"
    $dst = "$traeDir\rules"
    if ($DryRun) {
        Write-Green "[DRY-RUN] 将安装 Rules: $src -> $dst"
    } elseif (Test-Path $src) {
        if (Test-Path $dst) { Remove-Item -Recurse -Force $dst }
        Copy-Item -Recurse $src $dst
        Write-Green "Rules: $((Get-ChildItem $dst).Name -join ', ')"
    }

    # user_rules.md
    $src = "$CLONE_DIR\user_rules.md"
    $dst = "$traeDir\user_rules.md"
    if ($DryRun) {
        Write-Green "[DRY-RUN] 将安装 user_rules.md -> $dst"
    } elseif (Test-Path $src) {
        Copy-Item $src $dst -Force
        Write-Green "user_rules.md ✓"
    }

    Write-Host ""
}

# Main
Write-Green "═══════════════════════════════════════════"
Write-Green "  Trae Config 安装脚本"
Write-Green "  自动检测 Trae-CN (中国版) 和 Trae (海外版)"
Write-Green "═══════════════════════════════════════════"
Write-Host ""

# Clone or update
if (Test-Path "$CLONE_DIR\.git") {
    Write-Green "更新 trae-config 仓库..."
    Set-Location $CLONE_DIR
    git pull --quiet origin main 2>$null
    Write-Green "仓库已更新"
} else {
    Write-Green "克隆 trae-config 仓库..."
    git clone --quiet --depth 1 $REPO_URL $CLONE_DIR
    Write-Green "克隆完成"
}

Write-Host ""

# Detect and install
$dirsFound = 0

# Check ~/.trae-cn (Trae-CN 中国版) - priority
if (Test-Path "$HOME\.trae-cn") {
    Install-ToDir "$HOME\.trae-cn" "Trae-CN 中国版"
    $dirsFound++
}

# Check ~/.trae (Trae 海外版)
if (Test-Path "$HOME\.trae") {
    Install-ToDir "$HOME\.trae" "Trae 海外版"
    $dirsFound++
}

if ($dirsFound -eq 0) {
    Write-Yellow "未找到 ~/.trae-cn 或 ~/.trae 目录"
    Write-Green "请先安装 Trae 或 Trae-CN"
    exit 1
}

Write-Green "═══════════════════════════════════════════"
Write-Green "  安装完成! 共安装到 $dirsFound 个目录"
Write-Green "═══════════════════════════════════════════"
Write-Host ""
Write-Green "运行 '.\scripts\update.ps1' 更新"
