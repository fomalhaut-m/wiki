#!/bin/bash
set -x

echo "===== 开始自动提交 ====="

# 解决 Git 中文乱码（八进制 \xxx 问题）
git config core.quotepath off

# 获取干净的变更列表
CHANGES=$(git status --short)
echo "变更文件：$CHANGES"

if [ -z "$CHANGES" ]; then
    echo "无变更，退出"
    exit 0
fi

echo "执行 git add ."
git add . 2>/dev/null

echo "调用 AI 生成 commit..."
# 修复路径：改成 scripts 下的正确路径
COMMIT_MSG=$(./scripts/call-minimax-api.sh "$CHANGES")

echo "最终 commit 信息：$COMMIT_MSG"

if [ -z "$COMMIT_MSG" ]; then
    echo "使用兜底 commit"
    COMMIT_MSG="docs: 更新小说章节"
fi

git commit -m "$COMMIT_MSG"

echo "===== 提交完成 ====="