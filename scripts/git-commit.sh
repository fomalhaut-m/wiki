#!/bin/bash
set -x

echo "===== 开始自动提交 ====="

CHANGES=$(git status --short)
echo "变更文件：$CHANGES"

if [ -z "$CHANGES" ]; then
    echo "无变更，退出"
    exit 0
fi

echo "执行 git add ."
git add .

echo "调用 AI 生成 commit..."
COMMIT_MSG=$(./scripts/call-minimax-api.sh "$CHANGES")

echo "最终 commit 信息：$COMMIT_MSG"

if [ -z "$COMMIT_MSG" ]; then
    echo "使用兜底 commit"
    COMMIT_MSG="chore: 更新文件"
fi

git commit -m "$COMMIT_MSG"

echo "===== 提交完成 ====="