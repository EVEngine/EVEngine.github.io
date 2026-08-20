param(
    [Parameter(Position = 0)]
    [string]$Tool = "codex",

    # Internal: override the install root (defaults to $HOME). Used for testing.
    [string]$Prefix = ""
)

$ErrorActionPreference = "Stop"

$raw = "https://raw.githubusercontent.com/EVEngine/EVEngine.github.io/main/skills/evengine/SKILL.md"
if (-not $Prefix) { $Prefix = $HOME }

switch ($Tool) {
    "codex"  { $dir = Join-Path $Prefix ".agents\skills\evengine" }
    "cursor" { $dir = Join-Path $Prefix ".cursor\skills\evengine" }
    "claude" { $dir = Join-Path $Prefix ".claude\skills\evengine" }
    default { throw "unknown tool: $Tool (use: codex | cursor | claude)" }
}

New-Item -ItemType Directory -Force -Path $dir | Out-Null
curl.exe -fsSL $raw -o (Join-Path $dir "SKILL.md")
Write-Output "OK: EVEngine skill installed -> $(Join-Path $dir 'SKILL.md')"

if (Get-Command eve -ErrorAction SilentlyContinue) {
    if ($Tool -eq "codex" -and (Get-Command codex -ErrorAction SilentlyContinue)) {
        codex mcp add evengine -- eve mcp
    }
    elseif ($Tool -eq "claude" -and (Get-Command claude -ErrorAction SilentlyContinue)) {
        claude mcp add evengine -- eve mcp
    }
    else {
        Write-Output "NOTE: Cursor MCP: use the homepage 'Add to Cursor' button or write .cursor/mcp.json"
    }
}
else {
    Write-Output "NOTE: eve not on PATH; add <sdk>\bin to PATH, then register MCP manually."
}

Write-Output "Done. Restart your AI tool, then ask: 用 EVEngine 帮我做一个游戏"
