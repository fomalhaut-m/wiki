#!/usr/bin/env python3
import subprocess
import sys
import os
import datetime
import re

def run_cmd(cmd, capture=True):
    if capture:
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True, encoding='utf-8', errors='replace')
        return result.stdout.strip() if result.stdout else ""
    else:
        subprocess.run(cmd, shell=True)
        return ""

def main():
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("   🚀 生成日志并Push")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

    if not run_cmd("git --version"):
        print("❌ Git命令不可用，请先安装Git")
        sys.exit(1)

    print("🔍 检查未推送提交...")
    unpushed = run_cmd("git log --oneline origin/main..HEAD 2>/dev/null || git log --oneline origin/master..HEAD 2>/dev/null")

    if not unpushed:
        print("ℹ️ 没有未推送的提交，直接退出")
        sys.exit(0)

    print("✅ 发现未推送的提交：")
    for line in unpushed.split('\n'):
        if line.strip():
            print(f"   {line}")

    print("\n🤖 生成更新日志...")

    log_file = "docs/log/index.md"
    today = datetime.datetime.now().strftime("%Y-%m-%d")

    existing_logs = ""
    if os.path.exists(log_file):
        try:
            with open(log_file, 'r', encoding='utf-8') as f:
                content = f.read()
                match = re.search(r'```log\n(.*?)\n```', content, re.DOTALL)
                if match:
                    existing_logs = match.group(1).strip()
        except:
            existing_logs = ""

    diff_content = run_cmd("git log --stat origin/main..HEAD 2>/dev/null || git log --stat origin/master..HEAD 2>/dev/null")

    default_entry = "更新文档"
    if ".md" in diff_content:
        doc_count = diff_content.count(".md")
        default_entry = f"更新{doc_count}篇文档"
        if "新增" in diff_content or "create" in diff_content.lower():
            default_entry = "新增文档内容"
        elif "整理" in diff_content or "分类" in diff_content or "重构" in diff_content:
            default_entry = "优化文档分类结构"
        elif "GetX" in diff_content or "getx" in diff_content or "flutter" in diff_content:
            default_entry = "更新Flutter/GETX教程"
        elif "脚本" in diff_content or "script" in diff_content.lower():
            default_entry = "优化自动化脚本"
    else:
        default_entry = "优化代码功能"

    default_log_content = f"{today}:\n1. {default_entry}\n{existing_logs}"
    default_log_content = '\n'.join(default_log_content.split('\n')[:30])

    user_prompt = f"""今天日期：{today}

现有日志内容：
{existing_logs}

本次Git变更内容：
{diff_content}

请生成完整的新日志内容，合并当天的所有变更，保持固定格式。"""

    system_prompt = """你是专业的项目变更日志生成助手。

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
- 必须使用中文
- 动宾结构：动词+具体对象，如"重构push-with-log.sh脚本"
- 明确变更范围：具体模块/文件/功能名称
- 控制在50字以内

【输出限制】
- 必须只输出log代码块内部内容
- 不要输出任何解释、说明或额外文字
- 不要输出代码块标记```log```，只输出内部内容"""

    script_dir = os.path.dirname(os.path.abspath(__file__))
    sys.path.insert(0, script_dir)
    from call_minimax_api import call_api

    try:
        new_log_content = call_api(user_prompt, system_prompt)
        if not new_log_content or len(new_log_content) < 10:
            print("⚠️  AI返回内容无效，使用默认日志内容")
            new_log_content = default_log_content
    except Exception as e:
        print(f"⚠️  API调用失败，使用默认日志内容: {e}")
        new_log_content = default_log_content

    print("✅ 生成的日志内容：")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    for line in new_log_content.split('\n'):
        print(f"  {line}")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

    print("🔧 写入日志文件...")

    new_log_content = re.sub(r'<think>.*?', '', new_log_content, flags=re.DOTALL).strip()

    lines = [
        "# 更新日志",
        "",
        "这里记录项目的主要更新和变更。",
        "",
        "```log",
        new_log_content,
        "```",
        "",
        "---",
        "",
        "更多历史记录请查看 [Git 提交历史](https://github.com/fomalhaut-m/wike/commits/main)"
    ]

    with open(log_file, 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines))

    print("🔧 提交日志变更...")
    run_cmd(f'git add "{log_file}"')
    run_cmd('git commit -m "chore: 更新日志" -q')

    print("\n🚀 执行Push...")
    run_cmd("git push") or run_cmd("git push origin main") or run_cmd("git push origin master")

    print("✅ Push完成！")
    print("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print("   ✅ 操作完成！")
    print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

if __name__ == "__main__":
    main()