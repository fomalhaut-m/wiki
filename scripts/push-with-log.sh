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

# 调用 Minimax Chat API 的函数
call_minimax_chat() {
    local USER_PROMPT="$1"
    
    # 系统提示词 - 定义 AI 的角色和行为
    local SYSTEM_PROMPT="你是一个专业的文档更新日志生成助手。
你的任务是将 Git 提交信息或代码变更摘要转换为简洁、清晰的更新日志条目。

规则：
1. 输出必须是中文，语言自然流畅
2. 长度控制在 30 字以内
3. 只输出日志内容，不要添加额外说明
4. 使用动宾结构，如：修复xxx问题、新增xxx功能、优化xxx性能
5. 严格基于输入内容生成，不得添加任何想象或虚构信息"
    
    # 构建请求 JSON（使用 chat 接口格式，添加 imagine: false 禁止想象）
    local REQUEST_JSON=$(cat << EOF
{
  "model": "abab5.5-chat",
  "messages": [
    {"role": "system", "content": "$(echo "$SYSTEM_PROMPT" | sed 's/"/\\"/g')"},
    {"role": "user", "content": "$(echo "$USER_PROMPT" | sed 's/"/\\"/g')"}
  ],
  "max_tokens": 50,
  "imagine": false,
  "temperature": 0.1
}
EOF
)
    
    AI_RESULT=$(curl -s -X POST https://api.minimax.chat/v1/chat/completions \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer $API_KEY" \
      -d "$REQUEST_JSON")
    
    # 从 chat 接口响应中提取内容
    LOG_ENTRY=$(echo "$AI_RESULT" | grep -oP '(?<="content":")[^"]+' | head -1)
    if [ -z "$LOG_ENTRY" ] || [ "$LOG_ENTRY" = "null" ]; then
        LOG_ENTRY="文档更新"
    fi
    
    echo "$LOG_ENTRY"
}

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
    echo "🔧 获取变更摘要..."
    DIFF=$(git diff --stat)
    echo "$DIFF"
    
    echo "🔧 调用 Minimax Chat API..."
    USER_PROMPT="请分析以下Git代码变更，生成更新日志条目：\n\n$DIFF"
    LOG_ENTRY=$(call_minimax_chat "$USER_PROMPT")
    
    echo "✅ AI 生成: $LOG_ENTRY"
    update_log "$LOG_ENTRY"

# 如果没有未提交变更但有未推送提交且有 API Key
elif [ "$HAS_UNCOMMITTED" = false ] && [ "$HAS_UNPUSHED" = true ] && [ -n "$API_KEY" ]; then
    echo "🔧 获取最近提交信息..."
    LATEST_COMMIT=$(git log --format="%s" -1)
    echo "最近提交: $LATEST_COMMIT"
    
    echo "🔧 调用 Minimax Chat API..."
    USER_PROMPT="请将以下Git提交信息转换为更新日志条目：\n\n$LATEST_COMMIT"
    LOG_ENTRY=$(call_minimax_chat "$USER_PROMPT")
    
    echo "✅ AI 生成: $LOG_ENTRY"
    update_log "$LOG_ENTRY"

elif [ "$HAS_UNCOMMITTED" = true ] && [ -z "$API_KEY" ]; then
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