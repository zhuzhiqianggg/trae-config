#!/usr/bin/env bash
set -euo pipefail

# Trae Config — Linux/WSL2/SSH Remote Install Script
# Auto-detects ~/.trae (Trae 海外版) and ~/.trae-cn (Trae 中国版)
# Installs to ALL detected directories
# Usage: bash install.sh [--force] [--dry-run] [--help]

REPO_URL="https://github.com/zhuzhiqianggg/trae-config.git"
FORCE=false
DRY_RUN=false

for arg in "$@"; do
    case $arg in
        --force) FORCE=true; shift ;;
        --dry-run) DRY_RUN=true; shift ;;
        --help|-h)
            echo "Trae Config 安装脚本 — 自动检测 Trae 和 Trae-CN"
            echo ""
            echo "Usage: bash install.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --force    覆盖已安装的文件"
            echo "  --dry-run  仅显示将要做什么，不做实际更改"
            echo "  --help     显示帮助信息"
            exit 0
            ;;
    esac
done

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info()  { echo -e "${GREEN}[INFO]${NC} $1" >&2; }
log_warn()  { echo -e "${YELLOW}[WARN]${NC} $1" >&2; }
log_error() { echo -e "${RED}[ERROR]${NC} $1" >&2; }
log_step()  { echo -e "${CYAN}[STEP]${NC} $1" >&2; }

check_deps() {
    if ! command -v git &>/dev/null; then
        log_error "需要 git，但未安装"
        exit 1
    fi
}

clone_or_update() {
    local clone_dir="$HOME/.trae-config"

    if [ -d "$clone_dir/.git" ]; then
        log_info "更新 trae-config 仓库..."
        cd "$clone_dir"
        git pull --quiet origin main 2>/dev/null || true
        log_info "仓库已更新"
    else
        log_info "克隆 trae-config 仓库..."
        git clone --quiet --depth 1 "$REPO_URL" "$clone_dir"
        log_info "克隆完成"
    fi

    echo "$clone_dir"
}

# Sync skills: add new, update existing, remove stale
sync_skills() {
    local src="$1"
    local dst="$2"
    local dry_run="$3"

    mkdir -p "$dst"
    local tmpfile src_skills
    tmpfile=$(mktemp)

    # Find all directories containing SKILL.md (works for both flat and categorized)
    while IFS= read -r skilldir; do
        basename "$skilldir" >> "$tmpfile"
    done < <(find "$src" -name SKILL.md -exec dirname {} \; | sort -u)

    # Remove skills in target that no longer exist in source
    for d in "$dst"/*/; do
        [ -d "$d" ] || continue
        local name
        name=$(basename "$d")
        if ! grep -qxF "$name" "$tmpfile" 2>/dev/null; then
            if [ "$dry_run" = true ]; then
                log_info "[DRY-RUN] 将删除旧技能: $name"
            else
                rm -rf "$d"
                log_info "已删除旧技能: $name"
            fi
        fi
    done

    # Copy/overwrite all source skills
    while IFS= read -r skilldir; do
        local name
        name=$(basename "$skilldir")
        if [ "$dry_run" = true ]; then
            log_info "[DRY-RUN] 将安装/更新技能: $name"
        else
            rm -rf "$dst/$name"
            cp -r "$skilldir" "$dst/"
        fi
    done < <(find "$src" -name SKILL.md -exec dirname {} \; | sort -u)

    rm -f "$tmpfile"

    if [ "$dry_run" = false ]; then
        local count
        count=$(find "$dst" -mindepth 1 -maxdepth 1 -type d | wc -l)
        log_info "Skills: $count 个"
    fi
}

# Install to a single Trae directory
install_to_dir() {
    local TRAE_DIR="$1"
    local repo_dir="$2"
    local label="$3"

    log_step "═══════════════════════════════════════════"
    log_step "安装到: ${CYAN}${TRAE_DIR}${NC} (${label})"
    log_step "═══════════════════════════════════════════"

    # Skills (同步：新增/更新 + 自动清理已删除的技能)
    local src="$repo_dir/skills"
    local dst="$TRAE_DIR/skills"
    if [ -d "$src" ]; then
        sync_skills "$src" "$dst" "$DRY_RUN"
    fi

    # Agents
    src="$repo_dir/agents"
    dst="$TRAE_DIR/agents"
    if [ "$DRY_RUN" = true ]; then
        log_info "[DRY-RUN] 将安装 Agents: $src -> $dst"
    elif [ -d "$src" ]; then
        mkdir -p "$dst"
        # 只复制标准命名的文件，清理旧格式
        cp "$src/code-reviewer.md" "$dst/" 2>/dev/null || true
        cp "$src/implementer.md" "$dst/" 2>/dev/null || true
        cp "$src/spec-reviewer.md" "$dst/" 2>/dev/null || true
        cp "$src/code-quality-reviewer.md" "$dst/" 2>/dev/null || true
        # 清理旧格式重复文件
        rm -f "$dst/spec-reviewer-prompt.md" "$dst/code-quality-reviewer-prompt.md" "$dst/implementer-prompt.md" 2>/dev/null || true
        local count
        count=$(ls "$dst"/*.md 2>/dev/null | wc -l)
        log_info "Agents: $count 个"
    fi

    # Rules
    src="$repo_dir/rules"
    dst="$TRAE_DIR/rules"
    if [ "$DRY_RUN" = true ]; then
        log_info "[DRY-RUN] 将安装 Rules: $src -> $dst"
    elif [ -d "$src" ]; then
        mkdir -p "$dst"
        cp "$src/"* "$dst/" 2>/dev/null || true
        log_info "Rules: $(ls "$dst" | tr '\n' ', ')"
    fi

    # user_rules.md
    src="$repo_dir/user_rules.md"
    dst="$TRAE_DIR/user_rules.md"
    if [ "$DRY_RUN" = true ]; then
        log_info "[DRY-RUN] 将安装 user_rules.md -> $dst"
    elif [ -f "$src" ]; then
        cp "$src" "$dst"
        log_info "user_rules.md ✓"
    fi

    echo ""
}

main() {
    check_deps

    log_info "═══════════════════════════════════════════"
    log_info "  Trae Config 安装脚本"
    log_info "  自动检测 Trae (海外版) 和 Trae-CN (中国版)"
    log_info "═══════════════════════════════════════════"
    echo ""

    local repo_dir
    repo_dir=$(clone_or_update)
    echo ""

    # Detect Trae directories
    local dirs_found=0

    # Check ~/.trae (Trae 海外版)
    if [ -d "$HOME/.trae" ]; then
        install_to_dir "$HOME/.trae" "$repo_dir" "Trae 海外版"
        dirs_found=$((dirs_found + 1))
    fi

    # Check ~/.trae-cn (Trae 中国版)
    if [ -d "$HOME/.trae-cn" ]; then
        install_to_dir "$HOME/.trae-cn" "$repo_dir" "Trae-CN 中国版"
        dirs_found=$((dirs_found + 1))
    fi

    if [ "$dirs_found" -eq 0 ]; then
        log_warn "未找到 ~/.trae 或 ~/.trae-cn 目录"
        log_info "请先安装 Trae 或 Trae-CN，然后再运行此脚本"
        log_info "或者创建目录: mkdir -p ~/.trae"
        exit 1
    fi

    log_info "═══════════════════════════════════════════"
    log_info "  安装完成! 共安装到 $dirs_found 个目录"
    log_info "═══════════════════════════════════════════"
    echo ""
    log_info "运行 'bash ~/.trae-config/scripts/update.sh' 更新"
}

main
