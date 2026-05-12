#!/bin/bash

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "   🚀 生成日志并Push"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if ! command -v git &> /dev/null; then
    echo "❌ Git命令不可用，请先安装Git"
    exit 1
fi

API_KEY=${MINIMAX_API_KEY}

echo "🔍 检查未推送提交..."
UNPUSHED=$(git log --oneline origin/main..HEAD 2>/dev/null || git log --oneline origin/master..HEAD 2>/dev/null)

if [ -z "$UNPUSHED" ]; then
    echo "ℹ️ 没有未推送的提交，直接退出"
    exit 0
fi

echo "✅ 发现未推送的提交："
echo "$UNPUSHED" | sed 's/^/   /'

call_minimax_chat() {
    local USER_PROMPT="$1"
    local DEFAULT_OUTPUT="$2"

    if [ -z "$API_KEY" ]; then
        echo "$DEFAULT_OUTPUT"
        return
    fi

    local PROMPT_FILE="./scripts/changelog-prompt.md"
    if [ ! -f "$PROMPT_FILE" ]; then
        echo "$DEFAULT_OUTPUT"
        return
    fi

    local SYSTEM_PROMPT=$(cat "$PROMPT_FILE")

    if ! command -v jq &> /dev/null; then
        echo "$DEFAULT_OUTPUT"
        return
    fi

    local SYSTEM_JSON=$(printf '%s' "$SYSTEM_PROMPT" | jq -Rs '.')
    local USER_JSON=$(printf '%s' "$USER_PROMPT" | jq -Rs '.')

    local REQUEST_BODY=$(jq -n \
        --arg model "abab5.5-chat" \
        --argjson system_content "$SYSTEM_JSON" \
        --argjson user_content "$USER_JSON" \
        '{
            model: $model,
            messages: [
                {role: "system", content: $system_content},
                {role: "user", content: $user_content}
            ],
            max_tokens: 1000,
            imagine: false,
            temperature: 0.1
        }')

    local AI_RESULT=$(curl -s -w "\nHTTP_STATUS:%{http_code}" \
        -X POST "https://api.minimax.chat/v1/chat/completions" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $API_KEY" \
        -d "$REQUEST_BODY")

    echo "AI_RESULT: $AI_RESULT"

    local HTTP_STATUS=$(echo "$AI_RESULT" | grep -oP 'HTTP_STATUS:\K\d+$')
    local RESPONSE_BODY=$(echo "$AI_RESULT" | sed '$d')



    if [ "$HTTP_STATUS" != "200" ]; then
        echo "$DEFAULT_OUTPUT"
        return
    fi

    local LOG_CONTENT=$(echo "$RESPONSE_BODY" | jq -r '.choices[0].message.content // empty')

    if [ -z "$LOG_CONTENT" ] || [ "$LOG_CONTENT" = "null" ]; then
        echo "$DEFAULT_OUTPUT"
        return
    fi

    echo "$LOG_CONTENT"
}

echo -e "\n🤖 生成更新日志..."

LOG_FILE="docs/log/index.md"
TODAY=$(date +"%Y-%m-%d")

if [ -f "$LOG_FILE" ]; then
    EXISTING_LOGS=$(sed -n '/^```log$/,/^```$/p' "$LOG_FILE" | sed '1d;$d')
else
    EXISTING_LOGS=""
fi

DIFF_CONTENT=$(git log --stat origin/main..HEAD 2>/dev/null || git log --stat origin/master..HEAD 2>/dev/null)

DEFAULT_ENTRY="更新文档"
if echo "$DIFF_CONTENT" | grep -q "docs/.*\.md"; then
    DOC_COUNT=$(echo "$DIFF_CONTENT" | grep -c "\.md")
    DEFAULT_ENTRY="更新${DOC_COUNT}篇文档"
    if echo "$DIFF_CONTENT" | grep -q "新增\|create\|add"; then DEFAULT_ENTRY="新增文档内容"; fi
    if echo "$DIFF_CONTENT" | grep -q "整理\|分类\|重构\|结构调整"; then DEFAULT_ENTRY="优化文档分类结构"; fi
    if echo "$DIFF_CONTENT" | grep -q "GetX\|getx\|flutter"; then DEFAULT_ENTRY="更新Flutter/GETX教程"; fi
    if echo "$DIFF_CONTENT" | grep -q "脚本\|script\|sh"; then DEFAULT_ENTRY="优化自动化脚本"; fi
else
    DEFAULT_ENTRY="优化代码功能"
fi

DEFAULT_LOG_CONTENT=$(printf "%s:\n- %s\n%s" "$TODAY" "$DEFAULT_ENTRY" "$EXISTING_LOGS" | head -20)

NEW_LOG_CONTENT=$(call_minimax_chat "今天日期：$TODAY
现有日志内容：
$EXISTING_LOGS
本次Git变更内容：
$DIFF_CONTENT
请生成完整的新日志内容，合并当天的所有变更，保持固定格式。" "$DEFAULT_LOG_CONTENT")

if echo "$NEW_LOG_CONTENT" | grep -q "^\`\`\`log"; then
    NEW_LOG_CONTENT=$(echo "$NEW_LOG_CONTENT" | sed -n '/^```log$/,/^```$/p' | sed '1d;$d')
fi

echo "✅ 生成的日志内容："
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "$NEW_LOG_CONTENT" | sed 's/^/  /'
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

echo "🔧 写入日志文件..."

TEMP_FILE=$(mktemp)
echo "# 更新日志" > "$TEMP_FILE"
echo "" >> "$TEMP_FILE"
echo "这里记录项目的主要更新和变更。" >> "$TEMP_FILE"
echo "" >> "$TEMP_FILE"
echo '```log' >> "$TEMP_FILE"
echo "$NEW_LOG_CONTENT" >> "$TEMP_FILE"
echo '```' >> "$TEMP_FILE"
echo "" >> "$TEMP_FILE"
echo "---" >> "$TEMP_FILE"
echo "" >> "$TEMP_FILE"
echo "更多历史记录请查看 [Git 提交历史](https://github.com/fomalhaut-m/wike/commits/main)" >> "$TEMP_FILE"
mv "$TEMP_FILE" "$LOG_FILE"

echo "🔧 提交日志变更..."
git add "$LOG_FILE"
git commit -m "chore: 更新日志" -q

echo -e "\n🚀 执行Push..."
git push || git push origin main || git push origin master

echo "✅ Push完成！"
echo -e "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "   ✅ 操作完成！"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"