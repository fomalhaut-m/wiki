#!/bin/bash
# scripts/init.sh - 项目初始化脚本

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "   🚀 Luke's Wiki 初始化"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 配置 Git Hooks
echo ""
echo "🔧 配置 Git Hooks..."
git config core.hooksPath .githooks
if [ $? -eq 0 ]; then
    echo "✅ Hooks 配置完成"
else
    echo "❌ Hooks 配置失败"
    exit 1
fi

# 验证配置
echo ""
echo "🔍 验证配置..."
HOOKS_PATH=$(git config --get core.hooksPath)
echo "当前 hooksPath: $HOOKS_PATH"

# 检查钩子文件
echo ""
echo "📋 可用钩子:"
ls -la .githooks/

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "   ✅ 初始化完成!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📝 现在可以开始使用了！"
echo "   提交代码时会自动更新 docs/log/index.md"
echo ""