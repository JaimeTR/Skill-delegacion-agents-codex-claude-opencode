#!/usr/bin/env bash
# Detecta que herramientas estan listas (Codex, OpenCode, Copilot, GitHub) y dice que falta conectar.
# Uso: ./doctor.sh            -> solo muestra el estado
#      ./doctor.sh --escribir -> ademas crea ~/.claude/codex-claude-opencode.json si no existe
CFG="$HOME/.claude/codex-claude-opencode.json"
codex=false; opencode=false; copilot=false; gh_ok=false
pasos=()

echo "Estado de la delegacion (lo que no esta disponible se omite solo):"

# Codex
if command -v codex >/dev/null 2>&1; then
  if codex login status 2>&1 | grep -qi "logged in"; then codex=true; echo "  [OK] Codex (sesion iniciada)"
  else echo "  [--] Codex instalado pero sin sesion"; pasos+=("codex login        (abre el navegador, cuenta de ChatGPT)"); fi
else echo "  [--] Codex no instalado -> se omite"; pasos+=("npm install -g @openai/codex   y luego: codex login   (opcional)"); fi

# OpenCode
if command -v opencode >/dev/null 2>&1 && opencode --version >/dev/null 2>&1; then opencode=true; echo "  [OK] OpenCode (modelos gratuitos, sin cuenta)"
else echo "  [--] OpenCode no instalado -> se omite"; pasos+=("npm install -g opencode-ai   (opcional)"); fi

# Copilot
if command -v copilot >/dev/null 2>&1 && copilot --version >/dev/null 2>&1; then copilot=true; echo "  [OK] Copilot CLI (si no has iniciado sesion: ejecuta copilot y usa /login)"
else echo "  [--] Copilot CLI no instalado -> se omite"; pasos+=("Copilot (opcional, requiere suscripcion de GitHub Copilot): npm install -g @github/copilot ; luego ejecutar copilot y escribir /login"); fi

# GitHub / git
if command -v git >/dev/null 2>&1; then
  n=$(git config --global user.name); e=$(git config --global user.email)
  if [ -n "$n" ] && [ -n "$e" ]; then echo "  [OK] git ($n)"; else echo "  [--] git sin nombre/correo"; pasos+=("git config --global user.name \"Tu Nombre\"  y  git config --global user.email \"tu@correo\""); fi
else echo "  [--] git no instalado"; pasos+=("Instalar git"); fi
if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then gh_ok=true; echo "  [OK] GitHub CLI (sesion iniciada)"
else echo "  [--] GitHub sin conectar (necesario para subir con gh/PR; git push usa tus credenciales de git)"; pasos+=("gh auth login      (conecta tu cuenta de GitHub)"); fi

if [ ${#pasos[@]} -gt 0 ]; then echo; echo "Para conectar lo que falta:"; for p in "${pasos[@]}"; do echo "  - $p"; done; fi

if [ "$1" = "--escribir" ] && [ ! -f "$CFG" ]; then
  r=""; for m in codex opencode copilot; do [ "${!m}" = true ] && r="$r\"$m\", "; done; r="[${r%, }]"
  mkdir -p "$HOME/.claude"
  printf '{ "enabled": true, "codex": %s, "opencode": %s, "copilot": %s, "relevo": %s }\n' "$codex" "$opencode" "$copilot" "$r" > "$CFG"
  echo; echo "Configuracion creada en $CFG"
fi
exit 0
