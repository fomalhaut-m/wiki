Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Luke's Wiki MkDocs 预览服务" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectDir = Split-Path -Parent $ScriptDir
Set-Location $ProjectDir

$PythonCmd = if (Get-Command python -ErrorAction SilentlyContinue) { "python" } elseif (Get-Command python3 -ErrorAction SilentlyContinue) { "python3" } else { $null }

if (-not $PythonCmd) {
    Write-Host "❌ 未找到 Python，请先安装 Python 3" -ForegroundColor Red
    exit 1
}

Write-Host "检查 mkdocs..." -ForegroundColor Yellow
try {
    & $PythonCmd -m mkdocs --version 2>$null | Out-Null
} catch {
    Write-Host "安装 mkdocs..." -ForegroundColor Yellow
    & pip install mkdocs mkdocs-material 2>$null | Out-Null
}

Write-Host ""
Write-Host "启动预览服务: http://localhost:8000" -ForegroundColor Green
Write-Host "按 Ctrl+C 停止服务" -ForegroundColor Gray
Write-Host ""

& $PythonCmd -m mkdocs serve -a 0.0.0.0:8000