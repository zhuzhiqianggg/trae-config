# Trae IDE MCP Servers 配置参考

> MCP (Model Context Protocol) 让 AI Agent 拥有调用外部工具的能力。
> 配置入口：Trae 设置 → MCP → 添加 MCP 服务器

## 前置依赖

```bash
# Node.js ≥18 (npx)
node -v && npx -v

# Python ≥3.8 + uvx (可选，用于 Python 类 MCP)
python --version && uvx --version

# Docker (可选，用于 GitHub MCP Server)
docker --version
```

## 推荐 MCP 服务器

### 1. Playwright MCP — 浏览器自动化/测试

```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["-y", "@playwright/mcp"]
    }
  }
}
```

### 2. GitHub MCP Server — 仓库/PR/Issue 管理

```json
{
  "mcpServers": {
    "github": {
      "command": "docker",
      "args": [
        "run", "-i", "--rm",
        "-e", "GITHUB_PERSONAL_ACCESS_TOKEN",
        "ghcr.io/github/github-mcp-server"
      ],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "你的 GitHub Token"
      }
    }
  }
}
```

### 3. Chrome DevTools MCP — 前端调试

```json
{
  "mcpServers": {
    "chrome-devtools": {
      "command": "npx",
      "args": ["-y", "chrome-devtools-mcp@latest"]
    }
  }
}
```

### 4. Filesystem MCP — 文件操作

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/允许的路径"]
    }
  }
}
```

### 5. Memory MCP — 跨会话记忆

```json
{
  "mcpServers": {
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"]
    }
  }
}
```

### 6. PostgreSQL MCP — 数据库查询

```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres", "postgresql://用户:密码@主机:端口/数据库"]
    }
  }
}
```

### 7. Sequential Thinking MCP — 复杂问题分步推理

```json
{
  "mcpServers": {
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
    }
  }
}
```

## 配置说明

| 传输方式 | 适用场景 | 配置示例 |
|---------|---------|---------|
| `stdio` | 本地工具（大多数情况） | `"command": "npx", "args": [...]` |
| `sse` | 远端服务 | `"url": "https://服务地址/mcp", "type": "sse"` |

## 最佳实践

1. **按项目启用**：只在需要的项目配置 MCP，避免 Agent 工具选择混乱
2. **API 密钥安全**：使用 `env` 字段传入敏感信息，不要硬编码在 args 中
3. **MCP 市场**：Trae 内置 MCP 市场（设置 → MCP → 从市场添加），一键添加流行 MCP
4. **自定义 MCP**：可通过 `npx`/`uvx`/`docker` 等方式运行自定义 MCP 服务器
