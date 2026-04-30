#!/usr/bin/env bash
set -euo pipefail

# Trae Config — Linux Install Script
# Installs skills, agents, and rules to ~/.trae/
# Usage: bash install.sh
#   Flags:
#     --force    Overwrite existing files
#     --dry-run  Show what would be done without making changes
#     --help     Show this help message

REPO_URL="https://github.com/zhuzhiqianggg/trae-config.git"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TRAE_DIR="$HOME/.trae"
FORCE=false
DRY_RUN=false

# Parse arguments
for arg in "$@"; do
    case $arg in
        --force) FORCE=true; shift ;;
        --dry-run) DRY_RUN=true; shift ;;
        --help|-h)
            echo "Usage: bash install.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --force    Overwrite existing files without prompting"
            echo "  --dry-run  Show what would be installed without making changes"
            echo "  --help     Show this help message"
            exit 0
            ;;
    esac
done

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

log_info()    { echo -e "${GREEN}[INFO]${NC} $1" >&2; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC} $1" >&2; }
log_error()   { echo -e "${RED}[ERROR]${NC} $1" >&2; }

# Check if running in Trae context
check_deps() {
    if ! command -v git &>/dev/null; then
        log_error "git is required but not installed."
        exit 1
    fi
    log_info "Dependencies OK"
}

# Clone or update the repo
clone_or_update() {
    local clone_dir="$HOME/.trae-config"
    
    if [ -d "$clone_dir/.git" ]; then
        log_info "Updating existing clone..."
        cd "$clone_dir"
        git pull --quiet origin main
        log_info "Updated to latest"
    else
        log_info "Cloning trae-config..."
        git clone --quiet --depth 1 "$REPO_URL" "$clone_dir"
        log_info "Cloned successfully"
    fi
    
    echo "$clone_dir"
}

# Copy a directory, handling --force and --dry-run
copy_dir() {
    local src="$1"
    local dst="$2"
    local label="$3"
    
    if [ ! -d "$src" ]; then
        log_warn "$label source not found: $src"
        return 0
    fi
    
    if [ -d "$dst" ] && [ "$FORCE" = false ]; then
        log_warn "$label already exists: $dst (use --force to overwrite)"
        return 0
    fi
    
    if [ "$DRY_RUN" = true ]; then
        log_info "[DRY-RUN] Would install $label: $src -> $dst"
        return 0
    fi
    
    mkdir -p "$(dirname "$dst")"
    if [ "$FORCE" = true ] && [ -d "$dst" ]; then
        rm -rf "$dst"
    fi
    cp -r "$src" "$dst"
    log_info "Installed $label -> $dst"
}

# Main installation
main() {
    check_deps
    
    log_info "=== Trae Config Installer ==="
    log_info "Target: $TRAE_DIR"
    echo ""
    
    local repo_dir
    repo_dir=$(clone_or_update)
    echo ""
    
    # Install skills
    copy_dir "$repo_dir/skills" "$TRAE_DIR/skills" "Skills"
    
    # Install agents
    copy_dir "$repo_dir/agents" "$TRAE_DIR/agents" "Agents"
    
    # Install rules
    copy_dir "$repo_dir/rules" "$TRAE_DIR/rules" "Rules"
    
    # Install user_rules.md if it exists
    if [ -f "$repo_dir/user_rules.md" ]; then
        local dst="$TRAE_DIR/user_rules.md"
        if [ "$DRY_RUN" = true ]; then
            log_info "[DRY-RUN] Would install user_rules.md -> $dst"
        elif [ -f "$dst" ] && [ "$FORCE" = false ]; then
            log_warn "user_rules.md already exists (use --force to overwrite)"
        else
            if [ "$FORCE" = true ] && [ -f "$dst" ]; then
                rm -f "$dst"
            fi
            cp "$repo_dir/user_rules.md" "$dst"
            log_info "Installed user_rules.md -> $dst"
        fi
    fi
    
    echo ""
    if [ "$DRY_RUN" = true ]; then
        log_info "Dry run complete. No changes were made."
    else
        log_info "=== Installation Complete ==="
        log_info "Skills: $TRAE_DIR/skills/"
        log_info "Agents: $TRAE_DIR/agents/"
        log_info "Rules:  $TRAE_DIR/rules/"
        echo ""
        log_info "Run 'bash update.sh' to update to latest version."
    fi
}

main
