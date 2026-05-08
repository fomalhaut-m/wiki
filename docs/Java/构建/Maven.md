# Maven

## 概述

Maven 是 Java 项目管理和构建工具，统一依赖管理、自动构建。

## 核心概念

| 概念 | 说明 |
|------|------|
| POM | Project Object Model，项目对象模型 |
| GroupId | 组织 ID（如 `com.example`） |
| ArtifactId | 构件 ID（如 `my-app`） |
| Version | 版本（SNAPSHOT 开发版） |
| Dependency | 依赖 |
| Goal | Maven 命令目标 |

## 依赖范围

| Scope | 编译时 | 测试 | 运行 | 典型场景 |
|-------|--------|------|------|---------|
| `compile` | ✓ | ✓ | ✓ | 默认，全部可用 |
| `provided` | ✓ | ✓ | ✗ | Servlet API（容器提供） |
| `runtime` | ✗ | ✓ | ✓ | JDBC 驱动（运行才需要） |
| `test` | ✗ | ✓ | ✗ | JUnit、Mock |
| `system` | ✓ | ✓ | ✗ | 本地 JAR，不推荐 |

## 常用命令

```bash
mvn clean compile      # 清理并编译
mvn clean package      # 清理并打包
mvn clean install      # 安装到本地仓库
mvn clean deploy       # 发布到远程仓库

# 跳过测试
mvn clean install -DskipTests

# 查看依赖树
mvn dependency:tree

# 排除冲突依赖
mvn dependency:tree -Dincludes=com.alibaba
```

## 依赖传递与冲突

```
A → B → C（1.0）
A → D → C（2.0）  ← 版本冲突，Maven 按最短路径原则选取
```

**解决冲突：**

```xml
<!-- 排除依赖 -->
<dependency>
    <groupId>com.example</groupId>
    <artifactId>A</artifactId>
    <version>1.0</version>
    <exclusions>
        <exclusion>
            <groupId>com.example</groupId>
            <artifactId>C</artifactId>
        </exclusion>
    </exclusions>
</dependency>
```

## 聚合与继承

### 聚合（多模块）

```xml
<modules>
    <module>module-web</module>
    <module>module-service</module>
    <module>module-dao</module>
</modules>
```

### 继承（统一版本）

```xml
<!-- 子 pom 继承父 -->
<parent>
    <groupId>com.example</groupId>
    <artifactId>parent</artifactId>
    <version>1.0.0</version>
</parent>

<!-- 父 pom 定义版本，统一管理 -->
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter</artifactId>
            <version>3.3.0</version>
        </dependency>
    </dependencies>
</dependencyManagement>
```

## 常用插件

| 插件 | 用途 |
|------|------|
| `maven-compiler-plugin` | 指定 Java 版本编译 |
| `maven-surefire-plugin` | 运行测试 |
| `maven-jar-plugin` | 打包 JAR |
| `maven-shade-plugin` | 打可执行 JAR（含依赖） |
| `maven-deploy-plugin` | 发布到远程仓库 |
| `mybatis-generator-maven-plugin` | MyBatis 逆向生成 |
