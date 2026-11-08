# OpenCode CLI - referencia

OpenCode es un agente de código abierto con modelos gratuitos (proveedor `opencode`, sufijo `-free`).
Úsalo solo para tareas simples y repetitivas.

## Instalación
```bash
npm install -g opencode-ai
opencode --version
opencode models            # lista proveedor/modelo; los gratuitos terminan en -free
```

## Ejecución no interactiva: `opencode run`
| Opción | Uso |
|---|---|
| `-m, --model proveedor/modelo` | p. ej. `opencode/deepseek-v4.1-flash-free` |
| `--dir <DIR>` | Carpeta del proyecto |
| `-f, --file <ruta>` | Adjuntar archivo(s) al mensaje |
| `-c, --continue` / `-s <id>` | Continuar una sesión |
| `--format json` | Salida en JSON |

Ejemplo:
```bash
opencode run --dir "C:/ruta/proyecto" -m opencode/deepseek-v4.1-flash-free \
  "Agrega comentarios JSDoc a las funciones exportadas de src/utils/format.ts. No cambies lógica ni otros archivos."
```

## Notas
- La lista de modelos gratuitos cambia con el tiempo: consultar `opencode models` antes de elegir.
- Calidad menor que Codex/Claude: dar tareas acotadas y revisar siempre el `git diff`.
- No enviar código confidencial ni secretos a modelos gratuitos.
