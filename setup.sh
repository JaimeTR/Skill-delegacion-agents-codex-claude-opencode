#!/usr/bin/env bash
# Codex + Claude + OpenCode: instalacion guiada (macOS / Linux / Git Bash).
# Uso: ./setup.sh        (pregunta antes de instalar cada herramienta)
#      ./setup.sh --yes  (instala Codex y OpenCode sin preguntar)
# Copilot es opcional y nunca se instala solo.
set -e
YES=false; [ "$1" = "--yes" ] && YES=true
ask() { $YES && return 0; read -r -p "$1 (s/n) " r; case "$r" in [sSyY]*) return 0;; *) return 1;; esac; }

command -v node >/dev/null || { echo "Falta Node.js 18.18+ (https://nodejs.org)"; exit 1; }
if ! command -v codex >/dev/null && ask "Instalar Codex (requiere cuenta de ChatGPT, sirve la gratuita)?"; then npm install -g @openai/codex; fi
if ! command -v opencode >/dev/null && ask "Instalar OpenCode (modelos gratuitos)?"; then npm install -g opencode-ai; fi

D="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "$HOME/.claude/skills"
cp -R "$D/skills/." "$HOME/.claude/skills/"
cp "$D/doctor.sh" "$D/doctor.ps1" "$HOME/.claude/skills/codex-claude-opencode/"
MD="$HOME/.claude/CLAUDE.md"; touch "$MD"
grep -q "codex-claude-opencode" "$MD" || cat "$D/CLAUDE-snippet.md" >> "$MD"

echo
bash "$D/doctor.sh" --escribir
echo
echo "Listo: skill y regla instaladas. Conecta lo que aparezca arriba (los pasos abren tu navegador); lo que no uses se omite solo."
