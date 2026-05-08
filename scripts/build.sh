#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

echo "检查 Node.js 环境..."

if ! command -v node &> /dev/null; then
    echo "Node.js 未安装，正在安装..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y nodejs npm
    elif command -v yum &> /dev/null; then
        sudo yum install -y nodejs npm
    elif command -v brew &> /dev/null; then
        brew install node
    fi
fi

echo "安装依赖..."
npm install

echo "构建静态站点..."
npm run build

echo "复制到 site/ 目录..."
rm -rf site
cp -r docs/.vitepress/dist site

echo ""
echo "========================================"
echo "静态站点已生成: site/"
echo "========================================"