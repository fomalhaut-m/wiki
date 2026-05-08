# 📖 Luke's Wiki

> 个人知识沉淀与技术笔记 | Java后端 | 微服务 | 架构设计

---

## 📁 项目结构

```
wike/
├── docs/                      # 文档目录 (Markdown)
│   ├── .vitepress/            # VitePress 配置
│   ├── AI/                    # AI 相关
│   ├── 软件开发/              # 软件开发相关
│   │   ├── Java/              # Java
│   │   ├── 数据库/             # 数据库
│   │   ├── 前端/              # 前端
│   │   ├── 框架/              # 框架
│   │   └── 架构设计/           # 架构设计
│   ├── 项目管理/              # 项目管理
│   ├── 产品经理/              # 产品经理
│   └── 运维与工具/             # 运维与工具
├── scripts/                   # 构建脚本
│   ├── build.sh               # Linux/macOS 构建脚本
│   └── build.ps1              # Windows 构建脚本
├── .github/workflows/         # GitHub Actions
├── package.json               # Node.js 依赖
└── README.md
```

---

## 🚀 快速开始

### 本地开发

```bash
# 安装依赖
npm install

# 本地预览
npm run dev

# 构建静态站点
npm run build
```

### 使用构建脚本

```bash
# Linux/macOS
chmod +x scripts/build.sh
./scripts/build.sh

# Windows PowerShell
.\scripts\build.ps1
```

---

## 📊 统计

| 指标 | 数量 |
|------|------|
| 文章总数 | **70+ 篇** |
| 分类 | 9 大模块 |

---

## 🚀 快速导航

### AI
- [大模型基础](docs/AI/大模型基础.md)
- [AI-Agent入门](docs/AI/AI-Agent入门.md)

### Java
- [Java并发编程](docs/软件开发/Java/Java并发编程.md)
- [Java线程池](docs/软件开发/Java/Java线程池.md)
- [JVM垃圾回收](docs/软件开发/Java/JVM垃圾回收.md)
- [Java反射机制](docs/软件开发/Java/Java反射机制.md)
- [Java集合体系](docs/软件开发/Java/Java集合体系.md)
- [设计模式](docs/软件开发/Java/设计模式.md)

### 数据库
- [Redis快速上手](docs/软件开发/数据库/Redis快速上手.md)
- [MySQL索引详解](docs/软件开发/数据库/MySQL索引详解.md)
- [MySQL-Join查询](docs/软件开发/数据库/MySQL-Join查询.md)

### 框架
- [Spring Boot快速上手](docs/软件开发/框架/SpringBoot快速上手.md)
- [Spring Cloud微服务](docs/软件开发/框架/SpringCloud微服务.md)
- [Kafka快速上手](docs/软件开发/框架/Kafka快速上手.md)
- [MyBatis快速上手](docs/软件开发/框架/MyBatis快速上手.md)

### 架构设计
- [限流熔断降级](docs/软件开发/架构设计/限流熔断降级.md)
- [限流方案详解](docs/软件开发/架构设计/限流方案详解.md)
- [HTTP协议详解](docs/软件开发/架构设计/HTTP协议详解.md)
- [TCP协议详解](docs/软件开发/架构设计/TCP协议详解.md)

### 运维与工具
- [Docker快速上手](docs/运维与工具/Docker快速上手.md)
- [ELK日志平台](docs/运维与工具/ELK日志平台.md)
- [Maven快速上手](docs/运维与工具/Maven快速上手.md)

---

## 🌐 在线访问

| 网站 | 地址 |
|------|------|
| 🏠 **主站** | [vexrune.top](https://vexrune.top) |
| 📚 **知识库** | [wiki.vexrune.top](https://wiki.vexrune.top) |

---

## 🔧 技术栈

- **静态站点生成**: [VitePress](https://vitepress.dev/)
- **部署**: GitHub Actions → 阿里云 OSS
- **主题**: VitePress 默认主题（支持暗色模式）