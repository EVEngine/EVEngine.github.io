# EVEngine.github.io

EVEngine 组织的项目宣传主页，托管于 GitHub Pages：
<https://evengine.github.io/>

内容：

- 项目介绍与跨平台矩阵
- v0.1.0 各平台 SDK 下载链接与校验和（下载解压即用，无需编译引擎）
- AI 一键接入：`skills/evengine/SKILL.md`（Agent Skills 开放标准，Codex / Cursor /
  Claude Code 通用）+ SDK 自带的 `eve mcp` 无头 MCP host
- 在线文档与源码仓库入口

修改 `index.html` 后推送到 `main` 即可自动发布。

## 给 AI 用户安装 skill

`skills/evengine/SKILL.md` 是标准的 Agent Skills 格式（frontmatter 只有
`name` + `description`），三种工具通用，安装就是把目录放到对应位置：

| 工具 | 用户级（所有项目） | 项目级（随仓库共享） |
| ---- | ------------------ | -------------------- |
| Codex | `~/.agents/skills/evengine/` | `<repo>/.agents/skills/evengine/` |
| Cursor | `~/.cursor/skills/evengine/` | `<repo>/.cursor/skills/evengine/` |
| Claude Code | `~/.claude/skills/evengine/` | `<repo>/.claude/skills/evengine/` |

一行安装（示例：Codex 用户级）：

```bash
mkdir -p ~/.agents/skills/evengine && \
curl -fsSL https://raw.githubusercontent.com/EVEngine/EVEngine.github.io/main/skills/evengine/SKILL.md \
  -o ~/.agents/skills/evengine/SKILL.md
```

MCP 接入见主页 AI 区：Codex 用 `codex mcp add evengine -- eve mcp --root <game>`，
Cursor 写 `.cursor/mcp.json`，Claude 用 `claude mcp add evengine -- eve mcp --root <game>`。
