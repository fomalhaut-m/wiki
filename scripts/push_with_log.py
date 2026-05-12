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

def get_unpushed():
    result = run_cmd("git log origin/main..HEAD --oneline")
    if result:
        return result
    return run_cmd("git log origin/master..HEAD --oneline")

def get_diff():
    result = run_cmd("git log origin/main..HEAD --stat")
    if result:
        return result
    return run_cmd("git log origin/master..HEAD --stat")

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
    print("  │            生成日志并 Push                 │")
    print("  ╰───────────────────────────────────────────╯")

    sec("环境检查")
    info("检查 git 环境...")
    if not run_cmd("git --version"):
        fail("Git 命令不可用")
        sys.exit(1)
    done("Git 环境正常")

    info("检查未推送提交...")
    unpushed = get_unpushed()

    if not unpushed:
        info("没有未推送的提交，退出")
        sys.exit(0)

    commit_count = len([l for l in unpushed.split('\n') if l.strip()])
    k("提交数", f"{commit_count} 个")

    sec("获取变更")
    diff_content = get_diff()
    md_count = diff_content.count(".md") if diff_content else 0
    k("文件数", f"{len(diff_content.split(chr(10)))} 行" if diff_content else "0 行")
    k("MD文件", f"{md_count} 个" if md_count else "无")

    sec("读取日志")
    log_file = "docs/log/index.md"
    today = datetime.datetime.now().strftime("%Y-%m-%d")
    k("文件", log_file)
    k("日期", today)

    existing_logs = ""
    if os.path.exists(log_file):
        try:
            with open(log_file, 'r', encoding='utf-8') as f:
                content = f.read()
                match = re.search(r'```log\n(.*?)\n```', content, re.DOTALL)
                if match:
                    existing_logs = match.group(1).strip()
                    k("现有日志", f"{len(existing_logs)} 字符")
        except:
            pass
    else:
        info("日志文件不存在")

    sec("构建请求")
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

    k("默认描述", default_entry)

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
```

【关键规则】
1. 日期格式：YYYY-MM-DD，如 2026-05-12
2. 同一天的所有变更必须合并到同一个日期条目下
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

【内容要求】
- 必须使用中文
- 动宾结构：动词+具体对象
- 控制在50字以内
- 只输出 log 代码块内部内容"""

    k("Prompt", f"{len(user_prompt)} 字符")

    sec("AI 生成")
    info("调用 MiniMax API...")
    start_time = datetime.datetime.now()

    default_log_content = f"{today}:\n1. {default_entry}\n{existing_logs}"
    default_log_content = '\n'.join(default_log_content.split('\n')[:30])

    script_dir = os.path.dirname(os.path.abspath(__file__))
    sys.path.insert(0, script_dir)
    from call_minimax_api import call_api

    try:
        new_log_content = call_api(user_prompt, system_prompt)
        new_log_content = re.sub(r'<think>.*?', '', new_log_content, flags=re.DOTALL).strip()
        duration = (datetime.datetime.now() - start_time).total_seconds()
        done(f"AI 调用成功 ({duration:.1f}s)")
        k("长度", f"{len(new_log_content)} 字符")

        if not new_log_content or len(new_log_content) < 10:
            info("AI 返回无效，使用默认日志")
            new_log_content = default_log_content
    except Exception as e:
        fail(f"AI 调用失败: {e}")
        new_log_content = default_log_content

    sec("日志预览")
    for i, l in enumerate(new_log_content.split('\n')[:6]):
        print(f"    {l[:46]}")
    if len(new_log_content.split('\n')) > 6:
        print(f"    ... 共 {len(new_log_content.split(chr(10)))} 行")

    sec("写入文件")
    k("路径", log_file)
    lines = [
        "# 更新日志", "", "这里记录项目的主要更新和变更。", "",
        "```log", new_log_content, "```", "",
        "---", "",
        "更多历史记录请查看 [Git 提交历史](https://github.com/fomalhaut-m/rex-wiki/commits/main)"
    ]
    try:
        with open(log_file, 'w', encoding='utf-8') as f:
            f.write('\n'.join(lines))
        done("写入成功")
    except Exception as e:
        fail(f"写入失败: {e}")

    sec("提交推送")
    info("git add / commit...")
    run_cmd(f'git add "{log_file}"')
    run_cmd('git commit -m "chore: 更新日志" -q')

    info("git push...")
    push_result = run_cmd("git push")
    if not push_result:
        push_result = run_cmd("git push origin main")
    if not push_result:
        push_result = run_cmd("git push origin master")

    if push_result and "error" in push_result.lower():
        fail(f"推送失败: {push_result}")
    else:
        done("推送成功")

    print("")
    print("  ╭───────────────────────────────────────────╮")
    print("  │                    ✓ 完成                  │")
    print("  ╰───────────────────────────────────────────╯")
    print("")

if __name__ == "__main__":
    main()