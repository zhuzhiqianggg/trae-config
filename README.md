# trae-config

Trae IDE 全局配置：Skills、Agents、规则文档。多机器同步，一键安装。

## 快速安装

### Linux

```bash
# 首次安装
bash <(curl -s https://raw.githubusercontent.com/zhuzhiqianggg/trae-config/main/scripts/install.sh)

# 更新
bash <(curl -s https://raw.githubusercontent.com/zhuzhiqianggg/trae-config/main/scripts/update.sh)

# 或克隆后本地安装
git clone https://github.com/zhuzhiqianggg/trae-config.git ~/.trae-config
cd ~/.trae-config && bash scripts/install.sh
```

### Windows (PowerShell)

```powershell
# 首次安装
iwr -UseBasicParsing "https://raw.githubusercontent.com/zhuzhiqianggg/trae-config/main/scripts/install.ps1" | iex

# 更新
iwr -UseBasicParsing "https://raw.githubusercontent.com/zhuzhiqianggg/trae-config/main/scripts/update.ps1" | iex

# 或本地安装
git clone https://github.com/zhuzhiqianggg/trae-config.git $HOME\.trae-config
cd $HOME\.trae-config; .\scripts\install.ps1
```

## Skills 分类

| 分类 | 子目录 | 数量 | 来源 |
|------|--------|------|------|
| 核心工作流 | `core/` | 16 | [obra/superpowers](https://github.com/obra/superpowers) + ClawHub |
| 工程实践 | `eng/` | 21 | [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) |
| 架构设计 | `arch/` | 5 | agent-skills-hub |
| 前端设计 | `design/` | 4 | leonxlnx/taste-skill + agent-skills-hub |
| SEO 优化 | `seo/` | 5 | agent-skills-hub |
| 运维管理 | `ops/` | 14 | ClawHub + 自编 |
| 部署运维 | `devops/` | 4 | agent-skills-hub |
| 安全 | `sec/` | 2 | agent-skills-hub |
| 代码质量 | `quality/` | 2 | agent-skills-hub |
| 测试 | `test/` | 2 | agent-skills-hub |
| 文档编写 | `doc/` | 2 | agent-skills-hub |
| Git 版本控制 | `git/` | 1 | agent-skills-hub |
| React/Next.js | `react/` | 3 | agent-skills-hub |
| 编程模式 | `patterns/` | 3 | agent-skills-hub |
| WSL 管理 | `wsl/` | 1 | 自编 |

**总计: 85 skills** (16 核心工作流 + 69 专业技能)

完整索引: [skills/skills_summary.md](skills/skills_summary.md)

## 目录结构

```
.
├── skills/                 # 全局 Skills (85个，按分类子目录组织)
│   ├── core/               # 核心工作流 (16 superpowers + meta-skills)
│   ├── eng/                # 工程实践 (21)
│   ├── arch/               # 架构设计 (5)
│   ├── design/             # 前端设计 (4)
│   ├── seo/                # SEO 优化 (5)
│   ├── ops/                # 运维管理 (14)
│   ├── devops/             # 部署运维 (4)
│   ├── sec/                # 安全 (2)
│   ├── quality/            # 代码质量 (2)
│   ├── test/               # 测试 (2)
│   ├── doc/                # 文档编写 (2)
│   ├── git/                # Git 版本控制 (1)
│   ├── react/              # React/Next.js (3)
│   ├── patterns/           # 编程模式 (3)
│   ├── wsl/                # WSL 管理 (1)
│   └── skills_summary.md   # Skills 完整索引
├── agents/                 # Agent prompt 模板
│   ├── code-reviewer.md
│   ├── implementer.md
│   ├── spec-reviewer.md
│   └── code-quality-reviewer.md
├── rules/                  # 规则文档模板
│   ├── requirements.md
│   ├── project_memory.md
│   ├── lessons_learned.md
│   └── 项目规则.md
├── scripts/                # 安装/更新脚本
│   ├── install.sh          # Linux 安装
│   ├── update.sh           # Linux 更新
│   ├── install.ps1         # Windows 安装
│   └── update.ps1          # Windows 更新
└── user_rules.md           # 全局用户规则
```

## 多机器同步

5 台电脑共用此仓库，在任何机器上运行更新脚本即可同步。

```bash
# 任何机器上
bash scripts/update.sh     # Linux
.\scripts\update.ps1       # Windows
```

## 安装位置

| 系统 | 目录 |
|------|------|
| Linux | `~/.trae/` |
| Windows | `~/.trae-cn/` 或 `~/.trae/` |

安装脚本会自动检测已存在的目录。

## 许可证

Skills 遵循各自的原始许可证。
