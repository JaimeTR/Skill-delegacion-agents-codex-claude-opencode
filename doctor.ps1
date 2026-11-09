# Detecta que herramientas estan listas (Codex, OpenCode, Copilot, GitHub) y dice que falta conectar.
# Uso: powershell -ExecutionPolicy Bypass -File doctor.ps1            -> solo muestra el estado
#      powershell -ExecutionPolicy Bypass -File doctor.ps1 -Escribir  -> crea ~/.claude/codex-claude-opencode.json si no existe
param([switch]$Escribir)
$cfg = Join-Path $env:USERPROFILE ".claude\codex-claude-opencode.json"
$st = @{ codex = $false; opencode = $false; copilot = $false }
$pasos = @()
function Has($c) { [bool](Get-Command $c -ErrorAction SilentlyContinue) }
function Runs($c, $a) { try { & $c $a *> $null; return ($LASTEXITCODE -eq 0) } catch { return $false } }

Write-Host "Estado de la delegacion (lo que no esta disponible se omite solo):"

if (Has codex) {
  $o = (& codex login status 2>&1 | Out-String)
  if ($o -match "(?i)logged in") { $st.codex = $true; Write-Host "  [OK] Codex (sesion iniciada)" }
  else { Write-Host "  [--] Codex instalado pero sin sesion"; $pasos += "codex login        (abre el navegador, cuenta de ChatGPT)" }
} else { Write-Host "  [--] Codex no instalado -> se omite"; $pasos += "npm install -g @openai/codex   y luego: codex login   (opcional)" }

if ((Has opencode) -and (Runs opencode "--version")) { $st.opencode = $true; Write-Host "  [OK] OpenCode (modelos gratuitos, sin cuenta)" }
else { Write-Host "  [--] OpenCode no instalado -> se omite"; $pasos += "npm install -g opencode-ai   (opcional)" }

if ((Has copilot) -and (Runs copilot "--version")) { $st.copilot = $true; Write-Host "  [OK] Copilot CLI (si no has iniciado sesion: ejecuta copilot y usa /login)" }
else { Write-Host "  [--] Copilot CLI no instalado -> se omite"; $pasos += "Copilot es opcional: requiere suscripcion de GitHub Copilot (plan gratuito disponible)" }

if (Has git) {
  $n = git config --global user.name; $e = git config --global user.email
  if ($n -and $e) { Write-Host "  [OK] git ($n)" }
  else { Write-Host "  [--] git sin nombre/correo"; $pasos += 'git config --global user.name "Tu Nombre"  y  git config --global user.email "tu@correo"' }
} else { Write-Host "  [--] git no instalado"; $pasos += "Instalar git" }
if ((Has gh) -and (Runs gh @("auth", "status"))) { Write-Host "  [OK] GitHub CLI (sesion iniciada)" }
else { Write-Host "  [--] GitHub sin conectar (necesario para PR con gh; git push usa tus credenciales de git)"; $pasos += "gh auth login      (conecta tu cuenta de GitHub)" }

if ($pasos.Count -gt 0) { Write-Host ""; Write-Host "Para conectar lo que falta:"; $pasos | ForEach-Object { Write-Host "  - $_" } }

if ($Escribir -and -not (Test-Path $cfg)) {
  $relevo = @("codex", "opencode", "copilot") | Where-Object { $st[$_] }
  $obj = [ordered]@{ enabled = $true; codex = $st.codex; opencode = $st.opencode; copilot = $st.copilot; relevo = @($relevo) }
  New-Item -ItemType Directory -Force (Split-Path $cfg) | Out-Null
  $obj | ConvertTo-Json -Compress | Set-Content $cfg -Encoding UTF8
  Write-Host ""; Write-Host "Configuracion creada en $cfg"
}
exit 0
