#!/usr/bin/env python3
import subprocess
import sys
import os

def run_cmd(cmd, capture=True):
    if capture:
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True, encoding='utf-8', errors='replace')
        return result.stdout.strip() if result.stdout else ""
    else:
        subprocess.run(cmd, shell=True)
        return ""

def main():
    print("===== 生成 Git Commit 消息 =====")

    result = run_cmd("git --version")
    if not result:
        print("❌ Git命令不可用")
        sys.exit(1)

    run_cmd("git config core.quotepath off")

    changes = run_cmd("git diff --no-ext-diff --unified=1 | head -50")
    if not changes:
        changes = run_cmd("git status --short")

    print("变更内容：")
    print(changes)

    if not changes:
        print("无变更，退出")
        sys.exit(0)

    print("\n🤖 调用 AI 生成 commit...")

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

    script_dir = os.path.dirname(os.path.abspath(__file__))

    sys.path.insert(0, script_dir)
    from call_minimax_api import call_api
    commit_msg = call_api(user_prompt, system_prompt)

    if not commit_msg or len(commit_msg) < 5:
        print("⚠️  AI返回无效，使用默认消息")
        commit_msg = "docs: 更新项目文档"

    print(f"\n✅ 最终 commit：{commit_msg}")

    print("\n📝 执行 git add .")
    run_cmd("git add .")

    print("📝 执行 git commit")
    run_cmd(f'git commit -m "{commit_msg}"')

    print("===== 提交完成 =====")

if __name__ == "__main__":
    main()