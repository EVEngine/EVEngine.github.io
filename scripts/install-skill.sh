#!/usr/bin/env sh
# Install the EVEngine skill for Codex / Cursor / Claude Code.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/EVEngine/EVEngine.github.io/main/scripts/install-skill.sh | bash -s codex
#   (tools: codex | cursor | claude)
#
# EVE_SKILL_PREFIX overrides $HOME (used for testing / non-standard setups).
set -eu

TOOL="${1:-codex}"
RAW="https://raw.githubusercontent.com/EVEngine/EVEngine.github.io/main/skills/evengine/SKILL.md"
PREFIX="${EVE_SKILL_PREFIX:-$HOME}"

case "$TOOL" in
  codex)  DIR="$PREFIX/.agents/skills/evengine"  ;;
  cursor) DIR="$PREFIX/.cursor/skills/evengine"  ;;
  claude) DIR="$PREFIX/.claude/skills/evengine"  ;;
  *)
    echo "unknown tool: $TOOL (use: codex | cursor | claude)" >&2
    exit 2
    ;;
esac

mkdir -p "$DIR"
if command -v curl >/dev/null 2>&1; then
  curl -fsSL "$RAW" -o "$DIR/SKILL.md"
else
  wget -qO- "$RAW" > "$DIR/SKILL.md"
fi
echo "OK: EVEngine skill installed -> $DIR/SKILL.md"

if command -v eve >/dev/null 2>&1; then
  case "$TOOL" in
    codex)
      if command -v codex >/dev/null 2>&1; then
        codex mcp add evengine -- eve mcp || echo "WARN: run manually: codex mcp add evengine -- eve mcp"
      else
        echo "NOTE: codex CLI not found; register MCP later with: codex mcp add evengine -- eve mcp"
      fi
      ;;
    claude)
      if command -v claude >/dev/null 2>&1; then
        claude mcp add evengine -- eve mcp || echo "WARN: run manually: claude mcp add evengine -- eve mcp"
      else
        echo "NOTE: claude CLI not found; register MCP later with: claude mcp add evengine -- eve mcp"
      fi
      ;;
    cursor)
      echo "NOTE: Cursor MCP: use the homepage 'Add to Cursor' button or write .cursor/mcp.json"
      ;;
  esac
else
  echo "NOTE: eve not on PATH; add <sdk>/bin to PATH, then register MCP manually."
fi

echo "Done. Restart your AI tool, then ask: 用 EVEngine 帮我做一个游戏"
