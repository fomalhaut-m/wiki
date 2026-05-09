# Luke's Wiki

> 个人知识库，基于 MkDocs + Material 主题构建的现代化静态文档网站。

[![GitHub Stars](https://img.shields.io/github/stars/fomalhaut-m/wike.svg?style=flat-square)](https://github.com/fomalhaut-m/wike)
[![GitHub Issues](https://img.shields.io/github/issues/fomalhaut-m/wike.svg?style=flat-square)](https://github.com/fomalhaut-m/wike/issues)
[![GitHub License](https://img.shields.io/github/license/fomalhaut-m/wike.svg?style=flat-square)](https://github.com/fomalhaut-m/wike/blob/main/LICENSE)
[![Deploy Status](https://img.shields.io/github/actions/workflow/status/fomalhaut-m/wike/deploy-aliyun-oss.yml?style=flat-square)](https://github.com/fomalhaut-m/wike/actions)

---

## 🌟 功能特性

| 功能 | 说明 |
|------|------|
| ✅ **自动更新日志** | 提交代码时自动生成智能更新日志 |
| ✅ **PDF 支持** | 支持 PDF 文档在线预览和下载 |
| ✅ **CI/CD 部署** | GitHub Actions 自动部署到阿里云 OSS |
| ✅ **AI 辅助** | 使用 Minimax AI 生成智能日志描述 |
| ✅ **响应式设计** | Material 主题，支持深色/浅色模式 |
| ✅ **全文搜索** | 内置搜索功能，支持中文分词 |

---

## 🛠️ 技术栈

| 分类 | 组件 | 版本 |
|------|------|------|
| **文档框架** | MkDocs | 1.6+ |
| **主题** | Material for MkDocs | 9.6+ |
| **部署** | 阿里云 OSS | - |
| **CI/CD** | GitHub Actions | - |
| **AI 服务** | Minimax API | - |

---

## 📁 项目结构

```
wike/                              # 项目根目录
├── .github/                       # GitHub 配置
│   └── workflows/                 # GitHub Actions 工作流
│       └── deploy-aliyun-oss.yml  # 阿里云 OSS 部署配置
├── .trae/                         # Trae IDE 配置
│   └── rules/                     # 项目规则
├── docs/                          # 文档源文件 (Markdown)
│   ├── 3D建模/                    # 3D建模相关
│   ├── 产品经理/                  # 产品经理知识体系
│   ├── 数据库/                    # 数据库知识
│   ├── 软件/                      # 软件技术文档
│   ├── 运维技术/                  # 运维技术
│   ├── 阅读/                      # 阅读笔记
│   ├── 项目管理/                  # 项目管理 (PMP/ACP)
│   └── log/                       # 自动更新日志
├── public/                        # 静态资源 (图片、PDF等)
├── scripts/                       # 构建和自动化脚本
│   └── push-with-log.sh           # 推送并更新日志脚本
├── site/                          # 生成的静态网站 (自动生成)
├── .gitconfig                     # Git 配置
├── .gitignore                     # Git 忽略配置
├── README.md                      # 项目说明文档
├── mkdocs.yml                     # MkDocs 核心配置文件
└── mkdocs.yml.md                  # MkDocs 配置指南
```

---

## 🚀 快速开始

### 前置条件

- Python 3.8+
- Git

### 安装步骤

```bash
# 1. 克隆仓库
git clone https://github.com/fomalhaut-m/wike.git
cd wike

# 2. 安装依赖
pip install mkdocs mkdocs-material

# 3. 启动开发服务器
mkdocs serve
```

### 常用命令

| 命令 | 说明 |
|------|------|
| `mkdocs serve` | 启动本地开发服务器 (http://localhost:8000) |
| `mkdocs build` | 构建静态站点到 site/ 目录 |
| `mkdocs gh-deploy` | 部署到 GitHub Pages |
| `bash scripts/push-with-log.sh` | 推送代码并自动更新日志 |

---

## 📚 内容分类

| 分类 | 说明 | 状态 |
|------|------|------|
| 3D建模 | Blender、AE 等3D建模相关 | 📖 |
| 产品经理 | 产品经理知识体系、学习路径 | 📖 |
| 数据库 | MySQL、Redis、Oracle、NoSQL | 📖 |
| 软件 | 编程语言、框架、工具 | 📖 |
| 运维技术 | Linux、Jenkins、ELK | 📖 |
| 阅读 | 读书笔记、随笔 | 📖 |
| 项目管理 | PMP、ACP 认证相关 | 📖 |

---

## 📝 自动更新日志

### 工作原理

项目使用 `scripts/push-with-log.sh` 脚本自动生成更新日志：

1. **检测变更**：检查工作目录和未推送提交
2. **AI 生成**：调用 Minimax API 生成智能描述
3. **更新日志**：写入 `docs/log/index.md`
4. **自动提交**：将日志变更提交并推送

### 日志格式

```log
2026-05-10 15:30: 新增用户登录功能文档
2026-05-10 14:20: 修复页面加载bug
2026-05-10 10:15: 更新文档内容
```

### 配置 AI API

```bash
# 设置 Minimax API Key
export MINIMAX_API_KEY=your_api_key_here

# 执行推送脚本
bash scripts/push-with-log.sh
```

---

## 🚢 部署流程

### GitHub Actions 自动部署

项目已配置自动部署工作流：

1. **触发条件**：推送到 `main` 分支或手动触发
2. **构建步骤**：使用 MkDocs 构建静态站点
3. **部署目标**：阿里云 OSS

### 配置 Secrets

在 GitHub 仓库设置中添加以下 Secrets：

| Secret 名称 | 说明 |
|-------------|------|
| `ALIYUN_ACCESS_KEY_ID` | 阿里云 Access Key ID |
| `ALIYUN_ACCESS_KEY_SECRET` | 阿里云 Access Key Secret |

---

## 📋 脚本说明

| 脚本路径 | 说明 | 参数 |
|----------|------|------|
| `scripts/push-with-log.sh` | 推送代码并自动更新日志 | 需要设置 MINIMAX_API_KEY 环境变量 |

---

## 🎣 Git Hooks

如需使用 Git Hooks，执行以下命令：

```bash
git config core.hooksPath .githooks
```

---

## 📊 统计信息

| 指标 | 数值 |
|------|------|
| 文档数量 | ~200+ |
| 代码行数 | ~50K+ |
| 提交次数 | ~500+ |

---

## 🔗 参考链接

| 资源 | 链接 |
|------|------|
| MkDocs 官网 | https://www.mkdocs.org/ |
| Material 主题 | https://squidfunk.github.io/mkdocs-material/ |
| MkDocs 中文文档 | https://mkdocs.pythonlang.cn/ |
| Minimax API | https://api.minimax.chat/ |
| 阿里云 OSS | https://www.aliyun.com/product/oss |

---

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

---

*Built with ❤️ using MkDocs & Material Theme*