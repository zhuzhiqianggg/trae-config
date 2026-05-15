---
name: trae-mcp-servers
model: 
- claude-3.7-sonnet
- gpt-4o
---

# MCP Servers 配置与使用

Configure and use MCP (Model Context Protocol) servers in Trae IDE to give the AI agent real tool capabilities.

## When to Use

- Setting up browser automation for testing
- Integrating with GitHub for PR/issue management
- Adding database query capabilities to the agent
- Enabling filesystem operations
- Adding web scraping and data collection
- Any time the agent needs to interact with external systems

## Core MCP Servers

### 1. Playwright MCP (Browser Automation)

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

Capabilities:
- Navigate to URLs and inspect page content
- Click elements, fill forms, take screenshots
- Run JavaScript in browser context
- Generate end-to-end tests
- Debug network requests and console logs

### 2. GitHub MCP Server

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
        "GITHUB_PERSONAL_ACCESS_TOKEN": "<your-token>"
      }
    }
  }
}
```

Requires: Docker, GitHub PAT with repo scope.

### 3. Filesystem MCP

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/workspace"]
    }
  }
}
```

### 4. Sequential Thinking

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

## Configuration

Open Trae Settings → MCP → Add Manually, paste the JSON.

## Best Practices

1. Only enable MCP servers you actually need for the current project
2. Store API keys in `env` field, never hardcode them
3. Use Trae's built-in MCP Marketplace for community-verified servers
4. Test MCP server is working by asking the agent to use it
5. Check MCP logs in Settings → MCP → server name → View Logs if something fails

## MCP + Skills Workflow

Combine MCP servers with skills for powerful automation:
- Playwright MCP + `eng-browser-testing-with-devtools`: automated web testing
- GitHub MCP + `eng-ci-cd-and-automation`: automated PR/CI workflows
- Filesystem MCP + `eng-code-review-and-quality`: automated file analysis
