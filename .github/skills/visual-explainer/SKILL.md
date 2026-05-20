---
name: visual-explainer
description: >
  Genera explicaciones visuales — infografías, whiteboards, diagramas, mind maps y slides —
  desde cualquier contenido. Usar cuando el usuario pida visualizar, crear una infografía,
  dibujar un diagrama o hacer un sketch. Requiere OPENAI_API_KEY o GEMINI_API_KEY.
  Compatible con GitHub Copilot (VS Code) y Claude Code.
compatibility: "PowerShell 5.1+. Requiere OPENAI_API_KEY o GEMINI_API_KEY."
metadata:
  author: keber
  version: "1.0.0"
  standard: agentskills.io
---

Genera una explicación visual (whiteboard, infographic, presentation, diagram, mindmap o mindmap-structured) desde cualquier contenido usando el script PowerShell del skill.

## Usage

- `/visual-explainer Explain how DNS resolution works` — whiteboard style (default)
- `/visual-explainer --style infographic How machine learning models are trained`
- `/visual-explainer --style presentation The software development lifecycle`
- `/visual-explainer --style diagram --complexity detailed Kubernetes pod networking`
- `/visual-explainer --style mindmap The principles of object-oriented programming` — colorful radial mindmap
- `/visual-explainer --style mindmap-structured Project management methodologies` — clean, data-oriented XMind-style
- `/visual-explainer --draw-level sketch How the internet works` — rougher hand-drawn feel
- `/visual-explainer --draw-level polished --style whiteboard React component lifecycle`
- `/visual-explainer --backend gemini How the water cycle works` — usar Gemini en lugar de OpenAI

## Arguments

El string de argumentos está disponible como `$ARGUMENTS`. Parsear según estas reglas:

### Flags (todos opcionales)

| Flag | Default | Descripción |
|------|---------|-------------|
| `--style S` | `whiteboard` | Estilo visual: `whiteboard`, `infographic`, `presentation`, `diagram`, `mindmap`, `mindmap-structured` |
| `--draw-level L` | `normal` | Nivel de acabado: `sketch` (rough/playful), `normal` (equilibrado), `polished` (clean/profesional) |
| `--complexity C` | `moderate` | Densidad de contenido: `simple` (3-4 conceptos), `moderate` (5-7), `detailed` (8-12) |
| `--size WxH` | style-dependent | Dimensiones de la imagen. Defaults: whiteboard=`1536x1024`, infographic=`1024x1536`, presentation=`1536x1024`, diagram=`1024x1024`, mindmap=`1536x1024`, mindmap-structured=`1536x1024` |
| `--output DIR` | `./` | Directorio de salida |
| `--prefix NAME` | `visual` | Prefijo del nombre de archivo |
| `--backend B` | auto-detectado | Backend: `openai` (gpt-image-1.5) o `gemini` (gemini-2.0-flash-preview-image-generation). Auto-detecta según API keys disponibles. |

### El resto es el contenido

Después de extraer los flags, el texto restante es el contenido a visualizar.

---

## Steps

### Step 1: Validar prerrequisitos y detectar backend

- Si no hay contenido, pedir al usuario qué quiere visualizar y detenerse.

**Detección de backend** (en orden de prioridad):

1. Si `--backend openai` está especificado: usar OpenAI. Requiere `OPENAI_API_KEY`.
2. Si `--backend gemini` está especificado: usar Gemini. Requiere `GEMINI_API_KEY`.
3. Si `--backend` NO está especificado, auto-detectar:
   - Si solo `OPENAI_API_KEY` está configurado → usar OpenAI
   - Si solo `GEMINI_API_KEY` está configurado → usar Gemini
   - Si AMBAS están configuradas → usar OpenAI (default)
   - Si NINGUNA está configurada → detener con instrucciones:
     ```
     No image generation API key found. Set one of:
       $env:OPENAI_API_KEY = "sk-..."    # desde platform.openai.com/api-keys
       $env:GEMINI_API_KEY = "AIza..."   # desde aistudio.google.com/apikey
     ```

**Reportar el backend seleccionado** inmediatamente (el script también lo hará, pero es útil para el usuario):
```
Backend: OpenAI gpt-image-1.5 (auto-detectado — OPENAI_API_KEY está configurado)
```

---

### Step 2: Analizar el contenido

Antes de generar cualquier imagen, analizar en profundidad el contenido de entrada para extraer estructura. Este es el paso más crítico — la calidad del visual depende completamente de este análisis.

Realizar el siguiente análisis y escribirlo explícitamente:

1. **Core Concept**: ¿Cuál es la idea principal única?
2. **Key Sub-Topics**: Listar 3-12 sub-temas según el parámetro de complejidad
3. **Relationships**: ¿Cómo se conectan los sub-temas? (jerarquía, secuencia, causa-efecto, comparación, parte-todo)
4. **Visual Metaphors**: ¿Qué objetos o metáforas del mundo real pueden representar cada concepto? (ej. "security" → shield, "data flow" → pipeline/river, "scaling" → mountains/ladder)
5. **Layout Strategy**: ¿Cómo deben organizarse espacialmente las secciones? (radial desde el centro, flujo izquierda-derecha, jerarquía arriba-abajo, grid, timeline)
6. **Color Coding**: Asignar un tema de color a cada sección principal para agrupación visual

