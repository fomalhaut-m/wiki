# Luke's Wiki

个人知识库，基于 MkDocs + Material 主题构建。

## 技术栈

- **文档框架**: MkDocs
- **主题**: Material for MkDocs
- **部署**: 阿里云 OSS

## 目录结构

```
wiki/
├── docs/               # 文档源文件 (Markdown)
│   ├── 3D建模/         # 3D建模相关
│   ├── 产品经理/       # 产品经理相关
│   ├── 数据库/         # 数据库知识
│   ├── 软件/           # 软件技术文档
│   ├── 运维技术/       # 运维技术
│   ├── 阅读/           # 阅读笔记
│   ├── 项目管理/       # 项目管理
│   └── 我的/           # 个人内容
├── site/               # 生成的静态网站
├── public/             # 公共资源
├── scripts/            # 构建脚本
└── mkdocs.yml          # MkDocs 配置
```

## 快速开始

### 克隆并初始化

```bash
# 克隆仓库并自动配置 Git Hooks
git clone https://github.com/fomalhaut-m/wike.git && cd wike && git config core.hooksPath .githooks

# 或使用初始化脚本
git clone https://github.com/fomalhaut-m/wike.git
cd wike
bash scripts/init.sh
```

### 安装依赖

```bash
pip install mkdocs
```

### 本地开发

```bash
# 启动开发服务器
mkdocs serve

# 或使用 PowerShell 脚本
.\scripts\serve.ps1
```

### 构建静态站点

```bash
# 构建并输出到 site 目录
mkdocs build

# 或使用脚本
.\scripts\build.ps1
```

## 内容分类

| 分类 | 说明 |
|------|------|
| 3D建模 | Blender、AE 等3D建模相关 |
| 产品经理 | 产品经理知识体系、学习路径 |
| 数据库 | MySQL、Redis、Oracle、NoSQL 等 |
| 软件 | 编程语言、框架、工具等 |
| 运维技术 | Linux、Jenkins、ELK 等 |
| 阅读 | 读书笔记、随笔等 |
| 项目管理 | PMP、ACP 认证相关 |
| 我的 | 个人简历、职业规划等 |

## 自动更新日志

项目使用 Git Hooks 自动生成更新日志：

- **触发时机**: 每次 `git commit` 时自动运行
- **生成位置**: `docs/log/index.md`
- **自动提交**: 更新的日志会在 `git push` 时自动提交

**工作流程:**

```
git commit → post-commit 钩子更新日志 → git add 暂存
        ↓
git push → 自动提交更新日志 → push 到远程
```

**生成格式:**

```markdown
## 2026-05-10

### 功能更新

- 新增用户登录功能
- 修复页面加载bug
- 更新文档内容

---

## 历史记录

更多历史记录请查看 [Git 提交历史](https://github.com/fomalhaut-m/wike/commits/main)
```

## 部署

项目通过 GitHub Actions 自动部署到阿里云 OSS。配置见 `.github/workflows/deploy-aliyun-oss.yml`。

## License

MIT


# 访问地址 mkdocs 官网

https://squidfunk.github.io/mkdocs-material/

# 主题配置
https://mkdocs.pythonlang.cn/dev-guide/themes/

# 个人博客主题
https://github.com/FernandoCelmer/mkdocs-simple-blog

# 主题配置
https://github.com/mkdocs/catalog#-theming

# 插件配置 - PDF生成
https://github.com/orzih/mkdocs-with-pdf

# 插件配置 - pdf预览
https://pypi.org/project/mkdocs-pdf/
