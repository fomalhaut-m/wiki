# Luke's Wiki

个人知识库，基于 MkDocs + Material 主题构建的静态文档网站。

## 🌟 功能特性

- ✅ **自动更新日志** - 提交代码时自动生成更新日志
- ✅ **PDF 支持** - 支持 PDF 文档在线预览和下载
- ✅ **CI/CD 部署** - GitHub Actions 自动部署到阿里云 OSS
- ✅ **Git Hooks** - 自动化工作流，提升开发效率

## 🛠️ 技术栈

| 组件 | 说明 |
|------|------|
| **文档框架** | MkDocs |
| **主题** | Material for MkDocs |
| **部署** | 阿里云 OSS |
| **CI/CD** | GitHub Actions |

## 📁 目录结构

```
wike/
├── docs/               # 文档源文件 (Markdown)
│   ├── 3D建模/         # 3D建模相关
│   ├── 产品经理/       # 产品经理知识体系
│   ├── 数据库/         # 数据库知识
│   ├── 软件/           # 软件技术文档
│   ├── 运维技术/       # 运维技术
│   ├── 阅读/           # 阅读笔记
│   ├── 项目管理/       # 项目管理 (PMP/ACP)
│   └── log/            # 自动更新日志
├── public/             # 静态资源 (图片、PDF等)
├── scripts/            # 构建和自动化脚本
├── site/               # 生成的静态网站
├── .githooks/          # Git Hooks 配置
└── mkdocs.yml          # MkDocs 配置文件
```

## 🚀 快速开始

### 1. 克隆仓库

```bash
# 克隆仓库
git clone https://github.com/fomalhaut-m/wiki.git
```

### 2. 安装依赖

```bash
pip install mkdocs 
```

### 3. 本地开发

```bash
# 启动开发服务器（默认 http://localhost:8000）
mkdocs serve
```

### 4. 构建静态站点

```bash
# 构建并输出到 site 目录
mkdocs build
```

## 📚 内容分类

| 分类 | 说明 |
|------|------|
| 3D建模 | Blender、AE 等3D建模相关 |
| 产品经理 | 产品经理知识体系、学习路径 |
| 数据库 | MySQL、Redis、Oracle、NoSQL |
| 软件 | 编程语言、框架、工具 |
| 运维技术 | Linux、Jenkins、ELK |
| 阅读 | 读书笔记、随笔 |
| 项目管理 | PMP、ACP 认证相关 |
| 我的 | 个人简历、职业规划 |

## 📝 自动更新日志

项目使用 push-with-log.sh 自动生成更新日志：

- **触发时机**: 每次 `git push` 时自动运行
- **生成位置**: `docs/log/index.md`
- **日志格式**: 时间戳 + AI 生成的变更描述

**日志示例:**

```log
2026-05-10 15:30: 新增用户登录功能文档
2026-05-10 14:20: 修复页面加载bug
2026-05-10 10:15: 更新文档内容
```

**工作流程:**

```
push-with-log.sh → 更新日志 → git push
```

## 📤 推送脚本

使用脚本一键推送并自动更新日志：

```bash
# 设置 API Key（用于 AI 生成日志）
export MINIMAX_API_KEY=${your_api$_key}

# 执行推送
bash scripts/push-with-log.sh
```

## 🚢 部署

项目通过 GitHub Actions 自动部署到阿里云 OSS。配置文件：`.github/workflows/deploy-aliyun-oss.yml`

## 🔗 参考链接

| 资源 | 链接 |
|------|------|
| MkDocs 官网 | https://www.mkdocs.org/ |
| Material 主题 | https://squidfunk.github.io/mkdocs-material/ |
| MkDocs 中文文档 | https://mkdocs.pythonlang.cn/ |
| PDF 插件 | https://pypi.org/project/mkdocs-pdf/ |
