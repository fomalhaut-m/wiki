Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Luke's Wiki MkDocs 构建脚本" -ForegroundColor Cyan
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

Write-Host "清理旧构建产物..." -ForegroundColor Yellow
if (Test-Path site) {
    Remove-Item -Recurse -Force site -ErrorAction SilentlyContinue
}

Write-Host "构建静态站点..." -ForegroundColor Yellow
& $PythonCmd -m mkdocs build

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "✅ 构建完成！站点已生成: site/" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green