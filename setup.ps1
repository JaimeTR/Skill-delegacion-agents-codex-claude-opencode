# Codex + Claude + OpenCode: instala todo lo necesario (Windows).
# Uso: powershell -ExecutionPolicy Bypass -File setup.ps1
$ErrorActionPreference = "Stop"
if (-not (Get-Command node -ErrorAction SilentlyContinue)) { throw "Falta Node.js 18.18+ (https://nodejs.org). Instalalo y vuelve a correr." }
if (-not (Get-Command codex -ErrorAction SilentlyContinue))    { npm install -g "@openai/codex" }
if (-not (Get-Command opencode -ErrorAction SilentlyContinue)) { npm install -g opencode-ai }

$claude = Join-Path $env:USERPROFILE ".claude"
New-Item -ItemType Directory -Force (Join-Path $claude "skills") | Out-Null
Copy-Item "$PSScriptRoot\skills\*" (Join-Path $claude "skills") -Recurse -Force

$md = Join-Path $claude "CLAUDE.md"
$snippet = Get-Content "$PSScriptRoot\CLAUDE-snippet.md" -Raw
if (-not (Test-Path $md)) { Set-Content $md $snippet -Encoding UTF8 }
elseif (-not (Select-String -Path $md -Pattern "codex-claude-opencode" -Quiet)) { Add-Content $md $snippet -Encoding UTF8 }

Write-Host "Listo: skill y regla instaladas. Falta una vez: codex login (abre tu navegador)."
