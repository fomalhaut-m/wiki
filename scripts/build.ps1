$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectDir = Split-Path -Parent $ScriptDir

Set-Location $ProjectDir

Write-Host "检查 Node.js 环境..." -ForegroundColor Cyan

if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "Node.js 未安装，请先安装 Node.js" -ForegroundColor Red
    Write-Host "下载地址: https://nodejs.org/" -ForegroundColor Yellow
    exit 1
}

Write-Host "安装依赖..." -ForegroundColor Cyan
npm install

if ($LASTEXITCODE -ne 0) {
    Write-Host "安装依赖失败!" -ForegroundColor Red
    exit 1
}

Write-Host "构建静态站点..." -ForegroundColor Cyan
npm run build

if ($LASTEXITCODE -ne 0) {
    Write-Host "构建失败!" -ForegroundColor Red
    exit 1
}

Write-Host "复制到 site/ 目录..." -ForegroundColor Cyan
if (Test-Path "site") {
    Remove-Item -Recurse -Force "site"
}
Copy-Item -Recurse "docs/.vitepress/dist" "site"

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "静态站点已生成: site/" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green