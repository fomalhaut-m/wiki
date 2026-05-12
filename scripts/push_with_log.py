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

def banner(title, emoji="🚀"):
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
    banner("生成日志并 Push", "🚀")

    section("环境检查", "🔍")
    log_step("检查 git 环境...")
    if not run_cmd("git --version"):
        log_error("Git 命令不可用，请先安装 Git")
        sys.exit(1)
    log_success("Git 环境正常")

    log_step("检查未推送提交...")
    unpushed = run_cmd("git log --oneline origin/main..HEAD 2>/dev/null || git log --oneline origin/master..HEAD 2>/dev/null")

    if not unpushed:
        log_info("没有未推送的提交，直接退出")
        sys.exit(0)

    kv("未推送提交数", f"{len(unpushed.split(chr(10)))} 个")
    kv("提交预览", unpushed.split('\n')[0][:40] + "...")

    section("获取变更信息", "📊")
    diff_content = run_cmd("git log --stat origin/main..HEAD 2>/dev/null || git log --stat origin/master..HEAD 2>/dev/null")

    md_count = diff_content.count(".md") if diff_content else 0
    kv("变更文件数", f"{len(diff_content.split(chr(10))) if diff_content else 0} 行")
    kv("Markdown 文件", f"{md_count} 个" if md_count else "无")

    section("读取现有日志", "📝")
    log_file = "docs/log/index.md"
    today = datetime.datetime.now().strftime("%Y-%m-%d")
    kv("日志文件", log_file)
    kv("当前日期", today)

    existing_logs = ""
    if os.path.exists(log_file):
        try:
            with open(log_file, 'r', encoding='utf-8') as f:
                content = f.read()
                match = re.search(r'```log\n(.*?)\n```', content, re.DOTALL)
                if match:
                    existing_logs = match.group(1).strip()
                    kv("现有日志", f"{len(existing_logs)} 字符")
        except Exception as e:
            log_warn(f"读取日志文件失败: {e}")
    else:
        log_warn("日志文件不存在")

    section("构建 AI 请求", "🤖")
    default_entry = "更新文档"
    if ".md" in diff_content:
        default_entry = f"更新 {md_count} 篇文档"
        if "新增" in diff_content or "create" in diff_content.lower():
            default_entry = "新增文档内容"
        elif "整理" in diff_content or "分类" in diff_content:
            default_entry = "优化文档分类结构"
        elif "GetX" in diff_content or "flutter" in diff_content:
            default_entry = "更新 Flutter/GETX 教程"
        elif "脚本" in diff_content or "script" in diff_content.lower():
            default_entry = "优化自动化脚本"

    kv("默认描述", default_entry)

    user_prompt = f"""今天日期：{today}

现有日志内容：
{existing_logs}

本次 Git 变更内容：
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
- 动宾结构：动词+具体对象，如"重构 push-with-log.sh 脚本"
- 明确变更范围：具体模块/文件/功能名称
- 控制在50字以内

【输出限制】
- 必须只输出 log 代码块内部内容
- 不要输出任何解释、说明或额外文字
- 不要输出代码块标记```log```，只输出内部内容"""

    kv("User Prompt", f"{len(user_prompt)} 字符")
    kv("System Prompt", f"{len(system_prompt)} 字符")

    section("调用 AI 生成日志", "✨")
    log_step("开始调用 MiniMax API...")
    start_time = datetime.datetime.now()

    default_log_content = f"{today}:\n1. {default_entry}\n{existing_logs}"
    default_log_content = '\n'.join(default_log_content.split('\n')[:30])

    script_dir = os.path.dirname(os.path.abspath(__file__))
    sys.path.insert(0, script_dir)
    from call_minimax_api import call_api

    try:
        new_log_content = call_api(user_prompt, system_prompt)
        new_log_content = re.sub(r'<think>.*?', '', new_log_content, flags=re.DOTALL).strip()
        end_time = datetime.datetime.now()
        duration = (end_time - start_time).total_seconds()
        log_success(f"AI 调用成功")
        kv("耗时", f"{duration:.2f} 秒")
        kv("返回长度", f"{len(new_log_content)} 字符")

        if not new_log_content or len(new_log_content) < 10:
            log_warn("AI 返回内容无效，使用默认日志")
            new_log_content = default_log_content
    except Exception as e:
        log_error(f"AI 调用失败: {e}")
        new_log_content = default_log_content

    section("生成的日志内容", "📋")
    print("     ┌" + "─" * 44 + "┐")
    for line in new_log_content.split('\n')[:8]:
        print(f"     │ {line[:42]}")
    if len(new_log_content.split('\n')) > 8:
        print(f"     │ ... (共 {len(new_log_content.split(chr(10)))} 行)")
    print("     └" + "─" * 44 + "┘")

    section("写入日志文件", "💾")
    kv("文件路径", log_file)

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

    try:
        with open(log_file, 'w', encoding='utf-8') as f:
            f.write('\n'.join(lines))
        log_success("日志文件写入成功")
    except Exception as e:
        log_error(f"写入失败: {e}")

    section("提交并推送", "📦")
    log_step("提交日志变更...")
    run_cmd(f'git add "{log_file}"')
    result = run_cmd('git commit -m "chore: 更新日志" -q')
    if result:
        kv("提交结果", result)
    else:
        log_success("提交成功")

    log_step("推送到远程...")
    push_result = run_cmd("git push")
    if not push_result:
        push_result = run_cmd("git push origin main")
    if not push_result:
        push_result = run_cmd("git push origin master")

    if push_result and "error" in push_result.lower():
        log_error(f"推送失败: {push_result}")
    else:
        log_success("推送成功")

    banner("操作完成", "✅")
    print("")

if __name__ == "__main__":
    main()