# Wiki 文档中心

基于 MkDocs 构建的个人知识库，部署于阿里云 OSS。

## 本地开发

### 1. 安装依赖

确保已安装 Python 3.11+：

```bash
pip install mkdocs mkdocs-material
```

### 2. 本地预览

启动本地开发服务器：

```bash
mkdocs serve --config-file mkdocs.yml
```

服务启动后，访问 http://localhost:8000 查看文档。

### 3. 构建静态站点

```bash
mkdocs build --config-file mkdocs.yml --site-dir site
```

生成的静态文件位于 `site/` 目录。

## 文档结构

```
docs/
├── AI/                      # AI 相关
├── 产品经理/                # 产品经理相关
├── 生活与成长/              # 人生感悟
├── 软件开发/                # 技术文档
│   ├── Java/
│   ├── 前端/
│   ├── 数据库/
│   ├── 架构设计/
│   ├── 框架/
│   └── 运维与工具/
└── index.md                 # 首页
```

## 添加新文档

1. 在 `docs/` 目录下创建对应的 `.md` 文件
2. 在 `mkdocs.yml` 的 `nav` 部分添加导航配置
3. 本地预览确认无误后提交代码

## 部署

推送代码到 `main` 分支后，GitHub Actions 自动构建并部署到阿里云 OSS。
