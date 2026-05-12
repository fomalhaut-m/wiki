#!/usr/bin/env python3
import subprocess
import sys
import os
import datetime

def run_cmd(cmd, capture=True):
    if capture:
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True, encoding='utf-8', errors='replace')
        return result.stdout.strip() if result.stdout else ""
    else:
        subprocess.run(cmd, shell=True)
        return ""

def banner(title, emoji="📝"):
    width = 52
    print("")
    print("┌" + "─" * width + "┐")
    print("│" + f" {emoji} {title}".center(width) + "│")
    print("└" + "─" * width + "┘")

def section(title, emoji="▶"):
    print("")
    print(f"  {emoji} {title}")
    print("  " + "─" * 48)

def log_success(msg):
    print(f"     ✅ {msg}")

def log_error(msg):
    print(f"     ❌ {msg}")

def log_info(msg):
    print(f"     🔄 {msg}")

def log_warn(msg):
    print(f"     ⚠️  {msg}")

def log_step(msg):
    print(f"     📌 {msg}")

def kv(key, value):
    print(f"     {key:<16}: {value}")

def code_block(content, max_lines=8):
    lines = content.split('\n')
    for i, line in enumerate(lines):
        if i >= max_lines:
            print(f"     │ ... (还有 {len(lines) - max_lines} 行)")
            break
        print(f"     │ {line[:76]}")

def main():
    banner("Git Commit 消息生成工具", "📝")

    section("环境检查", "🔍")
    log_step("检查 git 环境...")
    result = run_cmd("git --version")
    if not result:
        log_error("Git 命令不可用")
        sys.exit(1)
    kv("Git 版本", result)

    log_step("获取 git 变更...")
    run_cmd("git config core.quotepath off")

    changes = run_cmd("git diff --no-ext-diff --unified=1 | head -50")
    if not changes:
        changes = run_cmd("git status --short")
        log_info("无 diff，使用 git status")

    kv("变更长度", f"{len(changes)} 字符")
    kv("变更行数", f"{len(changes.split(chr(10)))} 行")

    section("变更预览", "📄")
    code_block(changes, max_lines=10)

    if not changes:
        log_warn("无变更，退出")
        print("")
        sys.exit(0)

    section("AI 请求参数", "🤖")
    user_prompt = f"""请根据以下代码变更生成一个简洁的 Git commit 消息。

变更内容：
{changes}

要求：
1. 必须使用中文
2. 格式：类型: 简短描述
3. 类型可选：feat(新功能)、fix(修复)、docs(文档)、style(格式)、refactor(重构)、perf(性能)、test(测试)、chore(杂项)
4. 描述控制在 50 字以内
5. 只输出 commit 消息，不要任何解释"""

    system_prompt = """你是 Git commit 消息生成助手。

【输出格式】
只输出一行 commit 消息，格式：类型: 简短描述

【类型说明】
- feat: 新功能
- fix: 修复问题
- docs: 文档更新
- style: 代码格式（不影响功能）
- refactor: 重构（不是修复也不是新功能）
- perf: 性能优化
- test: 测试相关
- chore: 杂项（构建、工具、配置）

【要求】
- 必须使用中文
- 简短明确
- 只输出 commit 消息，不要引号或任何额外内容"""

    kv("User Prompt", f"{len(user_prompt)} 字符")
    kv("System Prompt", f"{len(system_prompt)} 字符")

    section("AI 调用", "🚀")
    log_step("开始调用 MiniMax API...")
    start_time = datetime.datetime.now()

    script_dir = os.path.dirname(os.path.abspath(__file__))
    sys.path.insert(0, script_dir)
    from call_minimax_api import call_api

    try:
        commit_msg = call_api(user_prompt, system_prompt)
        end_time = datetime.datetime.now()
        duration = (end_time - start_time).total_seconds()
        log_success(f"AI 调用成功")
        kv("耗时", f"{duration:.2f} 秒")
        kv("返回长度", f"{len(commit_msg)} 字符")
    except Exception as e:
        log_error(f"AI 调用失败: {e}")
        commit_msg = None

    if not commit_msg or len(commit_msg) < 5:
        log_warn("AI 返回无效，使用默认消息")
        commit_msg = "docs: 更新项目文档"

    section("生成结果", "✅")
    kv("Commit 消息", commit_msg)

    section("执行提交", "📦")
    log_step("执行 git add .")
    run_cmd("git add .")

    log_step("执行 git commit")
    result = run_cmd(f'git commit -m "{commit_msg}"')
    if result:
        kv("提交结果", result)
    else:
        log_success("提交成功")

    banner("操作完成", "✅")
    print("")

if __name__ == "__main__":
    main()