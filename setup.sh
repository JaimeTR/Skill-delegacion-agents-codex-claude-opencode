#!/usr/bin/env bash
# Codex + Claude + OpenCode: instala todo lo necesario (macOS / Linux / Git Bash).
set -e
command -v node >/dev/null || { echo "Falta Node.js 18.18+ (https://nodejs.org)"; exit 1; }
command -v codex    >/dev/null || npm install -g @openai/codex
command -v opencode >/dev/null || npm install -g opencode-ai
D="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "$HOME/.claude/skills"
cp -R "$D/skills/." "$HOME/.claude/skills/"
MD="$HOME/.claude/CLAUDE.md"; touch "$MD"
grep -q "codex-claude-opencode" "$MD" || cat "$D/CLAUDE-snippet.md" >> "$MD"
echo "Listo: skill y regla instaladas. Falta una vez: codex login (abre tu navegador)."
