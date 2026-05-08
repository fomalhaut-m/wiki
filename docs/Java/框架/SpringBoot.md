# Spring Boot

## 概述

Spring Boot 是基于 Spring 的**自动配置**框架，目标是"零配置"开发。

**核心优势：**
- 自动配置（Auto Configuration）
- 嵌入式 Web 容器（Tomcat/Jetty）
- Starter 依赖（统一版本管理）
- 生产级特性（Actuator 监控）

## 快速开始

```xml
<!-- pom.xml -->
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>3.3.0</version>
</parent>

<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
</dependencies>
```

```java
@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
```

## 配置文件

### application.properties / application.yml

```properties
# application.properties
server.port=8080
spring.application.name=myapp
spring.profiles.active=dev

# 数据源
spring.datasource.url=jdbc:mysql://localhost:3306/test
spring.datasource.username=root
spring.datasource.password=123456

# JPA
spring.jpa.show-sql=true
```

```yaml
# application.yml
server:
  port: 8080
spring:
  application:
    name: myapp
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://localhost:3306/test
    username: root
    password: 123456
```

### 多环境配置

```
application.yml          # 默认配置
application-dev.yml      # 开发环境
application-prod.yml     # 生产环境
application-test.yml    # 测试环境
```

激活方式：`spring.profiles.active=dev`

## 自动配置原理

`@SpringBootApplication` = `@SpringBootConfiguration` + `@EnableAutoConfiguration` + `@ComponentScan`

**EnableAutoConfiguration 流程：**
1. `META-INF/spring.factories` 加载所有 `EnableAutoConfiguration`
2. 按条件筛选生效的配置类（`@ConditionalOnClass` 等）
3. 通过 `xxxProperties` 绑定配置文件中的值

### 自定义配置

```java
// 读取配置
@Value("${app.title}")
private String title;

@ConfigurationProperties(prefix = "app")
@Component
public class AppProperties {
    private String title;
    private String version;
}
```

## Web 开发

### REST API

```java
@RestController
@RequestMapping("/api/users")
public class UserController {

    @GetMapping("/{id}")
    public User get(@PathVariable Long id) {
        return userService.findById(id);
    }

    @PostMapping
    public Result save(@RequestBody @Valid User user) {
        userService.save(user);
        return Result.ok();
    }
}
```

## 数据访问

### JPA

```java
public interface UserRepository extends JpaRepository<User, Long> {
    List<User> findByAgeGreaterThan(int age);
    Optional<User> findByNameAndEmail(String name, String email);
}
```

### MyBatis 整合

```xml
<dependency>
    <groupId>org.mybatis.spring.boot</groupId>
    <artifactId>mybatis-spring-boot-starter</artifactId>
</dependency>
```

```properties
mybatis.mapper-locations=classpath:mapper/*.xml
mybatis.type-aliases-package=com.example.entity
```

## 日志

Spring Boot 默认用 SLF4J + Logback。

```properties
logging.level.root=INFO
logging.level.com.example=DEBUG
logging.pattern.console=%d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level %logger{36} - %msg%n
```

## Actuator（生产级监控）

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

```properties
management.endpoints.web.exposure.include=health,info,metrics,env
management.endpoint.health.show-details=always
```

常用端点：
- `/actuator/health` — 健康检查
- `/actuator/metrics` — 指标
- `/actuator/env` — 环境变量
- `/actuator/beans` — 所有 Bean

## 常用 Starter

| Starter | 用途 |
|---------|------|
| `spring-boot-starter-web` | Web 开发 |
| `spring-boot-starter-data-jpa` | JPA/ORM |
| `spring-boot-starter-data-redis` | Redis |
| `spring-boot-starter-security` | 安全认证 |
| `spring-boot-starter-actuator` | 监控 |
| `spring-boot-starter-validation` | 参数校验 |
