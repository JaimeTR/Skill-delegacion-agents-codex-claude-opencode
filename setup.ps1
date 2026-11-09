# Codex + Claude + OpenCode: instalacion guiada (Windows).
# Uso: powershell -ExecutionPolicy Bypass -File setup.ps1          (pregunta antes de instalar cada herramienta)
#      powershell -ExecutionPolicy Bypass -File setup.ps1 -Yes     (instala Codex y OpenCode sin preguntar)
# Copilot es opcional y nunca se instala solo.
param([switch]$Yes)
$ErrorActionPreference = "Stop"
function Has($c) { [bool](Get-Command $c -ErrorAction SilentlyContinue) }
function Ask($q) { if ($Yes) { return $true }; return ((Read-Host "$q (s/n)") -match "^[sSyY]") }

if (-not (Has node)) { throw "Falta Node.js 18.18+ (https://nodejs.org). Instalalo y vuelve a correr." }
if (-not (Has codex) -and (Ask "Instalar Codex (requiere cuenta de ChatGPT, sirve la gratuita)?")) { npm install -g "@openai/codex" }
if (-not (Has opencode) -and (Ask "Instalar OpenCode (modelos gratuitos)?")) { npm install -g opencode-ai }

$claude = Join-Path $env:USERPROFILE ".claude"
New-Item -ItemType Directory -Force (Join-Path $claude "skills") | Out-Null
Copy-Item "$PSScriptRoot\skills\*" (Join-Path $claude "skills") -Recurse -Force
Copy-Item "$PSScriptRoot\doctor.ps1", "$PSScriptRoot\doctor.sh" (Join-Path $claude "skills\codex-claude-opencode") -Force

$md = Join-Path $claude "CLAUDE.md"
$snippet = Get-Content "$PSScriptRoot\CLAUDE-snippet.md" -Raw
if (-not (Test-Path $md)) { Set-Content $md $snippet -Encoding UTF8 }
elseif (-not (Select-String -Path $md -Pattern "codex-claude-opencode" -Quiet)) { Add-Content $md $snippet -Encoding UTF8 }

Write-Host ""
& "$PSScriptRoot\doctor.ps1" -Escribir
Write-Host ""
Write-Host "Listo: skill y regla instaladas. Conecta lo que aparezca arriba (los pasos abren tu navegador); lo que no uses se omite solo."
