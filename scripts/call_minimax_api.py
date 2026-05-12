#!/usr/bin/env python3
import sys
import os
import subprocess
import json
import re
import datetime

def call_api(user_prompt, system_prompt="生成git commit，只返回结果，格式：feat: xxx", verbose=False):
    if verbose:
        print(f"     📌 API 请求参数:")
        print(f"        User Prompt: {len(user_prompt)} 字符")
        print(f"        System Prompt: {len(system_prompt)} 字符")

    api_key = os.environ.get("MINIMAX_API_KEY")
    if not api_key:
        print("     ❌ 错误: 未设置 MINIMAX_API_KEY 环境变量")
        sys.exit(1)

    if verbose:
        print(f"        API Key: {api_key[:8]}... (已设置)")

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

    if verbose:
        print(f"        URL: https://api.minimaxi.com/v1/chat/completions")

    try:
        start_time = datetime.datetime.now()
        result = subprocess.run(curl_cmd, capture_output=True, text=True, encoding='utf-8', errors='replace', timeout=30)
        end_time = datetime.datetime.now()
        duration = (end_time - start_time).total_seconds()

        raw = result.stdout.strip() if result.stdout else ""

        if verbose:
            print(f"     📊 响应长度: {len(raw)} 字符")
            print(f"     ⏱️  API 耗时: {duration:.2f} 秒")

        if not raw:
            print("     ❌ 错误: API 返回为空")
            sys.exit(1)

        try:
            data = json.loads(raw)
        except json.JSONDecodeError as e:
            print(f"     ❌ JSON 解析失败: {e}")
            if verbose:
                print(f"     📄 原始响应 (前500字符): {raw[:500]}")
            sys.exit(1)

        if "error" in data:
            print(f"     ❌ API 错误: {data['error']}")
            sys.exit(1)

        choices = data.get("choices", [])
        if not choices:
            print("     ❌ 错误: choices 为空")
            if verbose:
                print(f"     📄 完整响应: {data}")
            sys.exit(1)

        message = choices[0].get("message", {})
        content = message.get("content", "")

        if not content:
            print("     ❌ 错误: content 为空")
            if verbose:
                print(f"     📄 choices[0]: {choices[0]}")
            sys.exit(1)

        original_length = len(content)
        content = re.sub(r'<think>.*?', '', content, flags=re.DOTALL).strip()

        if verbose:
            print(f"     📝 清理后长度: {len(content)} 字符 (原: {original_length} 字符)")

        return content

    except subprocess.TimeoutExpired:
        print("     ❌ 错误: API 请求超时 (30秒)")
        sys.exit(1)
    except Exception as e:
        print(f"     ❌ 错误: {e}")
        sys.exit(1)

def main():
    verbose = "-v" in sys.argv or "--verbose" in sys.argv

    if len(sys.argv) < 2:
        print("用法: python call_minimax_api.py <用户提示词> [系统提示词] [-v]")
        sys.exit(1)

    user_prompt = sys.argv[1] if len(sys.argv) > 1 else ""
    system_prompt = sys.argv[2] if len(sys.argv) > 2 else "生成git commit，只返回结果，格式：feat: xxx"

    result = call_api(user_prompt, system_prompt, verbose=verbose)
    print(result)

if __name__ == "__main__":
    main()