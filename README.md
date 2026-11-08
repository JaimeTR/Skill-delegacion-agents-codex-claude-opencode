# Codex + Claude + OpenCode

Skill de Claude Code para **delegar tareas entre modelos y ahorrar tokens**:

- **Claude** coordina: entiende, propone, divide, asigna, revisa y entrega.
- **Codex** (cuenta ChatGPT) codifica piezas ya definidas, tests y segunda opinión.
- **OpenCode** (modelos gratuitos) hace lo simple y repetitivo.

Claude aplica la skill solo, sin que se lo pidas, y revisa todo con `git diff` y tests antes de dar algo por terminado.

## Instalación

Requisitos: [Claude Code](https://claude.com/claude-code) y Node.js 18.18 o superior.

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

El script instala Codex y OpenCode si faltan, copia la skill a `~/.claude/skills/` y agrega una regla
a `~/.claude/CLAUDE.md` (sin duplicarla).

Después, **una sola vez**:
```bash
codex login      # abre el navegador; inicia con tu cuenta de ChatGPT
```

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

## Cómo trabaja
1. Plan breve.
2. Delegar con prompts autocontenidos.
3. Revisión liviana (`git diff` y tests).
4. Ajuste puntual o cierre.

Si algo sale flojo se escala: OpenCode, luego Codex, luego Claude.

## Seguridad
Nunca se envían secretos a otros modelos; Codex solo con sandbox `read-only` o `workspace-write`;
un solo escritor por archivo; los modelos gratuitos no reciben código confidencial. Detalle en `SKILL.md`.

## Notas
- Los modelos gratuitos de OpenCode cambian con el tiempo: usar `opencode models`.
- Si Codex u OpenCode no están disponibles, Claude trabaja solo y lo avisa.
