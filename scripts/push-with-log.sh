#!/bin/bash

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "   🚀 生成日志并Push"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if ! command -v git &> /dev/null; then
    echo "❌ Git命令不可用，请先安装Git"
    exit 1
fi

echo "🔍 检查未推送提交..."
UNPUSHED=$(git log --oneline origin/main..HEAD 2>/dev/null || git log --oneline origin/master..HEAD 2>/dev/null)

if [ -z "$UNPUSHED" ]; then
    echo "ℹ️ 没有未推送的提交，直接退出"
    exit 0
fi

echo "✅ 发现未推送的提交："
echo "$UNPUSHED" | sed 's/^/   /'

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

DEFAULT_LOG_CONTENT=$(printf "%s:\n1. %s\n%s" "$TODAY" "$DEFAULT_ENTRY" "$EXISTING_LOGS" | head -30)

USER_PROMPT="今天日期：${TODAY}

现有日志内容：
${EXISTING_LOGS}

本次Git变更内容：
${DIFF_CONTENT}

请生成完整的新日志内容，合并当天的所有变更，保持固定格式。"

SYSTEM_PROMPT="你是专业的项目变更日志生成助手。

【输出格式】（严格遵守）
```log
YYYY-MM-DD:
1. [emoji] 变更内容描述（动宾结构）
2. [emoji] 变更内容描述
- [emoji] 第三条描述
```

【关键规则】
1. 日期格式：YYYY-MM-DD，如 2026-05-12
2. 同一天的所有变更必须合并到同一个日期条目下，禁止重复创建相同日期
3. 不同日期按倒序排列，最新日期在最上面
4. 最多保留最近10个日期的日志

【Emoji使用】
- ✨ 新功能/新增内容
- 📝 文档更新/文案调整
- 🔧 配置/脚本优化
- 🐛 修复问题/BUG
- 🎨 格式/样式调整
- 🚀 性能/效率提升
- 🗑️ 删除冗余内容
- ♻️ 重构代码/逻辑
- ✅ 完成功能开发
- 📦 新增文件/依赖
- 🔄 移动/重命名文件
- 👤 用户/权限相关

【内容要求】
- 动宾结构：动词+具体对象，如"重构push-with-log.sh脚本"
- 明确变更范围：具体模块/文件/功能名称
- 控制在50字以内

【输出限制】
- 必须只输出log代码块内容
- 不要输出任何解释、说明或额外文字
- 不要输出代码块标记```log```，只输出内部内容"

if NEW_LOG_CONTENT=$(bash "./scripts/call-minimax-api.sh" "$USER_PROMPT" "$SYSTEM_PROMPT" 2>/dev/null); then
    if [ -z "$NEW_LOG_CONTENT" ] || [ "${#NEW_LOG_CONTENT}" -lt 10 ]; then
        echo "⚠️  AI返回内容无效，使用默认日志内容"
        NEW_LOG_CONTENT="$DEFAULT_LOG_CONTENT"
    fi
else
    echo "⚠️  API调用失败，使用默认日志内容"
    NEW_LOG_CONTENT="$DEFAULT_LOG_CONTENT"
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