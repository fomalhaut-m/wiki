#!/bin/bash
# scripts/push-with-log.sh - Push时自动更新日志

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "   🚀 Push 并自动更新日志"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 从环境变量获取 API Key
API_KEY=${MINIMAX_API_KEY}

# 检查是否有未提交的变更
STATUS=$(git status --porcelain)
HAS_UNCOMMITTED=false
if [ -n "$STATUS" ]; then
    HAS_UNCOMMITTED=true
    echo ""
    echo "🔧 发现未提交的变更:"
    echo "$STATUS"
fi

# 如果有未提交的变更且有 API Key，调用 AI 生成日志
if [ "$HAS_UNCOMMITTED" = true ] && [ -n "$API_KEY" ]; then
    echo ""
    echo "🔧 Step 1/4: 获取变更摘要..."
    DIFF=$(git diff --stat)
    echo "$DIFF"
    
    echo ""
    echo "🔧 Step 2/4: 调用 Minimax AI 生成日志..."
    AI_RESULT=$(curl -s -X POST https://api.minimax.chat/v1/text/completion \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $API_KEY" \
      -d '{
        "model": "abab5.5-chat",
        "prompt": "请总结以下Git变更为简洁的更新日志条目（中文，不超过50字）：\n\n'"$DIFF"'",
        "max_tokens": 100
      }')
    
    LOG_ENTRY=$(echo "$AI_RESULT" | grep -oP '(?<="text":")[^"]+')
    if [ -z "$LOG_ENTRY" ] || [ "$LOG_ENTRY" = "null" ]; then
        LOG_ENTRY="文档内容更新"
    fi
    
    echo "✅ AI 生成结果:"
    echo "   $LOG_ENTRY"
    
    # 更新日志文件
    DATE=$(date +"%Y-%m-%d")
    LOG_FILE="docs/log/index.md"
    
    echo ""
    echo "🔧 Step 3/4: 更新日志文件..."
    
    if grep -q "^## $DATE$" "$LOG_FILE"; then
        # 在今天的功能更新后面追加
        awk -v entry="$LOG_ENTRY" '
        /^### 功能更新$/ {
            print $0
            print ""
            print "- " entry
            next
        }
        1
        ' "$LOG_FILE" > "${LOG_FILE}.tmp"
        mv "${LOG_FILE}.tmp" "$LOG_FILE"
        
        echo "✅ 已追加到今天的记录:"
        echo "   - $LOG_ENTRY"
    else
        # 在 "---" 之前插入新日期区块
        awk -v date="$DATE" -v entry="$LOG_ENTRY" '
        /^---$/ {
            print ""
            print "## " date
            print ""
            print "### 功能更新"
            print ""
            print "- " entry
            print ""
            print "---"
            next
        }
        1
        ' "$LOG_FILE" > "${LOG_FILE}.tmp"
        mv "${LOG_FILE}.tmp" "$LOG_FILE"
        
        echo "✅ 已创建新日期区块:"
        echo "   ## $DATE"
        echo "   ### 功能更新"
        echo "   - $LOG_ENTRY"
    fi
    
    # 显示更新后的日志内容
    echo ""
    echo "📋 更新后的日志内容:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    head -30 "$LOG_FILE"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # 提交日志
    git add "$LOG_FILE"
    git commit -m "chore: 更新日志"
    echo "✅ 日志已提交"
fi

# 执行 Push
echo ""
echo "🔧 Step 4/4: 推送到远程..."
git push
echo "✅ 推送完成!"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "   ✅ 操作完成!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"