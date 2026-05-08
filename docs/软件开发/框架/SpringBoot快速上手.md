# Spring Boot 快速上手

> 来源：Spring Boot笔记 | 标签：框架 / Spring Boot

---

## 简介

- 简化Spring应用开发的框架
- 整个Spring技术栈的大整合
- J2EE开发一站式解决方案

---

## 微服务

2014年Martin Fowler提出微服务架构风格：
> 应用应该是一组小型服务，可以通过HTTP方式进行互通

**单体应用**：ALL IN ONE  
**微服务**：服务粒度小，独立进程，轻量级通信（REST API）

---

## 快速开始

### 1. 导入依赖

```xml
<!-- 父项目 -->
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>2.x.x.RELEASE</version>
</parent>

<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
</dependencies>
```

### 2. 主程序

```java
@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
```

### 3. 编写Controller

```java
@RestController
public class HelloController {
    @RequestMapping("/hello")
    public String hello() {
        return "Hello World!";
    }
}
```

### 4. 打包部署

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
        </plugin>
    </plugins>
</build>
```

```bash
mvn clean package
java -jar xxx.jar
```

---

## 项目结构

```
src/main/
├── java/
│   └── com.example.demo/
│       ├── DemoApplication.java
│       ├── Controller/
│       ├── Service/
│       └── Config/
├── resources/
│   ├── application.yml
│   ├── static/        # 静态资源
│   └── templates/     # 模板页面
```

---

## 常用注解

| 注解 | 说明 |
|------|------|
| `@SpringBootApplication` | 主程序入口 |
| `@RestController` | REST风格控制器 |
| `@Service` | 服务层 |
| `@Repository` | 持久层 |
| `@Component` | 通用组件 |
| `@Configuration` | 配置类 |
| `@Bean` | 声明式创建Bean |
| `@Value` | 注入配置属性 |
| `@Autowired` | 自动注入 |

---

## Spring Boot vs Spring MVC

| 区别 | Spring MVC | Spring Boot |
|------|------------|-------------|
| 关注点 | Web框架 | 应用框架 |
| 配置 | 手动配置 | 自动配置 |
| 部署 | 打成war | 打成jar（嵌入式Tomcat） |
| 监控 | 无 | Actuator |
