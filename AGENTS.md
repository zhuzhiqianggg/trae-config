# AGENTS.md

> Trae IDE AI 代理项目配置。给 AI 编码代理看的 README。

## 项目概览

本项目使用 Trae IDE 进行 AI 辅助开发，配备了 Superpowers 工作流和完整的 Skills 库。

## 全局配置位置

- **Skills**: `~/.trae/skills/` (88 个 skills)
- **Agents**: `~/.trae/agents/` (7 个 agent prompts: code-reviewer, code-quality-reviewer, implementer, performance-reviewer, security-reviewer, spec-reviewer, testing-agent)
- **Settings**: `~/.trae/settings/` (MCP 模板、编辑器配置、功能全景图)
- **Rules**: `~/.trae/rules/` + `~/.trae/user_rules.md`
- **配置仓库**: https://github.com/zhuzhiqianggg/trae-config

## Skills 分类 (仓库按子目录组织，安装时自动扁平化)

| 子目录 | 类别 | 数量 |
|--------|------|------|
| `core/` | 核心工作流 (Superpowers + 元技能) | 16 |
| `eng/` | 工程实践 (代码审查, 简化, 性能, 重构, 可访问性) | 23 |
| `arch/` | 架构设计 | 5 |
| `design/` | 前端设计 (品味, UI, 可访问性) | 4 |
| `seo/` | SEO 优化 | 5 |
| `ops/` | 运维管理 (Docker, K8s, 监控, DB, 脚本, MCP) | 15 |
| `devops/` | 部署运维 (IaC, CI/CD, Vercel) | 4 |
| `sec/` | 安全 | 2 |
| `quality/` | 代码质量 | 2 |
| `test/` | 测试 | 2 |
| `doc/` | 文档编写 | 2 |
| `git/` | Git 版本控制 | 1 |
| `react/` | React/Next.js | 3 |
| `patterns/` | 编程模式 (错误处理, 性能, Prompt) | 3 |
| `wsl/` | WSL2 管理 | 1 |

## 核心工作流

```
需求 → brainstorming → writing-plans → subagent-driven-development
→ test-driven-development → requesting-code-review → finishing
```

## 代码规范

- 遵循项目现有代码风格
- 新功能必须包含测试
- 提交信息格式：`type: 简短描述`
- 禁止硬编码敏感信息

## 安全规则

- 禁止提交密码、密钥、Token
- 所有用户输入必须校验
- SQL 使用参数化语句

## 文档更新

Agent 必须在合适时机主动更新项目文档：
- 收到需求 → `.trae/rules/requirements.md`
- 技术决策 → `.trae/rules/project_memory.md`
- 遇到错误 → `.trae/rules/lessons_learned.md`

## 同步方式

多机器通过 Git 同步配置：
```bash
# 安装
git clone https://github.com/zhuzhiqianggg/trae-config.git ~/.trae-config
cd ~/.trae-config && bash scripts/install.sh

# 更新
bash ~/.trae-config/scripts/update.sh
```
