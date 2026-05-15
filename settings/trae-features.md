# Trae IDE 功能全景图

> 完整罗列 Trae IDE 的核心功能、配置方式、最佳实践
> 本文件作为参考，帮助理解哪些可以通过配置文件管理，哪些需要在 UI 中手动设置

## 一、可通过本仓库管理（自动同步到多台机器）

| 功能 | 文件位置 | 配置内容 |
|------|---------|---------|
| Skills | `~/.trae/skills/*/SKILL.md` | AI 工作流和专业知识指令 (86个) |
| Agent Prompts | `~/.trae/agents/*.md` | 子代理的提示词模板 (code-reviewer, implementer 等) |
| Rules | `~/.trae/rules/*.md` | 需求、项目记忆、经验教训模板 |
| 全局规则 | `~/.trae/user_rules.md` | AI 行为规范，每次对话自动加载 |
| Settings 参考 | `~/.trae/settings/*.md` | MCP 配置模板、编辑器设置参考 |

## 二、需在 Trae UI 中手动配置

### MCP 服务器

需要先在 Trae 中启用：
1. 设置 → MCP → 添加 MCP 服务器
2. 从市场添加 或 手动添加
3. 配置 JSON（参考 `settings/mcp-servers.md`）

### 自定义 Agent

1. 聊天框输入 `@` → 创建 Agent → 智能生成/手动创建
2. 配置：名称、提示词、MCP 服务器、内置工具、Skills
3. Agent 可设置是否允许被其他 Agent 调用（子代理模式）

### 代码索引 (Code Index)

1. 设置 → Trae AI → 代码索引管理
2. 为 #Workspace 和 #Folder 命令提供准确上下文
3. ≤5000 文件自动索引，更大项目需手动启动

### Memories (记忆)

1. 设置 → Rules & Skills → 启用 Memories
2. 自动保存重要偏好和规则到本地
3. 全局记忆（所有项目）和项目记忆（当前项目）
4. 每种最多 20 条，不同机器不共享

### 忽略文件 (Ignore Files)

1. 设置 → Ignore Files
2. 补充 `.gitignore` 的规则，控制 AI 索引范围
3. 不含敏感文件、构建产物、第三方依赖

### CUE (智能编程)

1. 设置 → CUE 面板，或右下角 CUE 按钮
2. 功能：自动补全、多行编辑、预测编辑、跳转编辑
3. Cue-Pro：仓库级链式补全

### Sandbox (沙盒)

1. 设置 → 安全 → 沙盒模式 (Beta)
2. 文件系统隔离：Agent 只允许访问项目目录 + 临时目录
3. Shell 拦截：拦截高危命令（rm, rmdir 等）
4. 三种响应：跳过 / 放行 / 加入白名单

### Max Mode

1. Agent 模式下拉 → Max Mode（Pro 用户）
2. 200K token 上下文，最多 200 次工具调用
3. 支持 Claude 4 Sonnet Beta、Claude 3.7 Sonnet、Claude 3.5 Sonnet
4. 按 Token 计费，从 Fast Request 余额扣除

### 自定义模型

1. 设置 → Models → + 添加模型
2. 支持：Anthropic, OpenAI, Gemini, DeepSeek, AWS, Ollama 等 20+ 提供商
3. 可配置 API Key、模型 ID、自定义端点

### 自动运行 & 命令安全

1. 设置 → Auto-run & Security
2. 黑名单模式：设置不能自动运行的命令
3. 白名单模式（已提需求，尚未实现）：只允许指定的命令自动运行
4. 当前每次命令执行仍需用户确认

## 三、模型选择指南

| 模型 | 最佳场景 | 上下文 | 工具调用 |
|------|---------|--------|---------|
| Claude 3.7 Sonnet | 复杂编码、Agent 模式 (推荐) | 标准 | ✅ |
| Claude 3.5 Sonnet | 快速编码 | 标准 | ✅ |
| GPT-4o | 日常对话、快速迭代 | 标准 | ✅ |
| DeepSeek R1 | 调试分析、复杂推理 | 标准 | ✅ |
| DeepSeek V3 | 长上下文场景 | 128K+ | ✅ |
| Gemini 2.5 Flash | 成本敏感场景 | 标准 | ✅ |
| Kimi K2 | 长上下文（新模型） | 100K+ | ✅ |
| GPT-5.3 Codex | 代码专用模型 | 标准 | ✅ |

## 四、Agent 模式对比

| 模式 | 适用场景 | 自动执行 | 上下文 |
|------|---------|---------|--------|
| Chat | 问答、代码解释、小修改 | ❌ 手动确认每条命令 | 标准 |
| Agent | 自动多步骤任务 | ✅ 自动执行（需预先确认） | 标准 |
| Builder | 从零构建项目 | ✅ 全自动 | 标准 |
| Max | 长文本、复杂分析 | ✅ 最多 200 次工具调用 | 200K |

## 五、配置路径参考

```
~/.trae/                           # 全局配置根目录
├── mcp.json                       # MCP 服务器全局配置
├── user_rules.md                  # 用户级 AI 行为规则
├── user_rules/                    # 用户规则目录（多文件）
├── skill-config.json              # 技能禁用注册表
├── skills/                        # 技能文件（本仓库管理）
├── agents/                        # Agent 提示词（本仓库管理）
├── rules/                         # 规则模板（本仓库管理）
├── settings/                      # 设置参考（本仓库管理）

.trae/                             # 项目级配置根目录
├── mcp.json                       # 项目级 MCP 配置
├── project_rules.md               # 项目级 AI 行为规则

~/.cursor/mcp.json                 # Cursor 兼容的 MCP 配置（Trae 也读取）
```

## 六、已知限制 (截至 2026-05)

| 功能 | 状态 | 备注 |
|------|------|------|
| `.trae/settings.json` | ❌ 不支持 | GitHub issue #42 已关闭 |
| 命令白名单 | ❌ 不支持 | 社区已提需求，规划中 |
| 跨机器记忆同步 | ❌ 不支持 | Memories 存储在本地 |
| Linux 支持 | ⚠️ 有限 | 主要在 macOS/Windows |
| `.traeignore` 文件 | ⚠️ 不支持文件 | 通过 UI 配置忽略规则 |
