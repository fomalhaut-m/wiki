#!/bin/bash
# scripts/push-with-log.sh - Push时自动更新日志

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "   🚀 Push 并自动更新日志"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 检查 git 是否可用
if ! command -v git &> /dev/null; then
    echo "❌ Git 命令不可用"
    exit 1
fi

# 从环境变量获取 API Key
API_KEY=${MINIMAX_API_KEY}

# 检查是否有未提交的变更
STATUS=$(git status --porcelain)
HAS_UNCOMMITTED=false
if [ -n "$STATUS" ]; then
    HAS_UNCOMMITTED=true
    echo ""
    echo "✅ 发现未提交的变更:"
    echo "$STATUS"
else
    echo ""
    echo "⚠️ 工作目录干净"
fi

# 如果有未提交的变更且有 API Key
if [ "$HAS_UNCOMMITTED" = true ] && [ -n "$API_KEY" ]; then
    echo ""
    echo "🔧 Step 1/4: 获取变更摘要..."
    DIFF=$(git diff --stat)
    echo "$DIFF"
    
    echo ""
    echo "🔧 Step 2/4: 调用 Minimax AI..."
    AI_RESULT=$(curl -s -X POST https://api.minimax.chat/v1/text/completion \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $API_KEY" \
      -d '{
        "model": "abab5.5-chat",
        "prompt": "请分析以下Git代码变更，生成一条简洁的更新描述（中文，30字以内）：\n\n'"$DIFF"'",
        "max_tokens": 50
      }')
    
    LOG_ENTRY=$(echo "$AI_RESULT" | grep -oP '(?<="text":")[^"]+')
    if [ -z "$LOG_ENTRY" ] || [ "$LOG_ENTRY" = "null" ]; then
        LOG_ENTRY="文档更新"
    fi
    
    echo "✅ AI 生成: $LOG_ENTRY"
    
    # 获取当前时间
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M")
    NEW_ENTRY="$TIMESTAMP: $LOG_ENTRY"
    
    # 更新日志文件
    LOG_FILE="docs/log/index.md"
    
    # 提取现有日志条目
    EXISTING_LOGS=$(awk '/^```log$/,/^```$/' "$LOG_FILE" | grep -v "^```")
    
    # 合并新条目和旧条目（只保留最近10条）
    ALL_LOGS=$(echo -e "$NEW_ENTRY\n$EXISTING_LOGS" | head -10)
    
    # 重新生成日志文件（使用 echo 序列避免引号冲突）
    {
        echo "# 更新日志"
        echo ""
        echo "这里记录项目的主要更新和变更。"
        echo ""
        echo '```log'
        echo "$ALL_LOGS"
        echo '```'
        echo ""
        echo "---"
        echo ""
        echo "更多历史记录请查看 [Git 提交历史](https://github.com/fomalhaut-m/wike/commits/main)"
    } > "$LOG_FILE"
    
    echo ""
    echo "📋 更新后的日志:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    cat "$LOG_FILE"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    git add "$LOG_FILE"
    git commit -m "chore: 更新日志"
    echo "✅ 日志已提交"
elif [ "$HAS_UNCOMMITTED" = true ] && [ -z "$API_KEY" ]; then
    echo ""
    echo "⚠️ 未设置 MINIMAX_API_KEY，跳过日志更新"
    echo "提示: export MINIMAX_API_KEY=your_key"
fi

# 执行 Push
echo ""
echo "🔧 执行推送..."
git push
echo "✅ 推送完成!"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "   ✅ 操作完成!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"