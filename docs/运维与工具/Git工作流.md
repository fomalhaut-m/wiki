# Git 工作流

> 来源：团队Git规范 | 标签：开发工具 / Git

---

## GitFlow 分支模型

```
master     ────●──────────────────────────── (正式版本)
                \
develop    ────●───●───●───●───●───●─────── (开发分支)
                \     \     \
feature    ──────●───●   └───●───●─────────── (功能分支)
                  \         \
release    ─────────────────●─────────────── (发布分支)
                              \
hotfix     ──────────────────────●─────────── (热修复分支)
```

---

## 分支说明

| 分支 | 说明 |
|------|------|
| **master** | 主分支，正式发布版本 |
| **develop** | 开发分支，集成本切新功能 |
| **feature** | 功能分支，从develop拉取 |
| **release** | 发布分支，准备发布版本 |
| **hotfix** | 热修复分支，从master拉取 |

---

## 规范注意

1. **及时推送本地代码**
2. **及时拉取最新代码**（建议一天一次）
3. **从master同步代码**，保证本地最新
4. `git flow finish` 后手动推送：
   - `git push --all`
   - `git push --tag`
5. 同一时刻只能有一个 `release` / `hotfix`
6. 版本号在整个项目生命周期不能重复
7. `finish` 在 IDEA console 中用 `Ctrl+C` 无法退出vi，用系统控制台

---

## 常用命令

```bash
# 初始化
git flow init

# 开始新功能
git flow feature start my-feature

# 完成功能
git flow feature finish my-feature

# 开始发布
git flow release start v1.0.0

# 完成发布
git flow release finish v1.0.0

# 开始热修复
git flow hotfix start hotfix-branch

# 完成热修复
git flow hotfix finish hotfix-branch
```
