#!/usr/bin/env bash
set -euo pipefail

# Trae Config — Update Script (Linux/WSL2/SSH Remote)
# Auto-detects ~/.trae and ~/.trae-cn, updates both
# Usage: bash update.sh

REPO_URL="https://github.com/zhuzhiqianggg/trae-config.git"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info()  { echo -e "${GREEN}[INFO]${NC} $1" >&2; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $1" >&2; }
log_step()  { echo -e "${CYAN}[STEP]${NC} $1" >&2; }

# Sync skills: add new, update existing, remove stale
sync_skills() {
    local src="$1"
    local dst="$2"

    mkdir -p "$dst"
    local tmpfile
    tmpfile=$(mktemp)

    while IFS= read -r skilldir; do
        basename "$skilldir" >> "$tmpfile"
    done < <(find "$src" -name SKILL.md -exec dirname {} \; | sort -u)

    for d in "$dst"/*/; do
        [ -d "$d" ] || continue
        local name
        name=$(basename "$d")
        if ! grep -qxF "$name" "$tmpfile" 2>/dev/null; then
            rm -rf "$d"
            log_info "已删除旧技能: $name"
        fi
    done

    while IFS= read -r skilldir; do
        local name
        name=$(basename "$skilldir")
        rm -rf "$dst/$name"
        cp -r "$skilldir" "$dst/"
    done < <(find "$src" -name SKILL.md -exec dirname {} \; | sort -u)

    rm -f "$tmpfile"

    local count
    count=$(find "$dst" -mindepth 1 -maxdepth 1 -type d | wc -l)
    log_info "Skills: $count 个"
}

update_dir() {
    local TRAE_DIR="$1"
    local repo_dir="$2"
    local label="$3"

    log_step "═══════════════════════════════════════════"
    log_step "更新: ${CYAN}${TRAE_DIR}${NC} (${label})"
    log_step "═══════════════════════════════════════════"

    # Skills (同步：新增/更新 + 自动清理已删除的技能)
    if [ -d "$repo_dir/skills" ]; then
        sync_skills "$repo_dir/skills" "$TRAE_DIR/skills"
    fi

    # Agents
    if [ -d "$repo_dir/agents" ]; then
        mkdir -p "$TRAE_DIR/agents"
        cp "$repo_dir/agents/code-reviewer.md" "$TRAE_DIR/agents/" 2>/dev/null || true
        cp "$repo_dir/agents/implementer.md" "$TRAE_DIR/agents/" 2>/dev/null || true
        cp "$repo_dir/agents/spec-reviewer.md" "$TRAE_DIR/agents/" 2>/dev/null || true
        cp "$repo_dir/agents/code-quality-reviewer.md" "$TRAE_DIR/agents/" 2>/dev/null || true
        rm -f "$TRAE_DIR/agents/spec-reviewer-prompt.md" "$TRAE_DIR/agents/code-quality-reviewer-prompt.md" "$TRAE_DIR/agents/implementer-prompt.md" 2>/dev/null || true
        local count
        count=$(ls "$TRAE_DIR/agents"/*.md 2>/dev/null | wc -l)
        log_info "Agents: $count 个"
    fi

    # Rules
    if [ -d "$repo_dir/rules" ]; then
        mkdir -p "$TRAE_DIR/rules"
        cp "$repo_dir/rules/"* "$TRAE_DIR/rules/" 2>/dev/null || true
        log_info "Rules: $(ls "$TRAE_DIR/rules" | tr '\n' ', ')"
    fi

    # Settings 参考
    if [ -d "$repo_dir/settings" ]; then
        mkdir -p "$TRAE_DIR/settings"
        cp "$repo_dir/settings/"* "$TRAE_DIR/settings/" 2>/dev/null || true
        log_info "Settings: $(ls "$TRAE_DIR/settings" | tr '\n' ', ')"
    fi

    # user_rules.md
    if [ -f "$repo_dir/user_rules.md" ]; then
        cp "$repo_dir/user_rules.md" "$TRAE_DIR/user_rules.md"
        log_info "user_rules.md ✓"
    fi

    echo ""
}

main() {
    local clone_dir="$HOME/.trae-config"

    if [ ! -d "$clone_dir/.git" ]; then
        log_warn "未找到 trae-config 仓库"
        log_info "首次安装，运行: bash install.sh"
        exit 1
    fi

    log_info "═══════════════════════════════════════════"
    log_info "  Trae Config 更新脚本"
    log_info "  自动检测 Trae (海外版) 和 Trae-CN (中国版)"
    log_info "═══════════════════════════════════════════"
    echo ""

    cd "$clone_dir"
    git fetch origin 2>/dev/null || true
    git pull --quiet origin main 2>/dev/null || true
    log_info "仓库已更新到最新"
    echo ""

    local dirs_found=0

    if [ -d "$HOME/.trae" ]; then
        update_dir "$HOME/.trae" "$clone_dir" "Trae 海外版"
        dirs_found=$((dirs_found + 1))
    fi

    if [ -d "$HOME/.trae-cn" ]; then
        update_dir "$HOME/.trae-cn" "$clone_dir" "Trae-CN 中国版"
        dirs_found=$((dirs_found + 1))
    fi

    if [ "$dirs_found" -eq 0 ]; then
        log_warn "未找到 ~/.trae 或 ~/.trae-cn 目录"
        exit 1
    fi

    log_info "═══════════════════════════════════════════"
    log_info "  更新完成! 共更新 $dirs_found 个目录"
    log_info "═══════════════════════════════════════════"
}

main
