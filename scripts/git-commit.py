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

def p(msg=""):
    print(f"  {msg}")

def sec(title):
    print(f"\n  ◆ {title}")

def done(msg):
    print(f"  ✓ {msg}")

def fail(msg):
    print(f"  ✗ {msg}")

def info(msg):
    print(f"  → {msg}")

def k(key, val):
    print(f"    {key:<12} {val}")

def main():
    print("")
    print("  ╭───────────────────────────────────────────╮")
    print("  │           Git Commit 消息生成工具         │")
    print("  ╰───────────────────────────────────────────╯")

    sec("环境检查")
    info("检查 git 环境...")
    result = run_cmd("git --version")
    if not result:
        fail("Git 命令不可用")
        sys.exit(1)
    k("版本", result)

    info("获取 git 变更...")
    run_cmd("git config core.quotepath off")

    changes = run_cmd("git diff --no-ext-diff --unified=1 | head -50")
    if not changes:
        changes = run_cmd("git status --short")
        info("无 diff，使用 git status")

    k("长度", f"{len(changes)} 字符")
    k("行数", f"{len(changes.split(chr(10)))} 行")

    sec("变更预览")
    for i, l in enumerate(changes.split('\n')[:8]):
        print(f"    {l[:70]}")
    if len(changes.split('\n')) > 8:
        print(f"    ... 共 {len(changes.split(chr(10)))} 行")

    if not changes:
        info("无变更，退出")
        print("")
        sys.exit(0)

    sec("AI 调用")
    info("开始调用 MiniMax API...")
    start_time = datetime.datetime.now()

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

只输出一行 commit 消息，格式：类型: 简短描述

类型说明：
- feat: 新功能
- fix: 修复问题
- docs: 文档更新
- style: 代码格式
- refactor: 重构
- perf: 性能优化
- test: 测试相关
- chore: 杂项（构建、工具、配置）

必须使用中文，简短明确，不要引号或额外内容"""

    k("Prompt", f"{len(user_prompt)} 字符")

    script_dir = os.path.dirname(os.path.abspath(__file__))
    sys.path.insert(0, script_dir)
    from call_minimax_api import call_api

    try:
        commit_msg = call_api(user_prompt, system_prompt)
        duration = (datetime.datetime.now() - start_time).total_seconds()
        done(f"AI 调用成功 ({duration:.1f}s)")
        k("长度", f"{len(commit_msg)} 字符")
    except Exception as e:
        fail(f"AI 调用失败: {e}")
        commit_msg = None

    if not commit_msg or len(commit_msg) < 5:
        info("AI 返回无效，使用默认消息")
        commit_msg = "docs: 更新项目文档"

    sec("生成结果")
    print(f"\n    {commit_msg}")

    sec("执行提交")
    info("git add .")
    run_cmd("git add .")

    info("git commit")
    result = run_cmd(f'git commit -m "{commit_msg}"')
    if result:
        k("结果", result)
    else:
        done("提交成功")

    print("")
    print("  ╭───────────────────────────────────────────╮")
    print("  │                    ✓ 完成                  │")
    print("  ╰───────────────────────────────────────────╯")
    print("")

if __name__ == "__main__":
    main()