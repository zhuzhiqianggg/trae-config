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
iwr "https://raw.githubusercontent.com/zhuzhiqianggg/trae-config/main/scripts/install.ps1" | iex

# 更新
iwr "https://raw.githubusercontent.com/zhuzhiqianggg/trae-config/main/scripts/update.ps1" | iex

# 或本地安装
git clone https://github.com/zhuzhiqianggg/trae-config.git $HOME\.trae-config
cd $HOME\.trae-config; .\scripts\install.ps1
```

## Skills 分类

| 前缀 | 类别 | 数量 | 来源 |
|------|------|------|------|
| `superpowers-` | 核心工作流 (TDD, 调试, 规划等) | 14 | [obra/superpowers](https://github.com/obra/superpowers) |
| `eng-` | 工程实践 (代码审查, 简化, 性能等) | 21 | [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) |
| `arch-` | 架构设计 (API, 模式, 云架构等) | 5 | [agent-skills-hub](https://github.com/agent-skills-hub/agent-skills-hub) |
| `quality-` | 代码质量 (clean code, 重构等) | 3 | agent-skills-hub |
| `test-` | 测试 (模式, API 测试等) | 3 | agent-skills-hub |
| `devops-` | 部署运维 (CI/CD, Terraform, Vercel) | 3 | agent-skills-hub |
| `sec-` | 安全 (API 安全, 安全审查) | 2 | agent-skills-hub |
| `git-` | Git 版本控制 | 1 | agent-skills-hub |
| `doc-` | 文档编写 (ADR, API 文档等) | 4 | agent-skills-hub |

**总计: 56 skills**

完整索引: [skills/skills_summary.md](skills/skills_summary.md)

## 目录结构

```
.
├── skills/           # 全局 Skills (56个)
│   ├── superpowers-*/        # Superpowers 核心
│   ├── eng-*/                # Engineering 工程实践
│   ├── arch-*/               # Architecture 架构
│   ├── quality-*/            # Quality 代码质量
│   ├── test-*/               # Testing 测试
│   ├── devops-*/             # DevOps 运维
│   ├── sec-*/                # Security 安全
│   ├── git-*/                # Git 版本控制
│   ├── doc-*/                # Documentation 文档
│   └── skills_summary.md     # Skills 索引
├── agents/           # Agent prompt 模板
│   ├── code-reviewer.md
│   ├── implementer.md
│   ├── spec-reviewer.md
│   └── code-quality-reviewer.md
├── rules/            # 规则文档模板
│   ├── requirements.md
│   ├── project_memory.md
│   ├── lessons_learned.md
│   └── 项目规则.md
├── scripts/          # 安装/更新脚本
│   ├── install.sh    # Linux 安装
│   ├── update.sh     # Linux 更新
│   ├── install.ps1   # Windows 安装
│   └── update.ps1    # Windows 更新
└── user_rules.md     # 全局用户规则
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
