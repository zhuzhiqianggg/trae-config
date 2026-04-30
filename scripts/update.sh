#!/usr/bin/env bash
set -euo pipefail

# Trae Config — Linux Update Script
# Pulls latest changes from GitHub and updates ~/.trae/
# Usage: bash update.sh

REPO_URL="https://github.com/zhuzhiqianggg/trae-config.git"
TRAE_DIR="$HOME/.trae"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }

main() {
    local clone_dir="$HOME/.trae-config"
    
    if [ ! -d "$clone_dir/.git" ]; then
        log_warn "trae-config not found at $clone_dir"
        log_info "Running first-time install..."
        bash "$(dirname "$0")/install.sh"
        return
    fi
    
    log_info "Updating trae-config..."
    cd "$clone_dir"
    
    # Fetch and check for updates
    git fetch origin
    local local_hash
    local_hash=$(git rev-parse HEAD)
    local remote_hash
    remote_hash=$(git rev-parse origin/main)
    
    if [ "$local_hash" = "$remote_hash" ]; then
        log_info "Already up to date"
        return
    fi
    
    git pull --quiet origin main
    log_info "Pulled latest changes"
    
    # Sync skills
    log_info "Syncing skills..."
    if [ -d "$clone_dir/skills" ]; then
        rsync -a --delete "$clone_dir/skills/" "$TRAE_DIR/skills/"
        log_info "Skills synced"
    fi
    
    # Sync agents
    log_info "Syncing agents..."
    if [ -d "$clone_dir/agents" ]; then
        rsync -a --delete "$clone_dir/agents/" "$TRAE_DIR/agents/"
        log_info "Agents synced"
    fi
    
    # Sync rules
    log_info "Syncing rules..."
    if [ -d "$clone_dir/rules" ]; then
        rsync -a --delete "$clone_dir/rules/" "$TRAE_DIR/rules/"
        log_info "Rules synced"
    fi
    
    log_info "=== Update Complete ==="
}

main
