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
echo "🔧 检查工作目录..."
STATUS=$(git status --porcelain)
HAS_UNCOMMITTED=false
if [ -n "$STATUS" ]; then
    HAS_UNCOMMITTED=true
    echo "✅ 发现未提交的变更:"
    echo "$STATUS"
else
    echo "⚠️ 工作目录干净"
fi

# 检查是否有未推送的提交
echo "🔧 检查未推送提交..."
UNPUSHED=$(git log --oneline origin/main..HEAD 2>/dev/null)
HAS_UNPUSHED=false
if [ -n "$UNPUSHED" ]; then
    HAS_UNPUSHED=true
    echo "✅ 发现未推送的提交:"
    echo "$UNPUSHED"
else
    echo "⚠️ 没有未推送的提交"
fi

# 更新日志的函数
update_log() {
    local LOG_ENTRY="$1"
    
    LOG_FILE="docs/log/index.md"
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M")
    NEW_ENTRY="$TIMESTAMP: $LOG_ENTRY"
    
    TEMP_FILE=$(mktemp)
    
    if [ -f "$LOG_FILE" ]; then
        EXISTING_LOGS=$(sed -n '/^```log$/,/^```$/p' "$LOG_FILE" | sed '1d;$d')
    else
        EXISTING_LOGS=""
    fi
    
    ALL_LOGS=$(echo -e "$NEW_ENTRY\n$EXISTING_LOGS" | head -10)
    
    echo "# 更新日志" > "$TEMP_FILE"
    echo "" >> "$TEMP_FILE"
    echo "这里记录项目的主要更新和变更。" >> "$TEMP_FILE"
    echo "" >> "$TEMP_FILE"
    echo '```log' >> "$TEMP_FILE"
    echo "$ALL_LOGS" >> "$TEMP_FILE"
    echo '```' >> "$TEMP_FILE"
    echo "" >> "$TEMP_FILE"
    echo "---" >> "$TEMP_FILE"
    echo "" >> "$TEMP_FILE"
    echo "更多历史记录请查看 [Git 提交历史](https://github.com/fomalhaut-m/wike/commits/main)" >> "$TEMP_FILE"
    
    mv "$TEMP_FILE" "$LOG_FILE"
    
    echo "📋 更新后的日志:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    cat "$LOG_FILE"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    git add "$LOG_FILE"
    git commit -m "chore: 更新日志"
    echo "✅ 日志已提交"
}

# 如果有未提交的变更且有 API Key
if [ "$HAS_UNCOMMITTED" = true ] && [ -n "$API_KEY" ]; then
    echo "🔧 Step 1/4: 获取变更摘要..."
    DIFF=$(git diff --stat)
    echo "$DIFF"
    
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
    update_log "$LOG_ENTRY"

# 如果没有未提交变更但有未推送提交且有 API Key
elif [ "$HAS_UNCOMMITTED" = false ] && [ "$HAS_UNPUSHED" = true ] && [ -n "$API_KEY" ]; then
    echo "🔧 获取最近提交信息..."
    LATEST_COMMIT=$(git log --format="%s" -1)
    echo "最近提交: $LATEST_COMMIT"
    
    echo "🔧 调用 Minimax AI 生成日志..."
    AI_RESULT=$(curl -s -X POST https://api.minimax.chat/v1/text/completion \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $API_KEY" \
      -d '{
        "model": "abab5.5-chat",
        "prompt": "请将以下Git提交信息转换为简洁的更新日志（中文，30字以内）：\n\n'"$LATEST_COMMIT"'",
        "max_tokens": 50
      }')
    
    LOG_ENTRY=$(echo "$AI_RESULT" | grep -oP '(?<="text":")[^"]+')
    if [ -z "$LOG_ENTRY" ] || [ "$LOG_ENTRY" = "null" ]; then
        LOG_ENTRY="$LATEST_COMMIT"
    fi
    
    echo "✅ AI 生成: $LOG_ENTRY"
    update_log "$LOG_ENTRY"

elif [ -n "$HAS_UNCOMMITTED" = true ] && [ -z "$API_KEY" ]; then
    echo "⚠️ 未设置 MINIMAX_API_KEY，跳过日志更新"
    echo "提示: export MINIMAX_API_KEY=your_key"
fi

# 执行 Push
echo "🔧 执行推送..."
git push
echo "✅ 推送完成!"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "   ✅ 操作完成!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"