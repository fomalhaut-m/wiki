#!/usr/bin/env python3
import sys
import os
import subprocess
import json

def call_api(user_prompt, system_prompt="生成git commit，只返回结果，格式：feat: xxx"):
    api_key = os.environ.get("MINIMAX_API_KEY")
    if not api_key:
        print("错误: 未设置 MINIMAX_API_KEY 环境变量", file=sys.stderr)
        sys.exit(1)

    payload = {
        "model": "MiniMax-M2.7",
        "messages": [
            {"role": "system", "name": "MiniMax AI", "content": system_prompt},
            {"role": "user", "name": "用户", "content": user_prompt}
        ]
    }

    curl_cmd = [
        "curl", "-s", "--connect-timeout", "10",
        "-X", "POST",
        "-H", "Content-Type: application/json",
        "-H", f"Authorization: Bearer {api_key}",
        "-d", json.dumps(payload),
        "https://api.minimaxi.com/v1/chat/completions"
    ]

    try:
        result = subprocess.run(curl_cmd, capture_output=True, text=True, encoding='utf-8', errors='replace', timeout=30)
        raw = result.stdout.strip() if result.stdout else ""

        if not raw:
            print("错误: API 返回为空", file=sys.stderr)
            sys.exit(1)

        data = json.loads(raw)
        choices = data.get("choices", [])
        if not choices:
            print("错误: choices 为空", file=sys.stderr)
            sys.exit(1)

        content = choices[0].get("message", {}).get("content", "")
        if not content:
            print("错误: content 为空", file=sys.stderr)
            sys.exit(1)

        return content

    except subprocess.TimeoutExpired:
        print("错误: API 请求超时", file=sys.stderr)
        sys.exit(1)
    except json.JSONDecodeError as e:
        print(f"错误: JSON 解析失败 - {e}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"错误: {e}", file=sys.stderr)
        sys.exit(1)

def main():
    if len(sys.argv) < 2:
        print("用法: python call_minimax_api.py <用户提示词> [系统提示词]", file=sys.stderr)
        sys.exit(1)

    user_prompt = sys.argv[1]
    system_prompt = sys.argv[2] if len(sys.argv) > 2 else "生成git commit，只返回结果，格式：feat: xxx"

    result = call_api(user_prompt, system_prompt)
    print(result)

if __name__ == "__main__":
    main()