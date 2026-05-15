# 全局规则 — Trae IDE

> 适用于所有项目的 AI 助手行为规范
> 最后更新: 2026-05-15

## 一、核心行为规范

### 1. 文件安全
- 禁止使用 `rm` / `del` 命令删除文件
- 必须使用 `mv` 将文件移至 `.trash/`（Linux/WSL）或项目回收站
- 示例：`mv 待删文件 .trash/`

### 2. Skills 优先
- 任何任务开始前，必须检查是否有适用的 Skill
- 即使只有 1% 可能性匹配，也要调用相关 Skill
- Skills 覆盖默认行为，但用户指令优先级最高
- 始终使用 `skill` 工具加载匹配的 Skill

### 3. 先设计后实现
- 接到任务后先理解需求，不要急于写代码
- 复杂需求先调用 `brainstorming` 或 `writing-plans` skill
- 多步骤任务必须有书面计划

### 4. 证据先于声明
- 声明完成前必须运行测试/lint/类型检查验证
- 不要假设，要验证
- 任何 "应该可以了" 的表述都必须附带验证结果

### 5. 文档自动维护

| 触发条件 | 文档 | 时机 |
|----------|------|------|
| 收到新需求 | `.trae/rules/requirements.md` | 立即 |
| 需求变更/完成 | `.trae/rules/requirements.md` | 变更/完成时 |
| 技术决策 | `.trae/rules/project_memory.md` | 决策后立即 |
| 发现关键信息 | `.trae/rules/project_memory.md` | 发现后立即 |
| 遇到并解决错误 | `.trae/rules/lessons_learned.md` | 解决后 |
| 踩坑总结 | `.trae/rules/lessons_learned.md` | 总结后 |
| 学到新技能 | `.trae/rules/skills_summary.md` | 学会后 |

### 6. AGENTS.md 自动维护
- 项目开始时检查并创建 AGENTS.md
- 功能变更后立即更新
- 禁止 AGENTS.md 描述与实际代码不符

## 二、Trae IDE 最佳实践

### MCP 服务器
- 需要浏览器自动化 → 配置 Playwright MCP
- 需要 GitHub 操作 → 配置 GitHub MCP Server（需 Docker + PAT）
- 需要文件操作 → 配置 Filesystem MCP
- 需要数据库查询 → 配置 PostgreSQL/SQLite MCP
- 配置入口：设置 → MCP → 添加 MCP 服务器
- 参考：`settings/mcp-servers.md`

### 模型选择
| 场景 | 模型 | 原因 |
|------|------|------|
| 复杂编码 | Claude 3.7 Sonnet | 最强编码能力 |
| 快速对话 | GPT-4o | 速度快，日常够用 |
| 调试分析 | DeepSeek R1 | 推理能力强 |
| Builder 模式 | Claude 3.7 Sonnet | 项目骨架生成 |
| 长上下文 | GPT-4o / DeepSeek V3 | 支持 128K+ 上下文 |

### Agent 模式选择
| 模式 | 适用场景 | 说明 |
|------|---------|------|
| Chat | 问答/代码解释/小修改 | 手动确认每条命令 |
| Agent | 自动执行多步骤任务 | 自动执行命令（需预先确认） |
| Builder | 从零构建项目 | 自动生成完整项目 |
| Max | 长文本/复杂分析 | 超大上下文窗口 |

### 快捷键
| 操作 | 快捷键 |
|------|--------|
| 侧边聊天 | `Ctrl+L` |
| 内联聊天 | `Ctrl+I` |
| Builder 模式 | `Ctrl+Shift+L` |
| 命令面板 | `Ctrl+Shift+P` |

## 三、开发工作流

```
需求 → brainstorming → writing-plans → subagent-driven-development
→ test-driven-development → requesting-code-review → finishing
```

**核心原则：**
- TDD — 先写测试，再写代码
- 系统化 — 流程优于猜测
- 简化 — 降低复杂度是第一目标
- 验证 — 声明成功前必须验证

## 四、Skill 质量标准

编写的 Skill 必须满足：

| 维度 | 要求 |
|------|------|
| 最小规模 | ≥40 行有效内容 |
| 结构 | 必须有 frontmatter（name, model）+ 正文 |
| 触发条件 | 清晰描述何时使用 |
| 步骤 | 逐步、可执行、有代码示例 |
| 完整性 | 包含反模式/常见陷阱说明 |

## 五、Git 规范

### 分支命名
```
feature/<描述>     # 新功能
fix/<描述>         # Bug 修复
refactor/<描述>    # 重构
chore/<描述>       # 维护任务
```

### 提交信息
```
type: 简短描述（不超过72字符，祈使语气，末尾无句号）
type: feat | fix | refactor | chore | docs | test | style | perf
```

## 六、多机器同步

```
仓库: git@github.com:zhuzhiqianggg/trae-config.git
安装: bash scripts/install.sh       # Linux
      .\scripts\install.ps1         # Windows
更新: bash scripts/update.sh        # Linux
      .\scripts\update.ps1          # Windows
```

## 优先级

```
1. 用户明确指令 (最高)
2. 项目级规则 (.trae/rules/)
3. 全局规则 (本文件)
4. Skills
5. 默认系统行为 (最低)
```
