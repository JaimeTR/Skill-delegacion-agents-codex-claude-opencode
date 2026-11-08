# Codex + Claude + OpenCode

Skill (instrucciones reutilizables) para que un agente de código **reparta el trabajo entre varios modelos**
y así ahorre tokens sin perder calidad.

## ¿Qué es?

Un paquete de instrucciones, scripts y plantillas que le enseña a tu agente a trabajar como un equipo:

| Rol | Modelo | Qué hace |
|---|---|---|
| **Coordinador** | Claude | Entiende el pedido, propone el enfoque, divide, asigna, revisa y entrega |
| **Programador** | Codex (tu cuenta de ChatGPT) | Codifica piezas ya definidas, escribe tests, da segunda opinión |
| **Ayudante** | OpenCode (modelos gratuitos) | Hace lo simple y repetitivo: boilerplate, documentación, traducciones, renombres |

## ¿Para qué sirve?

- **Ahorrar tokens y límite de uso** de Claude: el trabajo pesado de escribir código lo hace Codex, y las tareas simples las hace OpenCode gratis.
- **Mantener la calidad**: Claude decide la arquitectura y revisa todo con `git diff` y tests antes de dar algo por terminado.
- **No tener que explicarlo cada vez**: el agente aplica la skill solo, sin que se lo pidas, en cualquier proyecto.
- **Tener una segunda opinión** de otro modelo sobre tu código.
- **Trabajar con seguridad**: nunca se envían secretos a otros modelos, Codex corre en sandbox y hay un solo escritor por archivo.

Si Codex u OpenCode no están disponibles o se acaba su límite, el agente sigue solo y te avisa.

## ¿Dónde se instala?

Funciona en **Claude Code** (donde se usa como *skill* nativa) y en **otros agentes de código** como Codex u OpenCode,
porque las instrucciones son texto y los modelos se invocan por línea de comandos.

| Agente | Cómo se carga |
|---|---|
| **Claude Code** (CLI, app de escritorio, extensiones de IDE) | Con `setup.ps1` / `setup.sh`: copia la skill a `~/.claude/skills/` y activa la regla en `~/.claude/CLAUDE.md` |
| **Codex, OpenCode y otros agentes** que leen `AGENTS.md` | Copiar el contenido de `skills/codex-claude-opencode/SKILL.md` (sin el bloque inicial entre `---`) al `AGENTS.md` del proyecto o al global del agente |
| **Cualquier otro agente** con archivo de instrucciones (por ejemplo `GEMINI.md`) | Pegar ese mismo contenido en su archivo de instrucciones |

Ejemplo para otro agente (Git Bash / macOS / Linux), desde la carpeta del repositorio clonado:
```bash
awk 'BEGIN{c=0} /^---$/{c++; next} c>=2' skills/codex-claude-opencode/SKILL.md >> /ruta/del/proyecto/AGENTS.md
```
(Revisa el resultado: el agente que lo use debe tener acceso a `codex` y `opencode` en su terminal.)

## Requisitos

- Un agente de código, idealmente [Claude Code](https://claude.com/claude-code).
- Node.js 18.18 o superior.
- Cuenta de ChatGPT (sirve la gratuita) para Codex. OpenCode no necesita cuenta para sus modelos `-free`.

## Instalación (Claude Code)

```bash
git clone https://github.com/JaimeTR/Skill-delegacion-agents-codex-claude-opencode.git
cd Skill-delegacion-agents-codex-claude-opencode
```

Windows (PowerShell):
```powershell
powershell -ExecutionPolicy Bypass -File setup.ps1
```

macOS / Linux / Git Bash:
```bash
./setup.sh
```

El script instala Codex y OpenCode si faltan, copia la skill y agrega la regla a `CLAUDE.md` (sin duplicarla).

Después, **una sola vez**:
```bash
codex login      # abre el navegador; inicia con tu cuenta de ChatGPT
```

## Activar y desactivar

Por defecto está **activada**. Se controla hablándole al agente, que guarda el estado en un archivo JSON:

| Dices | Efecto |
|---|---|
| "desactiva la delegación" | No delega en ningún proyecto (global) |
| "activa la delegación" | Vuelve a delegar |
| "en este proyecto no delegues" | Solo ese proyecto queda desactivado |
| "sin Codex" / "sin OpenCode" | Apaga solo ese modelo |
| "estado de la delegación" | Te dice qué está activo y dónde |
| "solo por esta vez, hazlo tú" | Una tarea sin delegar, sin cambiar la configuración |

Archivos (el del proyecto tiene prioridad sobre el global):
- Global: `~/.claude/codex-claude-opencode.json`
- Proyecto: `<proyecto>/.claude/codex-claude-opencode.json`

```json
{ "enabled": true, "codex": true, "opencode": true }
```

También puedes editarlos a mano. Sin archivo, todo queda activado.

## Cómo trabaja

1. Plan breve: qué piezas hay y quién hace cada una.
2. Delegación con prompts autocontenidos.
3. Revisión liviana (`git diff` y tests), sin releer archivos completos.
4. Ajuste puntual o cierre.

Si algo sale flojo se escala: OpenCode, luego Codex, luego Claude.
Las tareas chicas las hace el coordinador directo, porque delegarlas cuesta más que hacerlas.

## Estructura

```
skills/codex-claude-opencode/
  SKILL.md                         # instrucciones principales (cuándo, cómo, reglas)
  references/codex.md              # referencia del CLI de Codex
  references/opencode.md           # referencia del CLI de OpenCode
  references/plantillas-prompts.md # plantillas de prompts de delegación
CLAUDE-snippet.md                  # regla que activa la skill en todos los proyectos
setup.ps1 / setup.sh               # instalación
```

## Seguridad

Nunca se envían secretos a otros modelos; Codex solo con sandbox `read-only` o `workspace-write`;
un solo escritor por archivo; los modelos gratuitos no reciben código confidencial. Detalle en `SKILL.md`.

## Notas

- Los modelos gratuitos de OpenCode cambian con el tiempo: usar `opencode models`.
- El uso de Codex cuenta contra los límites de tu plan de ChatGPT.
