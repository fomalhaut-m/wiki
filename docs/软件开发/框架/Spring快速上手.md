# Spring 快速上手

> 来源：Spring笔记 | 标签：框架 / Spring

---

## 什么是Spring

Spring是最受欢迎的企业级Java应用程序开发框架，数以百万计的开发者使用。

**特点**：
- 轻量级（基础版本约2MB）
- 基于POJO编程模型
- 核心：控制反转（IoC）+ 依赖注入（DI）

---

## 核心优势

| 优势 | 说明 |
|------|------|
| **POJO开发** | 不需要EJB容器，可使用Tomcat |
| **模块化** | 只需使用需要的部分 |
| **易于测试** | 环境依赖代码被封装 |
| **Web框架** | 内置Spring MVC |
| **异常转换** | 统一异常API |
| **事务管理** | 本地事务到全局事务（JTA） |

---

## IoC 控制反转

将对象的创建权交给Spring容器管理，由容器负责依赖注入。

### 传统方式

```java
class UserService {
    UserDAO userDAO = new UserDAOImpl();  // 自己创建
}
```

### IoC方式

```java
class UserService {
    private UserDAO userDAO;  // 由容器注入
    public void setUserDAO(UserDAO userDAO) {
        this.userDAO = userDAO;
    }
}
```

---

## DI 依赖注入

| 注入方式 | 说明 |
|----------|------|
| **构造器注入** | 通过构造函数传递参数 |
| **Setter注入** | 通过setter方法设置 |

---

## AOP 面向切面编程

将**横切关注点**（日志、事务、安全、缓存）从业务逻辑中分离出来。

| 概念 | 说明 |
|------|------|
| **Aspect** | 切面，横切关注点模块 |
| **Join Point** | 连接点 |
| **Pointcut** | 切入点 |
| **Advice** | 通知（增强逻辑） |

### 通知类型

| 类型 | 说明 |
|------|------|
| Before | 前置通知 |
| After | 后置通知 |
| Around | 环绕通知 |
| AfterReturning | 返回后通知 |
| AfterThrowing | 异常通知 |
