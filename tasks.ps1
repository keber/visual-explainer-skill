<#
.SYNOPSIS
  Tareas de desarrollo para @keber/visual-explainer-skill (equivalente al Makefile, PowerShell nativo).

.EXAMPLE  .\tasks.ps1 help
.EXAMPLE  .\tasks.ps1 version
.EXAMPLE  .\tasks.ps1 bump-patch
.EXAMPLE  .\tasks.ps1 set-version 1.2.3
.EXAMPLE  .\tasks.ps1 release
.EXAMPLE  .\tasks.ps1 npm-pack
#>

[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string]$Task = 'help',

    [Parameter(Position = 1)]
    [string]$Arg = ''
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$MetadataFile = 'skill\metadata.json'
$SkillFile    = 'skill\visual-explainer.md'

function Get-Metadata {
    Get-Content $MetadataFile -Raw -Encoding UTF8 | ConvertFrom-Json
}

function Save-Metadata($obj) {
    $obj | ConvertTo-Json -Depth 10 | Set-Content $MetadataFile -Encoding UTF8
}

function Get-Version { (Get-Metadata).version }

function Write-TaskHeader($msg) {
    Write-Host "`n$msg" -ForegroundColor Cyan
}

switch ($Task) {

    'help' {
        $ver = Get-Version
        Write-Host "visual-explainer v$ver" -ForegroundColor White
        Write-Host ""
        Write-Host "Uso: .\tasks.ps1 <tarea> [argumento]" -ForegroundColor Gray
        Write-Host ""
        Write-Host "Tareas disponibles:" -ForegroundColor Yellow
        @(
            @{ Name = 'version';        Desc = 'Mostrar version actual del skill' }
            @{ Name = 'info';           Desc = 'Mostrar metadatos del skill' }
            @{ Name = 'check';          Desc = 'Verificar archivos y API keys' }
            @{ Name = 'bump-patch';     Desc = 'Incrementar version patch (x.y.Z)' }
            @{ Name = 'bump-minor';     Desc = 'Incrementar version minor (x.Y.0)' }
            @{ Name = 'bump-major';     Desc = 'Incrementar version major (X.0.0)' }
            @{ Name = 'set-version';    Desc = 'Establecer version: .\tasks.ps1 set-version 1.2.3' }
            @{ Name = 'release';        Desc = 'git commit + tag con la version actual' }
            @{ Name = 'npm-pack';       Desc = 'Empaquetar el modulo npm (npm pack)' }
        ) | ForEach-Object {
            Write-Host ("  {0,-16} {1}" -f $_.Name, $_.Desc)
        }
        Write-Host ""
    }

    'version' {
        Write-Host (Get-Version)
    }

    'info' {
        $m = Get-Metadata
        Write-Host "Name:        $($m.name)"
        Write-Host "Version:     $($m.version)"
        Write-Host "Author:      $($m.author.name) ($($m.author.url))"
        Write-Host "Fork of:     $($m.fork.of) by $($m.fork.author) - $($m.fork.url)"
        Write-Host "Description: $($m.description)"
        Write-Host "Styles:      $($m.styles -join ', ')"
        Write-Host "Updated:     $($m.updated)"
    }

    'check' {
        Write-TaskHeader "Verificando prerequisitos..."

        $ok = $true

        if (-not (Test-Path $SkillFile)) {
            Write-Host "  [ERROR] No encontrado: $SkillFile" -ForegroundColor Red
            $ok = $false
        } else {
            Write-Host "  [OK]    $SkillFile" -ForegroundColor Green
        }

        if (-not (Test-Path $MetadataFile)) {
            Write-Host "  [ERROR] No encontrado: $MetadataFile" -ForegroundColor Red
            $ok = $false
        } else {
            Write-Host "  [OK]    $MetadataFile" -ForegroundColor Green
        }

        $ps1 = '.github\skills\visual-explainer\scripts\visual-explainer.ps1'
        if (-not (Test-Path $ps1)) {
            Write-Host "  [ERROR] No encontrado: $ps1" -ForegroundColor Red
            $ok = $false
        } else {
            Write-Host "  [OK]    $ps1" -ForegroundColor Green
        }

        if ($env:OPENAI_API_KEY -and $env:GEMINI_API_KEY) {
            Write-Host "  [OK]    API keys: OpenAI (set), Gemini (set) - backend por defecto: OpenAI" -ForegroundColor Green
        } elseif ($env:OPENAI_API_KEY) {
            Write-Host "  [OK]    API key: OPENAI_API_KEY (set)" -ForegroundColor Green
        } elseif ($env:GEMINI_API_KEY) {
            Write-Host "  [OK]    API key: GEMINI_API_KEY (set)" -ForegroundColor Green
        } else {
            Write-Host "  [WARN]  No se detecto ninguna API key." -ForegroundColor Yellow
            Write-Host "          Configura OPENAI_API_KEY o GEMINI_API_KEY." -ForegroundColor Yellow
        }

        if ($ok) {
            Write-Host "`nTodo OK" -ForegroundColor Green
        } else {
            Write-Host "`nHay errores." -ForegroundColor Red
            exit 1
        }
    }

    'bump-patch' {
        $m   = Get-Metadata
        $parts = $m.version -split '\.'
        $parts[2] = [int]$parts[2] + 1
        $old = $m.version
        $m.version = $parts -join '.'
        $m.updated = (Get-Date -Format 'yyyy-MM-dd')
        Save-Metadata $m
        npm version $m.version --no-git-tag-version | Out-Null
        Write-Host "Version: $old -> $($m.version)" -ForegroundColor Green
    }

    'bump-minor' {
        $m   = Get-Metadata
        $parts = $m.version -split '\.'
        $parts[1] = [int]$parts[1] + 1
        $parts[2] = 0
        $old = $m.version
        $m.version = $parts -join '.'
        $m.updated = (Get-Date -Format 'yyyy-MM-dd')
        Save-Metadata $m
        npm version $m.version --no-git-tag-version | Out-Null
        Write-Host "Version: $old -> $($m.version)" -ForegroundColor Green
    }

    'bump-major' {
        $m   = Get-Metadata
        $parts = $m.version -split '\.'
        $parts[0] = [int]$parts[0] + 1
        $parts[1] = 0
        $parts[2] = 0
        $old = $m.version
        $m.version = $parts -join '.'
        $m.updated = (Get-Date -Format 'yyyy-MM-dd')
        Save-Metadata $m
        npm version $m.version --no-git-tag-version | Out-Null
        Write-Host "Version: $old -> $($m.version)" -ForegroundColor Green
    }

    'set-version' {
        if (-not $Arg) {
            Write-Host "Uso: .\tasks.ps1 set-version 1.2.3" -ForegroundColor Red
            exit 1
        }
        if ($Arg -notmatch '^\d+\.\d+\.\d+$') {
            Write-Host "Error: la version debe ser semver (ej. 1.2.3)" -ForegroundColor Red
            exit 1
        }
        $m = Get-Metadata
        $old = $m.version
        $m.version = $Arg
        $m.updated = (Get-Date -Format 'yyyy-MM-dd')
        Save-Metadata $m
        npm version $Arg --no-git-tag-version | Out-Null
        Write-Host "Version: $old -> $Arg" -ForegroundColor Green
    }

    'release' {
        $ver = Get-Version
        Write-TaskHeader "Publicando visual-explainer v$ver..."
        git add $MetadataFile $SkillFile
        git commit -m "Release v$ver"
        git tag -a "v$ver" -m "Release v$ver"
        Write-Host "Commit y tag v$ver creados." -ForegroundColor Green
        Write-Host "Ejecuta 'git push && git push --tags' para publicar." -ForegroundColor Yellow
    }

    'npm-pack' {
        Write-TaskHeader "Empaquetando @keber/visual-explainer-skill..."
        npm pack
    }

    default {
        Write-Host "Tarea desconocida: '$Task'. Ejecuta .\tasks.ps1 help" -ForegroundColor Red
        exit 1
    }
}
