# Relevo: terminar y subir a GitHub cuando se acaba el crédito de Claude

Objetivo: que el trabajo **nunca quede a medio camino**. Si Claude se queda sin crédito, otro modelo
(Codex u OpenCode) puede terminar lo pendiente, commitear y subir a GitHub.

## Limitación importante
Cuando el límite de Claude ya se agotó, Claude **no puede lanzar nada**. Por eso el relevo se prepara
**antes**, cuando el límite se acerca, o lo inicia el usuario a mano con el prompt de la sección 3.

## 1. Cuando el límite de Claude se acerca (Claude lo hace)

1. Dejar el código en un punto estable (compila; los tests que pasaban siguen pasando).
2. Escribir `HANDOFF.md` en la raíz del proyecto con la plantilla de la sección 2.
3. Commit `WIP:` en la rama de trabajo (sin secretos; revisar `git status`).
4. Elegir quién relevará y lanzarlo en segundo plano:
   ```bash
   # Preferido: Codex termina, prueba, commitea y sube
   codex exec -C "<proyecto>" -s workspace-write "Lee HANDOFF.md y cumple exactamente lo que pide."
   # Alternativa para pasos mecánicos (commit, push, merge sin conflictos)
   opencode run --dir "<proyecto>" -m opencode/<modelo>-free "Lee HANDOFF.md y cumple exactamente lo que pide."
   ```
5. Avisar al usuario: qué se delegó, en qué rama quedó y cómo verificar.

## 2. Plantilla de `HANDOFF.md`

```markdown
# HANDOFF - <proyecto>
Fecha: <fecha>   Rama de trabajo: <rama>   Último commit: <hash>

## Qué se está haciendo
<objetivo en 2-3 líneas>

## Estado
- Hecho: <lista>
- Falta: <lista numerada, en orden, con archivos concretos>
- Criterio de terminado: <tests/build que deben pasar>

## Reglas (obligatorias)
- Solo tocar estos archivos: <lista>.
- NO leer ni imprimir .env ni secretos. Revisar `git status` antes de commitear: nunca subir secretos.
- NO usar force push, NO reescribir historia, NO borrar ramas.
- Si algo falla o hay conflictos, detenerse y dejarlo escrito al final de este archivo; no inventar soluciones.

## Al terminar
1. Correr: <comando de tests/build>. Si fallan, corregir solo lo relacionado; si no se puede, dejar `WIP:` y explicar aquí.
2. Commit con mensaje claro (qué quedó y qué falta) en la rama <rama>.
3. Subir: `git push origin <rama>`.
4. Flujo del usuario (si aplica): merge de la rama a `develop`, luego `develop` a `main`, y push de ambas.
   Si la rama está protegida o hay conflictos: abrir PR y avisar, sin forzar.
5. Añadir al final de este archivo un resumen: qué se hizo, qué falta, rama y commit.
```

## 3. Si Claude ya no tiene crédito (lo hace el usuario)

En la carpeta del proyecto, ejecutar uno de estos y pegar el prompt:
```bash
codex           # o:  opencode
```
Prompt:
```
Lee HANDOFF.md y cumple exactamente lo que pide: terminar lo pendiente, correr tests, commitear y subir a GitHub.
No uses force push, no toques secretos y no hagas nada fuera de lo escrito.
```
Si el proyecto tiene `AGENTS.md`, Codex y OpenCode lo leen solos; conviene que diga: "Si existe HANDOFF.md, léelo primero".

## 4. Quién es mejor para qué
| Paso | Modelo recomendado |
|---|---|
| Terminar código pendiente | Codex |
| Correr tests y arreglar fallos simples | Codex |
| Commit, push, merge sin conflictos | OpenCode (suficiente) o Codex |
| Resolver conflictos de merge, ramas protegidas, decisiones | Detener y esperar a Claude / al usuario |

## 4b. Cualquiera puede subir: orden de relevo y reparto

Codex, OpenCode (y Copilot, si está instalado y activo) pueden hacer commit y push. Se reparte así:
- **Orden de relevo** (configurable en el JSON del interruptor): `"relevo": ["codex", "opencode", "copilot"]`.
  El primero disponible (instalado, con sesión y activado) toma el relevo; si se queda sin límite o falla,
  sigue el siguiente leyendo el mismo `HANDOFF.md` actualizado.
- **Reparto en paralelo** (solo con archivos distintos): cada uno trabaja en su propia rama
  (`feat/<tarea>-codex`, `feat/<tarea>-opencode`) y se integran después con un merge revisado.
  Nunca dos modelos en la misma rama ni en los mismos archivos al mismo tiempo.
- **Integrar y subir a `develop`/`main`** lo hace uno solo, el último del orden, tras correr los tests.
- Cada modelo, al terminar su turno, actualiza el final de `HANDOFF.md` (qué hizo, rama, commit) para el siguiente.

## 5. Cuidados
- Los modelos gratuitos son menos fiables: dar pasos mecánicos y exactos, nunca decisiones.
- Un solo agente trabajando a la vez en el proyecto.
- Al volver Claude: leer `HANDOFF.md` y `git log` / `git diff`, revisar lo que hicieron y continuar.
- Borrar o archivar `HANDOFF.md` cuando el trabajo esté cerrado.
