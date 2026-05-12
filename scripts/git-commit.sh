#!/bin/bash

echo "===== 生成 Git Commit 消息 ====="

if ! command -v git &> /dev/null; then
    echo "❌ Git命令不可用"
    exit 1
fi

git config core.quotepath off 2>/dev/null

CHANGES_CONTENT=$(git diff --no-ext-diff --unified=1 | head -50)

if [ -z "$CHANGES_CONTENT" ]; then
    CHANGES_CONTENT=$(git status --short)
fi

echo "变更内容："
echo "$CHANGES_CONTENT"

if [ -z "$CHANGES_CONTENT" ]; then
    echo "无变更，退出"
    exit 0
fi

echo -e "\n🤖 调用 AI 生成 commit..."

USER_PROMPT="请根据以下代码变更生成一个简洁的 Git commit 消息。

变更内容：
${CHANGES_CONTENT}

要求：
1. 使用中文
2. 格式：类型: 简短描述
3. 类型可选：feat(新功能)、fix(修复)、docs(文档)、style(格式)、refactor(重构)、perf(性能)、test(测试)、chore(杂项)
4. 描述控制在 50 字以内
5. 只输出 commit 消息，不要任何解释"

SYSTEM_PROMPT="你是 Git commit 消息生成助手。

【输出格式】
只输出一行 commit 消息，格式：类型: 简短描述

【类型说明】
- feat: 新功能
- fix: 修复问题
- docs: 文档更新
- style: 代码格式（不影响功能）
- refactor: 重构（不是修复也不是新功能）
- perf: 性能优化
- test: 测试相关
- chore: 杂项（构建、工具、配置）

【要求】
- 使用中文
- 简短明确
- 只输出 commit 消息，不要引号或任何额外内容"

COMMIT_MSG=$(python "./scripts/call-minimax-api.py" "$USER_PROMPT" "$SYSTEM_PROMPT" 2>/dev/null)

echo "AI 生成 commit 消息：$COMMIT_MSG"

if [ -z "$COMMIT_MSG" ] || [ "${#COMMIT_MSG}" -lt 5 ]; then
    echo "⚠️  AI返回无效，使用默认消息"
    COMMIT_MSG="docs: 更新项目文档"
fi

echo -e "\n✅ 最终 commit：$COMMIT_MSG"

echo -e "\n📝 执行 git add ."
git add . 2>/dev/null

echo "📝 执行 git commit"
# git commit -m "$COMMIT_MSG"

echo "===== 提交完成 ====="