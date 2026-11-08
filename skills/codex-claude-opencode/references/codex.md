# Codex CLI - referencia

Codex es el agente de código de OpenAI. Se usa con la cuenta ChatGPT del usuario (cuenta contra sus límites de Codex).

## Instalación y sesión
```bash
npm install -g @openai/codex      # requiere Node.js 18.18+
codex login                       # abre el navegador (lo hace el usuario)
codex login status                # "Logged in using ChatGPT"
```

## Ejecución no interactiva: `codex exec`
| Opción | Uso |
|---|---|
| `-C, --cd <DIR>` | Carpeta de trabajo (el proyecto) |
| `-s, --sandbox <modo>` | `read-only` (analizar/revisar), `workspace-write` (escribir en el proyecto) |
| `-m, --model <MODEL>` | Elegir modelo (opcional) |
| `-o, --output-last-message <FILE>` | Guardar solo la respuesta final (ahorra leer todo el log) |
| `--skip-git-repo-check` | Permitir carpetas que no son repo git |
| `--json` | Eventos en JSON |

Ejemplos:
```bash
# Implementar una pieza
codex exec -C "C:/ruta/proyecto" -s workspace-write "<prompt autocontenido>"

# Revisar cambios sin tocar nada, dejando solo el veredicto en un archivo
codex exec -C "C:/ruta/proyecto" -s read-only -o review.txt \
  "Revisa el git diff actual: bugs, seguridad, regresiones. Lista hallazgos por severidad. No modifiques archivos."
```

## Buenas prácticas
- Prompt autocontenido: Codex no ve la conversación con Claude.
- Pedir al final un resumen corto de qué cambió y qué comandos corrió.
- Pedirle que NO toque archivos fuera de la lista indicada.
- Leer su salida con `tail` o el archivo de `-o`, no el log completo.
- Verificar siempre con `git diff` y los tests del proyecto.