---

### Step 3: Construir el prompt de generación de imágenes

Construir un prompt extremadamente detallado siguiendo el template específico del estilo en `references/styles.md`. El prompt DEBE ser exhaustivo — típicamente 400-800 palabras. Los prompts vagos producen resultados genéricos. Cada elemento visual debe ser descrito explícitamente.

**Para el template del estilo elegido, leer `references/styles.md`** (sección correspondiente al estilo).

**REGLAS CRÍTICAS DE PROMPT ENGINEERING:**
- Describir el LAYOUT EXACTO con posiciones espaciales (top-left, center, bottom-right, etc.)
- Especificar CADA icono, ilustración y elemento decorativo
- Incluir el texto/etiquetas exactos que deben aparecer en la imagen
- Describir colores usando nombres específicos (no solo "colorful")
- Especificar el estilo tipográfico (bold headers, handwritten labels, etc.)
- Describir las conexiones entre elementos (arrows, dotted lines, flowing curves)
- Incluir detalles de fondo y texturas
- Especificar la composición general y el flujo visual (por dónde debe viajar la vista)

**Prompt Quality Checklist** — antes de continuar, verificar que el prompt incluye TODOS estos elementos:

- [ ] Descripción del canvas/fondo
- [ ] Texto del título y su estilo
- [ ] Descripción del layout espacial (dónde se posiciona cada cosa)
- [ ] 3-12 descripciones de secciones con títulos, iconos y texto
- [ ] Descripciones específicas de iconos/ilustraciones (no genéricas)
- [ ] Descripciones de conexiones/flechas entre elementos relacionados
- [ ] Paleta de colores con nombres específicos
- [ ] Descripción del estilo tipográfico/tipografía
- [ ] Elementos decorativos apropiados al estilo
- [ ] Descripción del mood/feel general
- [ ] Al menos 300 palabras de detalle en el prompt

Si falta algún elemento, añadirlo antes de continuar.

---

### Step 4: Generar la imagen

**Escribir el prompt a un archivo temporal:**

```powershell
$timestamp  = [DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds()
$promptFile = [System.IO.Path]::Combine($env:TEMP, "ve-prompt-${timestamp}.txt")
[System.IO.File]::WriteAllText($promptFile, $thePrompt, [System.Text.Encoding]::UTF8)
```

**Ejecutar el script:**

```powershell
& '.github/skills/visual-explainer/scripts/visual-explainer.ps1' `
    -PromptFile $promptFile `
    -Style      <style> `
    -Size       <size> `
    -Output     <output_dir> `
    -Prefix     <prefix> `
    -Backend    <backend> `
    -FrameIndex 1
```

Reportar antes de ejecutar:
```
Generando con: <Backend> (<size>, high quality)
```

El script:
- Lee el prompt desde el archivo temporal y lo elimina al finalizar
- Resuelve el backend y valida la API key correspondiente
- Llama a la API con retry automático en caso de rate limit (429)
- Guarda el PNG en `<output>/<prefix>-1.png`
- Imprime la ruta del archivo generado

---

### Step 5: Generar resumen estructurado

Después de generar la imagen, producir un resumen en texto estructurado:

```
## Visual Explainer: [Title]

**Style:** [style] | **Backend:** [OpenAI gpt-image-1.5 o Gemini gemini-2.0-flash-preview-image-generation] | **Draw Level:** [draw-level] | **Complexity:** [complexity]

### Sections
1. **[Section Title]** — [brief description]
2. **[Section Title]** — [brief description]
...

### Key Relationships
- [Concept A] → [Concept B]: [relationship]
...

### Image
Generated: [filepath]
```

---

### Step 6: Summary

Reportar al usuario:
- La ruta de la imagen generada
- El estilo y configuración usados
- Una breve descripción de lo que se muestra
- Sugerencias de refinamiento (ej. "Prueba `--draw-level sketch` para un feel más casual" o "Prueba `--style infographic` para un layout más estructurado")

---

## Error Handling

- Si no hay API key disponible (ni `OPENAI_API_KEY` ni `GEMINI_API_KEY`), detener con instrucciones de configuración para ambas
- Si `--backend` está especificado pero la API key correspondiente falta, detener con instrucciones para esa clave específica
- Si no hay contenido, pedir al usuario qué quiere visualizar
- Si la API devuelve un error, reportarlo y sugerir simplificar el contenido o cambiar de backend

## Notes

- El prompt engineering es el valor principal de este skill — dedicar tiempo al análisis y la construcción del prompt
- Los mismos prompts funcionan en ambos backends; los style templates son agnósticos al backend
- Usar siempre `quality: "high"` en OpenAI — estas imágenes son premium
- Para contenido con mucho texto, preferir estilo `infographic`
- Para contenido de proceso/flujo, preferir estilo `diagram`
- Para explicaciones engaging/fun, preferir estilo `whiteboard`
- Para contenido jerárquico/categórico, preferir `mindmap` (colorido) o `mindmap-structured` (orientado a datos)
- El parámetro `--draw-level` afecta significativamente los estilos `whiteboard` y `presentation`
- Costo estimado (OpenAI): ~$0.19 por imagen en high quality, 1024x1024. Tamaños mayores ~$0.29
- Costo estimado (Gemini): Free tier disponible; verificar precios actuales en aistudio.google.com
