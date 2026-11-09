# GitHub Copilot CLI - referencia

Copilot CLI es el agente de código de GitHub. Es **opcional**: requiere una suscripción de GitHub Copilot
(existe un plan gratuito con límite). Si no está instalado o no hay sesión, la skill lo omite sola.

## Instalación y sesión
```bash
npm install -g @github/copilot    # requiere Node.js
copilot --version                 # debe responder
copilot                           # abrir una vez y escribir /login (abre el navegador; lo hace el usuario)
```

## Ejecución no interactiva
| Opción | Uso |
|---|---|
| `-p, --prompt <texto>` | Tarea a ejecutar sin interfaz |
| `-s, --silent` | Solo la respuesta (sin estadísticas): ahorra leer salida |
| `--model <modelo>` | Elegir modelo (opcional) |
| `--add-dir <carpeta>` | Dar acceso a una carpeta de trabajo |
| `--allow-tool '<herramienta>'` | Permitir una herramienta concreta sin preguntar |
| `--deny-tool '<herramienta>'` | Prohibir una herramienta |
| `--no-ask-user` | No hacer preguntas (modo desatendido) |

En modo no interactivo, lo que no esté permitido por `--allow-tool` se **deniega** (no puede preguntar).

Ejemplos (desde la carpeta del proyecto):
```bash
# Revisar sin modificar (segunda opinión)
copilot -p "Revisa el git diff actual: bugs, seguridad, regresiones. No modifiques archivos." -s --no-ask-user

# Escribir código: permitir solo escritura de archivos
copilot -p "<prompt autocontenido>" -s --no-ask-user --allow-tool 'write'

# Pasos de git acotados (commit y push, sin force)
copilot -p "Haz commit de los cambios y push a la rama actual" -s --no-ask-user \
  --allow-tool 'shell(git add:*)' --allow-tool 'shell(git commit:*)' --allow-tool 'shell(git push)' \
  --deny-tool 'shell(git push --force:*)'
```

## Buenas prácticas
- **No usar `--allow-all` / `--yolo` / `--allow-all-tools`**: dan permisos totales. Permitir solo lo necesario.
- Prompt autocontenido, igual que con Codex (Copilot no ve la conversación con Claude).
- Verificar siempre con `git diff` y los tests del proyecto.
- Buen uso: revisión y segunda opinión, código en paralelo (cupo distinto al de Codex), y pasos de git.
