# Trae Config - Windows Install Script (PowerShell)
# Downloads repo as zip and installs to ~/.trae-cn and ~/.trae
param(
    [switch]$Force,
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"
$ZIP_URL = "https://github.com/zhuzhiqianggg/trae-config/archive/refs/heads/main.zip"
$CLONE_DIR = "$HOME\.trae-config"

function Write-Green($msg)  { Write-Host "[INFO] $msg" -ForegroundColor Green }
function Write-Yellow($msg) { Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Write-Cyan($msg)   { Write-Host "[STEP] $msg" -ForegroundColor Cyan }

function Sync-Skills {
    param([string]$src, [string]$dst, [switch]$DryRun)

    # Get skill dirs by finding all SKILL.md (works for both flat and categorized)
    $srcSkills = Get-ChildItem -Path $src -Recurse -Filter "SKILL.md" -Depth 3 | ForEach-Object { $_.Directory } | Sort-Object -Unique
    $srcNames = $srcSkills | ForEach-Object { $_.Name }

    # Remove stale skills in target
    if (Test-Path $dst) {
        Get-ChildItem -Directory $dst | ForEach-Object {
            if ($srcNames -notcontains $_.Name) {
                if ($DryRun) {
                    Write-Green "[DRY-RUN] Would remove: $($_.Name)"
                } else {
                    Remove-Item -Recurse -Force $_.FullName -ErrorAction SilentlyContinue
                    Write-Green "Removed stale: $($_.Name)"
                }
            }
        }
    }

    # Copy/overwrite source skills
    New-Item -ItemType Directory -Path $dst -Force | Out-Null
    foreach ($skill in $srcSkills) {
        $target = Join-Path $dst $skill.Name
        if ($DryRun) {
            Write-Green "[DRY-RUN] Would install: $($skill.Name)"
        } else {
            if (Test-Path $target) { Remove-Item -Recurse -Force $target -ErrorAction SilentlyContinue }
            Copy-Item -Recurse $skill.FullName $target
        }
    }

    if (-not $DryRun) {
        $count = (Get-ChildItem -Directory $dst).Count
        Write-Green "Skills: $count installed"
    }
}

function Install-ToDir {
    param([string]$traeDir, [string]$label)

    Write-Cyan "=========================================="
    Write-Cyan "Installing to: $traeDir ($label)"
    Write-Cyan "=========================================="

    $src = "$CLONE_DIR\skills"
    $dst = "$traeDir\skills"
    if (Test-Path $src) {
        Sync-Skills -src $src -dst $dst -DryRun:$DryRun
    } else {
        Write-Yellow "Skills source not found, skipping"
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
    } else {
        Write-Yellow "Agents source not found, skipping"
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
    } else {
        Write-Yellow "Rules source not found, skipping"
    }

    $src = "$CLONE_DIR\settings"
    $dst = "$traeDir\settings"
    if ($DryRun) {
        Write-Green "[DRY-RUN] Settings: $src -> $dst"
    } elseif (Test-Path $src) {
        if (Test-Path $dst) { Remove-Item -Recurse -Force $dst }
        Copy-Item -Recurse $src $dst
        $names = (Get-ChildItem $dst).Name -join ", "
        Write-Green "Settings: $names"
    } else {
        Write-Yellow "Settings source not found, skipping"
    }

    $src = "$CLONE_DIR\user_rules.md"
    $dst = "$traeDir\user_rules.md"
    if ($DryRun) {
        Write-Green "[DRY-RUN] user_rules.md -> $dst"
    } elseif (Test-Path $src) {
        Copy-Item $src $dst -Force
        Write-Green "user_rules.md installed"
    } else {
        Write-Yellow "user_rules.md source not found, skipping"
    }

    Write-Host ""
}

Write-Green "=========================================="
Write-Green "  Trae Config Installer"
Write-Green "  Auto-detecting Trae-CN and Trae"
Write-Green "=========================================="
Write-Host ""

# Download repo as zip (works without git)
Write-Cyan "Downloading trae-config..."
$ZIP_FILE = "$env:TEMP\trae-config-main.zip"
$EXTRACT_DIR = "$env:TEMP\trae-config-extract"

try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $ZIP_URL -OutFile $ZIP_FILE
    Write-Green "Download complete"
} catch {
    Write-Yellow "Download failed: $_"
    Write-Green "Trying alternative method..."
    try {
        $client = New-Object System.Net.WebClient
        $client.DownloadFile($ZIP_URL, $ZIP_FILE)
        Write-Green "Download complete (alternate method)"
    } catch {
        Write-Yellow "Download failed again: $_"
        exit 1
    }
}

# Extract (use temp extract + robocopy to avoid deleting CLONE_DIR while in use)
if (Test-Path $EXTRACT_DIR) { Remove-Item -Recurse -Force $EXTRACT_DIR }
Expand-Archive -Path $ZIP_FILE -DestinationPath $EXTRACT_DIR -Force
robocopy "$EXTRACT_DIR\trae-config-main" $CLONE_DIR /MIR /NJH /NJS /NDL /NP 2>$null
$rc = $LASTEXITCODE; if ($rc -ge 8) { throw "robocopy failed with exit code $rc" }
Remove-Item $ZIP_FILE -Force
Remove-Item $EXTRACT_DIR -Recurse -Force
Write-Green "Repo ready at: $CLONE_DIR"

Write-Host ""

# Detect and install
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
