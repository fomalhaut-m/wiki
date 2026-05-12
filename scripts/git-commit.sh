#!/bin/bash
set -x

echo "===== 开始自动提交 ====="

# 解决中文乱码
git config core.quotepath off

# 拿到【真正的代码修改内容】，不是文件名！
CHANGES_CONTENT=$(git diff --no-ext-diff --unified=1 | head -50)

# 如果没有 diff，用文件变更
if [ -z "$CHANGES_CONTENT" ]; then
  CHANGES_CONTENT=$(git status --short)
fi

echo "实际修改内容："
echo "$CHANGES_CONTENT"

if [ -z "$CHANGES_CONTENT" ]; then
  echo "无变更，退出"
  exit 0
fi

echo "执行 git add ."
git add . 2>/dev/null

echo "调用 AI 生成 commit..."
COMMIT_MSG=$(./scripts/call-minimax-api.sh "$CHANGES_CONTENT")

echo "最终 commit 信息：$COMMIT_MSG"

if [ -z "$COMMIT_MSG" ]; then
  echo "使用兜底 commit"
  COMMIT_MSG="docs: 更新小说章节内容"
fi

git commit -m "$COMMIT_MSG"

echo "===== 提交完成 ====="