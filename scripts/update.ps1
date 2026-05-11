# Trae Config - Windows Update Script (PowerShell)
# Downloads latest zip and updates ~/.trae-cn and ~/.trae
param(
    [switch]$Force
)

$ErrorActionPreference = "Stop"
$ZIP_URL = "https://github.com/zhuzhiqianggg/trae-config/archive/refs/heads/main.zip"
$CLONE_DIR = "$HOME\.trae-config"

function Write-Green($msg)  { Write-Host "[INFO] $msg" -ForegroundColor Green }
function Write-Yellow($msg) { Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Write-Cyan($msg)   { Write-Host "[STEP] $msg" -ForegroundColor Cyan }

function Sync-Skills {
    param([string]$src, [string]$dst)

    $srcSkills = Get-ChildItem -Path $src -Recurse -Filter "SKILL.md" -Depth 3 | ForEach-Object { $_.Directory } | Sort-Object -Unique
    $srcNames = $srcSkills | ForEach-Object { $_.Name }

    if (Test-Path $dst) {
        Get-ChildItem -Directory $dst | ForEach-Object {
            if ($srcNames -notcontains $_.Name) {
                Remove-Item -Recurse -Force $_.FullName -ErrorAction SilentlyContinue
                Write-Green "Removed stale: $($_.Name)"
            }
        }
    }

    New-Item -ItemType Directory -Path $dst -Force | Out-Null
    foreach ($skill in $srcSkills) {
        $target = Join-Path $dst $skill.Name
        if (Test-Path $target) { Remove-Item -Recurse -Force $target -ErrorAction SilentlyContinue }
        Copy-Item -Recurse $skill.FullName $target
    }

    $count = (Get-ChildItem -Directory $dst).Count
    Write-Green "Skills: $count"
}

function Sync-TraeDir {
    param([string]$src, [string]$dst, [string]$label)
    
    if (-not (Test-Path $src)) { Write-Yellow "$src not found"; return }
    if (Test-Path $dst) { Remove-Item -Recurse -Force $dst }
    Copy-Item -Recurse $src $dst
    Write-Green "$label synced"
}

Write-Green "=========================================="
Write-Green "  Trae Config Updater"
Write-Green "=========================================="
Write-Host ""

# Download as zip
Write-Cyan "Downloading trae-config..."
$ZIP_FILE = "$env:TEMP\trae-config-main.zip"
$EXTRACT_DIR = "$env:TEMP\trae-config-extract"

try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $ZIP_URL -OutFile $ZIP_FILE
    Write-Green "Download complete"
} catch {
    Write-Yellow "Download failed: $_"
    try {
        $client = New-Object System.Net.WebClient
        $client.DownloadFile($ZIP_URL, $ZIP_FILE)
        Write-Green "Download complete (alternate method)"
    } catch {
        Write-Yellow "Download failed again: $_"
        exit 1
    }
}

# Extract
if (Test-Path $EXTRACT_DIR) { Remove-Item -Recurse -Force $EXTRACT_DIR }
if (Test-Path $CLONE_DIR) { Remove-Item -Recurse -Force $CLONE_DIR }
Expand-Archive -Path $ZIP_FILE -DestinationPath $EXTRACT_DIR -Force
Move-Item "$EXTRACT_DIR\trae-config-main" $CLONE_DIR -Force
Remove-Item $ZIP_FILE -Force
Remove-Item $EXTRACT_DIR -Recurse -Force
Write-Green "Repo ready at: $CLONE_DIR"
Write-Host ""

# Sync to all detected Trae directories
$dirsFound = 0

if (Test-Path "$HOME\.trae-cn") {
    Write-Cyan "Syncing to: $HOME\.trae-cn (Trae-CN)"
    Sync-Skills "$CLONE_DIR\skills" "$HOME\.trae-cn\skills"
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
    Sync-Skills "$CLONE_DIR\skills" "$HOME\.trae\skills"
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
