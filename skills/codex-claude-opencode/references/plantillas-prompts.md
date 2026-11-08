# Plantillas de prompts para delegar

Todo prompt de delegación debe ser **autocontenido** y acotado.

## Implementar (Codex)
```
Contexto: <proyecto, stack, convenciones relevantes en 2-3 líneas>.
Tarea: <qué construir, comportamiento esperado, firmas/rutas exactas>.
Archivos permitidos: <lista>. No modifiques ningún otro archivo.
Sigue el estilo del código existente en <archivo de ejemplo>.
Criterio de terminado: <tests que deben pasar / comando de build / comportamiento>.
Al final: resumen de 5 líneas máximo (qué cambió, comandos ejecutados, dudas).
No leas ni imprimas .env ni secretos.
```

## Revisar (Codex, read-only)
```
Revisa el cambio actual (git diff). Busca: bugs, regresiones, seguridad, casos borde, falta de tests.
Lista hallazgos por severidad con archivo:línea y una sugerencia concreta. No modifiques archivos.
Si no hay problemas reales, dilo; no inventes hallazgos.
```

## Tarea mecánica (OpenCode)
```
En <archivos exactos>: <cambio mecánico preciso, p. ej. renombrar X a Y / agregar JSDoc / traducir textos>.
No cambies lógica ni toques otros archivos. Al terminar lista los archivos modificados.
```

## Ajuste puntual tras revisión
```
En <archivo>: <problema concreto observado en el diff>. Corrígelo así: <instrucción exacta>.
No cambies nada más.
```
