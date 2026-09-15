# EVEngine.github.io

EVEngine 组织的项目宣传主页，托管于 GitHub Pages：
<https://evengine.github.io/>

内容：

- 项目介绍与跨平台矩阵
- 自动读取 GitHub Latest Release 的版本号、各平台 SDK 下载链接与校验和；API
  不可用时回退到当前正式版（下载解压即用，无需编译引擎）
- AI 一键接入：`skills/evengine/SKILL.md`（Agent Skills 开放标准，Codex / Cursor /
  Claude Code 通用）+ 通过 AI 工具 MCP 配置接入的 `eve mcp`
  （MCP 服务，本身不含大模型，由工具链拉起，无需单独运行）
- 开发博客（<https://evengine.github.io/Blog/>）：开发日志与技术笔记
- 在线文档与源码仓库入口

修改 `index.html` 后推送到 `main` 即可自动发布。

首页运行时读取 `https://api.github.com/repos/EVEngine/EVEngine/releases/latest`，按
`eve-sdk-<platform>-<tag>.zip` 精确匹配五个平台的 Release asset。发布新正式版后
无需再修改首页；draft、prerelease、缺失附件或 API 请求失败时不会写入半套链接，
页面会保留 HTML 中的当前正式版作为静态回退。

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
