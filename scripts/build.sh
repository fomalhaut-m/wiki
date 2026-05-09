#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

echo "========================================"
echo "  Luke's Wiki MkDocs 构建脚本"
echo "========================================"

if command -v python3 &> /dev/null; then
    PYTHON_CMD="python3"
elif command -v python &> /dev/null; then
    PYTHON_CMD="python"
else
    echo "❌ 未找到 Python，请先安装 Python 3"
    exit 1
fi

echo "检查 mkdocs..."
if ! $PYTHON_CMD -m mkdocs --version &> /dev/null; then
    echo "安装 mkdocs..."
    pip install mkdocs mkdocs-material
fi

echo "清理旧构建产物..."
rm -rf site

echo "构建静态站点..."
$PYTHON_CMD -m mkdocs build

echo ""
echo "========================================"
echo "✅ 构建完成！站点已生成: site/"
echo "========================================"