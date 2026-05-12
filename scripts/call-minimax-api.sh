#!/bin/bash

set -x

INPUT="$1"
echo "[DEBUG] 输入内容：$INPUT"

if [ -z "$MINIMAX_API_KEY" ]; then
    echo "[DEBUG] 未设置 MINIMAX_API_KEY，使用默认提交信息"
    echo "chore: 更新脚本文件"
    exit 0
fi

echo "[DEBUG] 开始请求 AI API"

RES=$(curl -s --connect-timeout 5 \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $MINIMAX_API_KEY" \
  -d "{
    \"model\":\"MiniMax-M2\",
    \"messages\":[
      {\"role\":\"system\",\"content\":\"生成git commit，只返回结果，格式：feat: xxx\"},
      {\"role\":\"user\",\"content\":\"$INPUT\"}
    ],
    \"temperature\":0.1
  }")

echo "[DEBUG] API 返回：$RES"

MSG=$(echo "$RES" | sed -e 's/^.*"content":"//' -e 's/".*$//' | head -1)
echo "[DEBUG] 解析结果：$MSG"

if [ -z "$MSG" ] || [ "${#MSG}" -lt 3 ]; then
    echo "[DEBUG] AI 调用失败，使用默认信息"
    echo "chore: 调整脚本与优化代码"
else
    echo "$MSG"
fi