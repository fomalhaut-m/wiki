# Spring 核心

## 概述

Spring 是轻量级 Java 开发框架，核心是 **IoC 容器** + **AOP**。

**主要模块：**
- Spring Core（IoC/DI）
- Spring AOP（面向切面编程）
- Spring MVC（Web 框架）
- Spring Data（JPA/Redis/MongoDB 等）

## IoC（控制反转）

把对象的创建权交给 Spring 容器，由容器负责组装对象之间的关系。

**传统方式：** `UserService us = new UserServiceImpl();` — 自己 new

**IoC 方式：** Spring 通过 setter 或构造器注入 — 被动接收

### Bean 的定义

```xml
<!-- applicationContext.xml -->
<bean id="userService" class="com.example.impl.UserServiceImpl">
    <property name="userDao" ref="userDao"/>
</bean>

<bean id="userDao" class="com.example.UserDaoImpl"/>
```

### 注解方式（推荐）

```java
@Component        // 通用组件
@Service         // 业务层
@Repository      // 持久层
@Controller       // 控制层（SpringMVC）
```

```java
// 配置组件扫描
@Configuration
@ComponentScan("com.example")
public class AppConfig { }

// 依赖注入
@Autowired
private UserDao userDao;  // 按类型自动注入

@Value("${jdbc.url}")
private String url;        // 注入配置值
```

### Bean 作用域

| Scope | 说明 |
|-------|------|
| `singleton` | 单例（默认），容器只有一个实例 |
| `prototype` | 多例，每次获取创建新实例 |
| `request` | HTTP 请求一次 |
| `session` | HTTP 会话一次 |

## DI（依赖注入）

### setter 注入

```xml
<bean id="userService" class="com.example.UserServiceImpl">
    <property name="userDao" ref="userDao"/>
    <property name="name" value="luke"/>
</bean>
```

### 构造器注入

```xml
<bean id="userService" class="com.example.UserServiceImpl">
    <constructor-arg ref="userDao"/>
</bean>
```

### 自动装配

```xml
<bean id="userService" class="com.example.UserServiceImpl" autowire="byType"/>
```

## AOP（面向切面编程）

把分散在多个模块的**公共行为**（日志、事务、权限）抽取出来，达到**业务逻辑与公共行为分离**。

### 核心概念

| 概念 | 说明 |
|------|------|
| Join Point | 连接点，可被增强的方法 |
| Pointcut | 切入点，真正被增强的方法 |
| Advice | 通知/增强逻辑（前置/后置/异常/环绕） |
| Aspect | 切面 = Pointcut + Advice |
| Weaving | 织入，把通知应用到切入点的过程 |

### AOP 示例

```java
@Aspect
@Component
public class TransactionAspect {

    @Pointcut("execution(* com.example.service.*.*(..))")
    public void pointcut() {}

    @Around("pointcut()")
    public Object around(ProceedingJoinPoint pjp) {
        try {
            System.out.println("开启事务");
            Object result = pjp.proceed();
            System.out.println("提交事务");
            return result;
        } catch (Throwable e) {
            System.out.println("回滚事务");
            throw e;
        }
    }
}
```

### 常用 Pointcut 表达式

```java
@Pointcut("execution(* com.example.service..*(..))")    // service 包下所有方法
@Pointcut("within(com.example.service.*)")               // within 限定类
@Pointcut("@annotation(org.springframework.transaction.Transactional)")  // 注解匹配
```

## 事务

### 编程式事务

```java
TransactionTemplate template;
template.execute(status -> {
    // 业务逻辑
    return null;
});
```

### 声明式事务（推荐）

```java
@Transactional(rollbackFor = Exception.class)
public void transfer(int from, int to, double amount) {
    // 转账逻辑
}
```

**常用参数：**

| 参数 | 说明 |
|------|------|
| `propagation` | 传播行为 |
| `isolation` | 隔离级别 |
| `rollbackFor` | 回滚异常类型 |
| `readOnly` | 是否只读 |

### 事务传播行为

| 传播 | 说明 |
|------|------|
| REQUIRED | 有事务加入，无则新建（默认） |
| REQUIRES_NEW | 挂起当前，新建独立事务 |
| NESTED | 嵌套事务（子事务） |
| SUPPORTS | 跟随调用方事务 |
