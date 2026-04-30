# Trae Config 安装指南

## 一键安装命令

### Linux / WSL2 / SSH Remote

```bash
# 首次安装
bash -c '
set -e
TRAE_DIR="$HOME/.trae"
CLONE_DIR="$HOME/.trae-config"

if [ ! -d "$CLONE_DIR/.git" ]; then
  git clone --depth 1 https://github.com/zhuzhiqianggg/trae-config.git "$CLONE_DIR"
else
  git -C "$CLONE_DIR" pull --quiet
fi

mkdir -p "$TRAE_DIR"
cp -r "$CLONE_DIR/skills/" "$TRAE_DIR/skills/"
mkdir -p "$TRAE_DIR/agents" && cp "$CLONE_DIR/agents/"* "$TRAE_DIR/agents/"
mkdir -p "$TRAE_DIR/rules" && cp "$CLONE_DIR/rules/"* "$TRAE_DIR/rules/"
cp "$CLONE_DIR/user_rules.md" "$TRAE_DIR/"

echo "✓ 安装完成"
echo "Skills: $(ls -d $TRAE_DIR/skills/*/ | wc -l) 个"
echo "Agents: $(ls $TRAE_DIR/agents/ | wc -w) 个"
echo "Rules: $(ls $TRAE_DIR/rules/ | wc -w) 个"
'
```

```bash
# 后续更新
bash -c '
TRAE_DIR="$HOME/.trae"
CLONE_DIR="$HOME/.trae-config"
[ -d "$CLONE_DIR/.git" ] && git -C "$CLONE_DIR" pull --quiet || git clone --depth 1 https://github.com/zhuzhiqianggg/trae-config.git "$CLONE_DIR"
mkdir -p "$TRAE_DIR"
cp -r "$CLONE_DIR/skills/" "$TRAE_DIR/skills/"
mkdir -p "$TRAE_DIR/agents" && cp "$CLONE_DIR/agents/"* "$TRAE_DIR/agents/"
mkdir -p "$TRAE_DIR/rules" && cp "$CLONE_DIR/rules/"* "$TRAE_DIR/rules/"
cp "$CLONE_DIR/user_rules.md" "$TRAE_DIR/"
echo "✓ 更新完成"
'
```

### Windows (PowerShell)

```powershell
# 首次安装
$ErrorActionPreference = "Stop"
$TRAE_DIR = if (Test-Path "$HOME\.trae-cn") { "$HOME\.trae-cn" } else { "$HOME\.trae" }
$CLONE_DIR = "$HOME\.trae-config"

if (!(Test-Path "$CLONE_DIR\.git")) {
  git clone --depth 1 https://github.com/zhuzhiqianggg/trae-config.git $CLONE_DIR
} else {
  Set-Location $CLONE_DIR; git pull --quiet
}

New-Item -ItemType Directory -Path $TRAE_DIR -Force | Out-Null
Copy-Item -Recurse "$CLONE_DIR\skills\*" "$TRAE_DIR\skills\" -Force
New-Item -ItemType Directory -Path "$TRAE_DIR\agents" -Force | Out-Null
Copy-Item "$CLONE_DIR\agents\*" "$TRAE_DIR\agents\" -Force
New-Item -ItemType Directory -Path "$TRAE_DIR\rules" -Force | Out-Null
Copy-Item "$CLONE_DIR\rules\*" "$TRAE_DIR\rules\" -Force
Copy-Item "$CLONE_DIR\user_rules.md" "$TRAE_DIR\" -Force
Write-Host "✓ 安装完成"
```

```powershell
# 后续更新
$ErrorActionPreference = "Stop"
$TRAE_DIR = if (Test-Path "$HOME\.trae-cn") { "$HOME\.trae-cn" } else { "$HOME\.trae" }
$CLONE_DIR = "$HOME\.trae-config"

Set-Location $CLONE_DIR; git pull --quiet
Copy-Item -Recurse "$CLONE_DIR\skills\*" "$TRAE_DIR\skills\" -Force
Copy-Item "$CLONE_DIR\agents\*" "$TRAE_DIR\agents\" -Force
Copy-Item "$CLONE_DIR\rules\*" "$TRAE_DIR\rules\" -Force
Copy-Item "$CLONE_DIR\user_rules.md" "$TRAE_DIR\" -Force
Write-Host "✓ 更新完成"
```

## SSH Remote 环境说明

Trae 通过 SSH 连接远程服务器时，配置安装在**远程服务器的用户主目录**下：

```
远程服务器 ~/.trae/
├── skills/     # Skills
├── agents/     # Agents
├── rules/      # Rules
└── user_rules.md
```

**注意**：SSH Remote 环境下，Trae 读取的是远程服务器上的 `~/.trae/`，不是本地的。

## 验证安装

```bash
echo "=== 验证安装 ==="
echo "Skills: $(ls -d ~/.trae/skills/*/ 2>/dev/null | wc -l) 个"
echo "Agents: $(ls ~/.trae/agents/ 2>/dev/null | wc -w) 个"
echo "Rules: $(ls ~/.trae/rules/ 2>/dev/null | wc -w) 个"
echo "user_rules.md: $(test -f ~/.trae/user_rules.md && echo '✓ 存在' || echo '✗ 不存在')"
```

## 问题排查

### 1. 安装后 Skills 不生效

```bash
# 检查 Trae 读取的目录
ls -la ~/.trae/skills/ | head -5
ls -la ~/.trae/skills/superpowers-brainstorming/SKILL.md

# 确认 Trae 版本是否支持全局 Skills
# 重启 Trae 使配置生效
```

### 2. WSL2 环境下安装

WSL2 使用 `~/.trae` 目录（与 Linux 相同）：

```bash
# 在 WSL2 终端中执行
bash -c 'curl -s https://raw.githubusercontent.com/zhuzhiqianggg/trae-config/main/scripts/install.sh | bash'

# 或者本地安装
cd ~ && git clone --depth 1 https://github.com/zhuzhiqianggg/trae-config.git .trae-config
cd .trae-config && bash scripts/install.sh
```

### 3. Windows 原生 Trae CN

Trae CN 使用 `~/.trae-cn` 目录：

```powershell
# 在 PowerShell 中执行
iwr "https://raw.githubusercontent.com/zhuzhiqianggg/trae-config/main/scripts/install.ps1" | iex
```
