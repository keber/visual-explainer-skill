#Requires -Version 5.1
<#
.SYNOPSIS
  Genera una imagen desde un prompt usando OpenAI gpt-image-1.5 o Gemini image generation.

.DESCRIPTION
  Llama a la API de imagen correspondiente y guarda el resultado como PNG.
  El prompt se lee desde un archivo temporal para evitar el límite de longitud
  de argumentos en Windows y para no exponer el contenido en la lista de procesos.

.PARAMETER PromptFile
  Ruta al archivo temporal con el prompt completo (UTF-8).
  El archivo se elimina automáticamente al finalizar, incluso si hay errores.

.PARAMETER Style
  Estilo visual de la imagen generada.
  Valores válidos: whiteboard, infographic, presentation, diagram, mindmap, mindmap-structured.
  Por defecto: infographic.

.PARAMETER Size
  Dimensiones de la imagen, ej. "1024x1536".
  Si se omite, se usa el tamaño por defecto del estilo:
    whiteboard / presentation / mindmap / mindmap-structured -> 1536x1024
    infographic                                              -> 1024x1536
    diagram                                                  -> 1024x1024

.PARAMETER Output
  Directorio donde se guardará el PNG. Se crea si no existe.
  Por defecto: directorio actual (.).

.PARAMETER Prefix
  Prefijo del nombre de archivo. El archivo resultante será "<Prefix>-<FrameIndex>.png".
  Por defecto: visual.

.PARAMETER Backend
  Backend de generación de imágenes: auto, openai, gemini.
  Con "auto" usa OpenAI si OPENAI_API_KEY está configurado, sino Gemini.
  Por defecto: auto.

.PARAMETER FrameIndex
  Índice del frame para el nombre de archivo. Por defecto: 1.

.EXAMPLE
  & '.github/skills/visual-explainer/scripts/visual-explainer.ps1' `
      -PromptFile "$env:TEMP\ve-prompt.txt" `
      -Style      infographic `
      -Output     "./" `
      -Prefix     "visual"

.EXAMPLE
  & '.github/skills/visual-explainer/scripts/visual-explainer.ps1' `
      -PromptFile "$env:TEMP\ve-prompt.txt" `
      -Style      whiteboard `
      -Backend    gemini `
      -Output     "C:\output" `
      -Prefix     "sketch" `
      -FrameIndex 2
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$PromptFile,

    [ValidateSet('whiteboard', 'infographic', 'presentation', 'diagram', 'mindmap', 'mindmap-structured')]
    [string]$Style = 'infographic',

    [string]$Size = '',

    [string]$Output = '.',

    [string]$Prefix = 'visual',

    [ValidateSet('auto', 'openai', 'gemini')]
    [string]$Backend = 'auto',

    [int]$FrameIndex = 1
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

#region -- TLS 1.2 (obligatorio en PS 5.1 para OpenAI y Gemini) --
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
#endregion

#region -- Leer prompt desde archivo temporal --
if (-not (Test-Path $PromptFile)) {
    throw "Prompt file not found: $PromptFile"
}

$prompt = $null
try {
    $prompt = Get-Content -Path $PromptFile -Raw -Encoding UTF8
}
finally {
    if (Test-Path $PromptFile) {
        Remove-Item -Path $PromptFile -Force
    }
}

if (-not $prompt -or $prompt.Trim().Length -eq 0) {
    throw "El archivo de prompt está vacío: $PromptFile"
}
#endregion

#region -- Resolver backend --
$resolvedBackend = $null

