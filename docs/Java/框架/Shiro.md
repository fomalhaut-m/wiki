# Shiro 安全框架

## 概述

Apache Shiro 是 Java 安全框架，提供**认证（Authentication）+ 授权（Authorization）+ 会话管理 + 加密**。

## 核心概念

| 概念 | 说明 |
|------|------|
| Subject | 当前用户主体 |
| SecurityManager | 安全核心，管理所有 Subject |
| Realm | 认证和授权的数据源 |
| Authenticator | 认证器 |
| Authorizer | 授权器 |

## 认证流程

```
Subject.login(token) → SecurityManager → Authenticator → Realm（数据源）→ 返回认证结果
```

## 快速使用

### 登录认证

```java
Subject subject = SecurityUtils.getSubject();
UsernamePasswordToken token = new UsernamePasswordToken("luke", "123456");

try {
    subject.login(token);  // 认证成功
} catch (UnknownAccountException e) {
    // 用户名不存在
} catch (IncorrectCredentialsException e) {
    // 密码错误
}
```

### 授权（权限验证）

```java
// 角色验证
if (subject.hasRole("admin")) {
    // 有 admin 角色
}

// 权限验证
if (subject.isPermitted("user:delete")) {
    // 有删除用户权限
}

// 多个权限验证
if (subject.isPermittedAll("user:create", "user:delete")) {
    // 同时拥有创建和删除权限
}
```

## Shiro 配置文件

### INI 格式（shiro.ini）

```ini
[users]
luke = 123456, admin
tom = 654321, user

[roles]
admin = user:*, system:*
user = user:view, user:create

[urls]
/admin/** = authc, roles[admin]
/user/** = authc
```

### Spring Boot 整合

```java
@Configuration
public class ShiroConfig {

    @Bean
    public Realm myRealm() {
        return new MyRealm();
    }

    @Bean
    public SecurityManager securityManager(Realm realm) {
        DefaultWebSecurityManager manager = new DefaultWebSecurityManager();
        manager.setRealm(realm);
        return manager;
    }

    @Bean
    public ShiroFilterChainDefinition filterChainDefinition() {
        DefaultShiroFilterChainDefinition chain = new DefaultShiroFilterChainDefinition();
        chain.addPathDefinition("/login", "anon");      // 匿名访问
        chain.addPathDefinition("/**", "authc");       // 需要认证
        return chain;
    }
}
```

## 密码加密

```java
// 使用 MD5/SHA 加密
HashedCredentialsMatcher matcher = new HashedCredentialsMatcher("MD5");
matcher.setHashIterations(1024);  // 迭代次数
realm.setCredentialsMatcher(matcher);

// 存储时加密
String hashedPassword = new SimpleHash("MD5", "123456", salt, 1024).toString();
```

## Session 管理

```java
// 获取 session
Session session = subject.getSession();
session.setAttribute("user", user);

// 设置 session 超时
session.setTimeout(30 * 60 * 1000);  // 30 分钟
```
