# Maven 快速上手

> 来源：Maven笔记 | 标签：工具 / Maven

---

## 核心概念

| 概念 | 说明 |
|------|------|
| **POM** | 项目对象模型，核心配置文件 |
| **坐标** | 唯一确定一个Maven工程 |
| **仓库** | 存储依赖Jar包 |
| **生命周期** | clean/compile/test/package/install/deploy |

---

## 目录结构

```
项目名/
├── src/
│   ├── main/
│   │   ├── java/      # 主程序源码
│   │   └── resources/ # 主程序资源
│   └── test/
│       ├── java/      # 测试源码
│       └── resources/ # 测试资源
└── target/           # 编译结果
```

---

## 坐标三要素

```xml
<dependency>
    <groupId>com.aliyun</groupId>      <!-- 公司域名倒序+项目名 -->
    <artifactId>aliyun-java-sdk-core</artifactId>  <!-- 模块名 -->
    <version>4.1.0</version>           <!-- 版本 -->
</dependency>
```

路径：`com/aliyun/aliyun-java-sdk-core/4.1.0/`

---

## 依赖传递

| 机制 | 说明 |
|------|------|
| **依赖传递** | A依赖B，B依赖C → A自动依赖C |
| **最短路径优先** | 多版本时选层次浅的 |
| **先声明优先** | 同一层次选先声明的 |

---

## 依赖作用域（scope）

| scope | 说明 |
|-------|------|
| **compile** | 编译、运行、测试都有效（默认） |
| **provided** | 编译、打包有效，运行时由容器提供 |
| **runtime** | 编译无效，测试、运行有效 |
| **test** | 仅测试有效 |
| **system** | 类似provided，不从仓库拉取 |

---

## 常用命令

```bash
mvn clean          # 清理
mvn compile       # 编译
mvn test          # 测试
mvn package       # 打包
mvn install       # 安装到本地仓库
mvn deploy       # 部署到远程仓库
```

---

## 依赖管理

```xml
<!-- 排除依赖 -->
<exclusion>
    <groupId>...</groupId>
    <artifactId>...</artifactId>
</exclusion>

<!-- 可选依赖（不传递） -->
<optional>true</optional>

<!-- 统一版本管理 -->
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>...</groupId>
            <artifactId>...</artifactId>
            <version>1.0</version>
        </dependency>
    </dependencies>
</dependencyManagement>
```
