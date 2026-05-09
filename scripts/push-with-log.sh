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

# 检查是否在 Git 仓库中
if ! git rev-parse --is-inside-work-tree &> /dev/null; then
    echo "❌ 当前目录不是 Git 仓库"
    exit 1
fi

# 从环境变量获取 API Key
API_KEY=${MINIMAX_API_KEY}

# 检查是否有未提交的工作目录变更
echo ""
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
echo ""
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
        "prompt": "请分析以下Git代码变更，生成一条简洁、清晰的更新日志条目（中文，50字以内）：\n\n'"$DIFF"'",
        "max_tokens": 1000
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
    
    echo ""
    echo "📋 更新后的日志内容:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    head -30 "$LOG_FILE"
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