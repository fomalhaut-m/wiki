# 更新日志

这里记录项目的主要更新和变更。

```log
用户要求我根据今天（2026-05-13）的 Git commit 变更生成变更日志。让我分析这些 commits 的内容：

1. commit b82173cb71b9d1fc9dbd0722eff75219b3676ffe
   - scripts/call_minimax_api.py: 65行变更，45插入，20删除
   - 描述说"主要做了两件事"

2. commit 1068beb7ed768cec7906edd9bfb609e2ac958747
   - scripts/push_with_log.py: 179行变更，66插入，113删除
   - 重构

3. commit 19f58458d3609b65d76900563110cd98723d34ca
   - scripts/git-commit.py: 129行变更，55插入，74删除
   - 重构

4. commit 7076cf65efd89d50943c59e0f273ea7a64d2f428
   - scripts/call_minimax_api.py: 70行变更
   - 添加 verbose 参数功能
   - scripts/git-commit.py: 100行变更
   - scripts/push-with-log.sh: 141行删除
   - scripts/push_with_log.py: 171行变更
   - 总共 4 files changed, 264 insertions(+), 218 deletions(-)

5. commit 7e29814f12ba5fffa46a9811a54c458512e2c958
   - scripts/call_minimax_api.py: 3行添加
   - scripts/git-commit.sh: 77行删除
   - scripts/push_with_log.py: 177行新增
   - 3 files changed, 180 insertions(+), 77 deletions(-)

我注意到还有额外的文件变更信息。这些额外的 commits 似乎涉及到文档和脚本的重构。核心变更主要集中在脚本文件的优化和重构上，主要涉及 Minimax API 调用和 Git 相关脚本。

我将按照日期和变更类型对这些变更进行分类和总结。
</think>

```log
2026-05-13:
1. 🔧 重构call_minimax_api.py脚本，增强API调用功能并添加verbose参数支持
2. 🔧 重构push_with_log.py脚本，精简代码逻辑并优化日志推送流程
3. 🔧 重构git-commit.py脚本，改进Git提交自动化逻辑
4. 🔧 将push-with-log.sh脚本迁移为Python实现（push_with_log.py）
5. 🔧 清理废弃的shell脚本（git-commit.sh、call-minimax-api.sh、changelog-prompt.md）
6. 📝 更新JavaAgent文档，添加核心概念与Premain模式开发指南
7. 📝 更新APM概述文档，完善软件应用性能管理内容
8. 📝 清理过时的日志索引文档（docs/log/index.md）
9. 🗑️ 删除零散废弃的脚本文件并整理scripts目录结构
```
```

---

更多历史记录请查看 [Git 提交历史](https://github.com/fomalhaut-m/rex-wiki/commits/main)