switch ($Backend) {
    'openai' {
        if (-not $env:OPENAI_API_KEY) {
            throw "OPENAI_API_KEY no está configurado.`nObtén tu clave en: https://platform.openai.com/api-keys"
        }
        $resolvedBackend = 'openai'
        Write-Host "Backend: OpenAI gpt-image-1.5 (--backend openai)" -ForegroundColor Cyan
    }
    'gemini' {
        if (-not $env:GEMINI_API_KEY) {
            throw "GEMINI_API_KEY no está configurado.`nObtén tu clave en: https://aistudio.google.com/apikey"
        }
        $resolvedBackend = 'gemini'
        Write-Host "Backend: Gemini gemini-2.0-flash-preview-image-generation (--backend gemini)" -ForegroundColor Cyan
    }
    'auto' {
        if ($env:OPENAI_API_KEY) {
            $resolvedBackend = 'openai'
            Write-Host "Backend: OpenAI gpt-image-1.5 (auto-detectado - OPENAI_API_KEY esta configurado)" -ForegroundColor Cyan
        }
        elseif ($env:GEMINI_API_KEY) {
            $resolvedBackend = 'gemini'
            Write-Host "Backend: Gemini gemini-2.0-flash-preview-image-generation (auto-detectado - solo GEMINI_API_KEY esta configurado)" -ForegroundColor Cyan
        }
        else {
            throw @"
No se encontró ninguna API key de generación de imágenes. Configura una de las siguientes:
  `$env:OPENAI_API_KEY = 'sk-...'    # desde https://platform.openai.com/api-keys
  `$env:GEMINI_API_KEY = 'AIza...'   # desde https://aistudio.google.com/apikey
"@
        }
    }
}
#endregion

#region -- Resolver tamaño por defecto según estilo --
if (-not $Size) {
    $Size = switch ($Style) {
        'whiteboard'         { '1536x1024' }
        'infographic'        { '1024x1536' }
        'presentation'       { '1536x1024' }
        'diagram'            { '1024x1024' }
        'mindmap'            { '1536x1024' }
        'mindmap-structured' { '1536x1024' }
        default              { '1024x1024' }
    }
}
#endregion

#region -- Preparar ruta de salida --
$outputDir  = [System.IO.Path]::GetFullPath($Output)
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

$outputPath = [System.IO.Path]::GetFullPath(
    [System.IO.Path]::Combine($outputDir, "$Prefix-$FrameIndex.png")
)
#endregion

#region -- Funciones de API --

function Invoke-WithRetry {
    <#
    .SYNOPSIS  Ejecuta un scriptblock reintentando en caso de rate limit (429).
    .PARAMETER ScriptBlock   Bloque de código a ejecutar.
    .PARAMETER MaxRetries    Número máximo de reintentos. Por defecto: 2.
    .PARAMETER RetryDelaySec Segundos base de espera antes del primer reintento. Por defecto: 5.
    #>
    param(
        [Parameter(Mandatory = $true)]
        [scriptblock]$ScriptBlock,

        [int]$MaxRetries    = 2,
        [int]$RetryDelaySec = 5
    )

    for ($attempt = 0; $attempt -le $MaxRetries; $attempt++) {
        try {
            return & $ScriptBlock
        }
        catch {
            $status = $null
            if ($_.Exception.Response) {
                $status = [int]$_.Exception.Response.StatusCode
            }

            # No reintentar en errores no transitorios
            if ($status -in @(400, 401, 403, 404)) {
                throw
            }

            if ($status -eq 429 -and $attempt -lt $MaxRetries) {
                $waitSec = $RetryDelaySec * [Math]::Pow(2, $attempt)
                Write-Warning "Rate limit (429). Reintentando en $waitSec segundos... (intento $($attempt + 1) de $MaxRetries)"
                Start-Sleep -Seconds $waitSec
            }
            else {
                throw
            }
        }
    }
}

