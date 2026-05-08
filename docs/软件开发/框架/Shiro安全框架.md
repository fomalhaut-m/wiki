# Shiro 安全框架

> 来源：Shiro笔记 | 标签：框架 / 安全

---

## 简介

Shiro是Java安全权限框架，可以非常容易地开发出足够好的应用，支持JavaSE和JavaEE环境。

**核心功能**：认证、授权、加密、会话管理、与Web集成、缓存

---

## 架构图

```
应用代码 → Subject（用户） → SecurityManager（核心） → Realm（数据源）
```

---

## 核心组件

| 组件 | 说明 |
|------|------|
| **Subject** | 与应用交互的用户，Subject委托SecurityManager |
| **SecurityManager** | 所有安全操作的管理者，相当于DispatcherServlet |
| **Realm** | 获取安全数据（用户、角色、权限），相当于DataSource |

---

## 详细模块

| 模块 | 说明 |
|------|------|
| **Authentication** | 身份认证/登录 |
| **Authorization** | 授权，权限验证 |
| **SessionManager** | 会话管理，Web或普通JavaSE环境 |
| **Cryptography** | 加密，保护数据安全 |
| **Caching** | 缓存，提高性能 |
| **Concurrency** | 多线程并发验证 |
| **Testing** | 测试支持 |
| **Run As** | 允许假装为另一个用户 |
| **Remember Me** | 记住我 |

---

## 认证流程

```
Subject.login(token) → SecurityManager → Authenticator → Realm
```

认证步骤：
1. 收集Subject身份（用户名）
2. 收集身份凭证（密码）
3. 调用`subject.login(token)`
4. SecurityManager委托Authenticator验证
5. Realm获取数据进行比较

---

## 授权流程

```java
subject.checkRole("admin");           // 角色检查
subject.checkPermission("user:create"); // 权限检查
```

---

## Spring Boot 集成

```xml
<dependency>
    <groupId>org.apache.shiro</groupId>
    <artifactId>shiro-spring-boot-web-starter</artifactId>
    <version>1.9.1</version>
</dependency>
```

### 配置

```yaml
shiro:
  web:
    enabled: true
  loginUrl: /login
  successUrl: /index
  unauthorizedUrl: /unauthorized
```

---

## 与Spring Security对比

| 对比 | Shiro | Spring Security |
|------|-------|----------------|
| 复杂度 | 简单 | 复杂 |
| 学习曲线 | 平缓 | 陡峭 |
| 社区 | 较活跃 | 非常活跃 |
| 集成 | 容易 | 较难 |
| 适用场景 | 轻量级项目 | 企业级项目 |
