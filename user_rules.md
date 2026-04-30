# 全局规则 — Trae IDE

> 适用于所有项目的 AI 助手行为规范

## 一、核心行为规范

### 1. 文件删除规范
- 禁止使用 `rm` 命令
- 必须使用 `mv` 命令将文件移至 `.trash/` 目录
- 示例：`mv 待删文件 .trash/`

### 2. Skills 优先
- 任何任务开始前，必须检查是否有适用的 Skill
- 即使 1% 可能性，也要调用相关 Skill
- Skills 覆盖默认行为，但用户指令优先级最高

### 3. 先设计后实现
- 接到任务后先理解需求，不要急于写代码
- 复杂需求先调用 brainstorming skill

### 4. 证据先于声明
- 声明完成前必须运行测试验证
- 不要假设，要验证

### 5. 文档主动更新（重要）

**Agent 必须在合适的时机主动更新项目文档，无需用户提醒：**

| 触发条件 | 更新哪个文档 | 时机 |
|----------|-------------|------|
| 收到新需求 | requirements.md | 收到需求时立即 |
| 需求变更/完成 | requirements.md | 变更/完成时 |
| 做出技术决策 | project_memory.md | 决策完成后 |
| 发现关键信息 | project_memory.md | 发现后立即 |
| 遇到并解决错误 | lessons_learned.md | 解决后 |
| 踩坑总结 | lessons_learned.md | 总结后 |
| 学到新技能 | skills_summary.md | 学会后 |

## 二、开发工作流（Superpowers）

```
用户需求 → brainstorming → using-git-worktrees → writing-plans
→ subagent-driven-development → test-driven-development
→ requesting-code-review → finishing-a-development-branch
```

**核心原则：**
- TDD — 先写测试，再写代码
- 系统化 — 流程优于猜测
- 简化 — 降低复杂度是第一目标
- 验证 — 声明成功前必须验证

## 三、文档维护体系

### 项目级（每个项目独立）
```
项目/.trae/rules/
├── requirements.md        # 需求记录
├── project_memory.md      # 项目记忆
├── lessons_learned.md     # 经验教训
└── 项目规则.md            # 项目特有规则
```

### 全局级（~/.trae/ 统一管理）
```
~/.trae/
├── user_rules.md          # 本文件
├── skills/                # 全局 Skills
├── agents/                # 全局 Agents
└── rules/                 # 规则模板
```

## 四、Git 规范

### 分支命名
```
feature/<描述>    # 新功能
fix/<描述>        # Bug 修复
refactor/<描述>   # 重构
chore/<描述>      # 维护任务
```

### 提交信息
```
type: 简短描述

type: feat, fix, refactor, chore, docs, test, style, perf
- 最多 72 字符
- 祈使语气（"add" 不是 "added"）
- 末尾不加句号
```

## 五、多机器同步

- 配置通过 Git 仓库同步：`git@github.com:zhuzhiqianggg/trae-config.git`
- 安装：`bash scripts/install.sh`
- 更新：`bash scripts/update.sh`
- 支持 Linux (~/.trae/) 和 Windows (~/.trae-cn/)

## 优先级

```
1. 用户明确指令 (最高)
2. 项目级规则 (.trae/rules/)
3. 全局规则 (本文件)
4. Superpowers skills
5. 默认系统行为 (最低)
```

---

**最后更新**: 2025-04-30
**维护**: git@github.com:zhuzhiqianggg/trae-config.git