function Invoke-OpenAIImageGeneration {
    <#
    .SYNOPSIS  Llama a la API de OpenAI gpt-image-1.5 y devuelve la imagen en base64.
    .PARAMETER Prompt    Prompt completo de generación.
    .PARAMETER ImageSize Dimensiones de la imagen, ej. "1024x1536".
    #>
    param(
        [Parameter(Mandatory = $true)] [string]$Prompt,
        [Parameter(Mandatory = $true)] [string]$ImageSize
    )

    $bodyObj = @{
        model  = 'gpt-image-1.5'
        prompt = $Prompt
        n      = 1
        size   = $ImageSize
        quality = 'high'
    }
    $jsonBody = [Text.Encoding]::UTF8.GetBytes(($bodyObj | ConvertTo-Json -Depth 3))

    $headers = @{
        'Authorization' = "Bearer $env:OPENAI_API_KEY"
        'Content-Type'  = 'application/json'
    }

    $response = Invoke-WithRetry -ScriptBlock {
        Invoke-RestMethod `
            -Uri         'https://api.openai.com/v1/images/generations' `
            -Method      Post `
            -Headers     $headers `
            -Body        $jsonBody `
            -ErrorAction Stop
    }

    return $response.data[0].b64_json
}

function Invoke-GeminiImageGeneration {
    <#
    .SYNOPSIS  Llama a la API de Gemini image generation y devuelve la imagen en base64.
    .PARAMETER Prompt    Prompt completo de generación.
    .PARAMETER ImageSize Dimensiones deseadas (se incluyen en el prompt, Gemini no acepta parámetro directo).
    #>
    param(
        [Parameter(Mandatory = $true)] [string]$Prompt,
        [Parameter(Mandatory = $true)] [string]$ImageSize
    )

    $fullPrompt = "Create a ${ImageSize} image. ${Prompt}"

    $bodyObj = @{
        contents         = @(
            @{
                parts = @(
                    @{ text = $fullPrompt }
                )
            }
        )
        generationConfig = @{
            responseModalities = @('IMAGE', 'TEXT')
        }
    }
    $jsonBody = [Text.Encoding]::UTF8.GetBytes(($bodyObj | ConvertTo-Json -Depth 10))

    $headers = @{ 'Content-Type' = 'application/json' }
    $uri     = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-preview-image-generation:generateContent?key=$env:GEMINI_API_KEY"

    $response = Invoke-WithRetry -ScriptBlock {
        Invoke-RestMethod `
            -Uri         $uri `
            -Method      Post `
            -Headers     $headers `
            -Body        $jsonBody `
            -ErrorAction Stop
    }

    return ($response.candidates[0].content.parts | Where-Object { $_.inlineData }).inlineData.data
}

#endregion

#region -- Llamar API y manejar errores --
Write-Host "Generando imagen: $resolvedBackend | estilo=$Style | tamaño=$Size" -ForegroundColor Cyan

$b64 = $null
try {
    if ($resolvedBackend -eq 'openai') {
        $b64 = Invoke-OpenAIImageGeneration -Prompt $prompt -ImageSize $Size
    }
    else {
        $b64 = Invoke-GeminiImageGeneration -Prompt $prompt -ImageSize $Size
    }
}
catch {
    $status = $null
    if ($_.Exception.Response) {
        $status = [int]$_.Exception.Response.StatusCode
    }

    switch ($status) {
        401 {
            throw "API key inválida o expirada. Verifica el valor de la variable de entorno."
        }
        403 {
            throw "Acceso denegado (403). Verifica los permisos de tu API key."
        }
        400 {
            $msg = $_.Exception.Message
            if ($msg -match 'content_policy|safety|policy|content') {
                throw "La solicitud fue rechazada por la política de contenido de la API. Reformula el prompt o cambia el estilo."
            }
            throw "Solicitud inválida (400): $msg"
        }
        $null {
            throw "No se pudo conectar con la API. Verifica tu conexión a Internet o intenta de nuevo.`nDetalle: $($_.Exception.Message)"
        }
        default {
            throw "Error inesperado ($status): $($_.Exception.Message)"
        }
    }
}
#endregion

#region -- Guardar PNG --
if (-not $b64) {
    throw "La API no devolvió datos de imagen. Verifica el prompt o el backend seleccionado."
}

$bytes = [Convert]::FromBase64String($b64)
[System.IO.File]::WriteAllBytes($outputPath, $bytes)
#endregion

Write-Host $outputPath
