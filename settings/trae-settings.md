# Trae IDE 推荐配置

> 适用于 projects/.trae/settings.json

## 编辑器设置

```jsonc
{
  // 编辑器基础
  "editor.fontSize": 14,
  "editor.fontFamily": "'JetBrains Mono', 'Cascadia Code', 'Fira Code', Consolas, monospace",
  "editor.fontLigatures": true,
  "editor.lineHeight": 24,
  "editor.tabSize": 2,
  "editor.renderWhitespace": "boundary",
  "editor.bracketPairColorization.enabled": true,
  "editor.guides.bracketPairs": true,
  "editor.minimap.enabled": true,
  "editor.minimap.scale": 2,
  "editor.wordWrap": "off",
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": "explicit",
    "source.organizeImports": "explicit"
  },

  // 文件
  "files.autoSave": "onFocusChange",
  "files.exclude": {
    "**/.git": true,
    "**/.DS_Store": true,
    "**/node_modules": true,
    "**/__pycache__": true,
    "**/.trash": true
  },

  // 工作台
  "workbench.colorTheme": "Default Dark+",
  "workbench.iconTheme": "material-icon-theme",
  "workbench.startupEditor": "none",

  // 终端
  "terminal.integrated.fontSize": 13,
  "terminal.integrated.defaultProfile.windows": "PowerShell",
  "terminal.integrated.defaultProfile.linux": "bash",

  // Git
  "git.enableSmartCommit": true,
  "git.confirmSync": false,
  "git.autofetch": true,

  // AI 设置
  "traeAI.codeIndex.enabled": true,
  "traeAI.codeIndex.autoStart": true,
  "traeAI.chatLanguage": "auto",

  // 扩展推荐
  "extensions.json": {
    "recommendations": [
      "dbaeumer.vscode-eslint",
      "esbenp.prettier-vscode",
      "bradlc.vscode-tailwindcss",
      "formulahendry.auto-rename-tag",
      "streetsidesoftware.code-spell-checker",
      "eamodio.gitlens",
      "ms-vsliveshare.vsliveshare"
    ]
  }
}
```

## 快捷键参考

| 操作 | Windows/Linux | macOS |
|------|--------------|-------|
| 侧边聊天 | `Ctrl+L` | `Cmd+L` |
| 内联聊天 | `Ctrl+I` | `Cmd+I` |
| 快捷AI操作 | `Ctrl+K` | `Cmd+K` |
| Builder模式 | `Ctrl+Shift+L` | `Cmd+Shift+L` |
| 打开设置 | `Ctrl+,` | `Cmd+,` |
| 命令面板 | `Ctrl+Shift+P` | `Cmd+Shift+P` |
| 文件搜索 | `Ctrl+P` | `Cmd+P` |

## 导入配置

Trae 支持从 VS Code / Cursor 一键导入配置：
1. 设置 → 导入配置 → 从 VS Code/Cursor
2. 自动导入：扩展、设置、代码片段、快捷键
