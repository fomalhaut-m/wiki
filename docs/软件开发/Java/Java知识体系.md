# Java 知识体系

> 来源：个人笔记整理 | 标签：Java / 后端

---

## NIO

### 核心概念
NIO（Non-Blocking IO）是JDK 1.4引入的非阻塞IO，相比传统BIO效率更高。

**核心组件：**
- Channel（通道）：双向数据传输
- Buffer（缓冲区）：读写数据的容器
- Selector（选择器）：监控多个Channel的IO状态

### 使用场景
适合高并发场景，特别是聊天服务器、推送服务等需要处理大量连接的应用。

---

## OAuth 2.0

### 四种授权模式

| 模式 | 说明 | 适用场景 |
|------|------|----------|
| **授权码模式** | 最安全，支持刷新token | 有后端的应用 |
| **隐藏式** | 无后端，纯前端 | 简单SPA |
| **密码式** | 直接用用户名密码换token | 高度可信应用 |
| **凭证式** | 用client credentials换token | 服务间通信 |

### 安全要点
- 令牌不得暴露在URL
- 使用HTTPS
- 令牌要有过期时间
- refresh token要安全存储

---

## 设计模式实践

### 备忘录模式（Memento）
保存对象状态，支持撤销/恢复。

**组成：**
- Originator：发起保存/恢复的对象
- Memento：状态快照
- Caretaker：管理备忘录

### 享元模式（Flyweight）
大量细粒度对象共享，减少内存开销。

---

## 框架知识点

### MyBatis
- 全局配置、映射文件配置
- resultMap高级映射
- 动态SQL
- 缓存机制（一级、二级）
- PageHelper分页
- 逆向工程Generator

### Spring全家桶
- Spring IoC/DI思想
- Spring Boot配置大全
- Spring MVC注解、数据绑定、RESTful
- Spring Cloud微服务架构（Eureka、Feign、Hystrix、Zuul等）

### 消息队列
- Kafka：高性能分布式流平台
- ActiveMQ：JMS实现，支持点对点和发布订阅

### 缓存
- J2Cache：两级缓存（L1 Caffeine + L2 Redis）
- Redis：主从、哨兵、集群模式
- 缓存穿透、击穿、雪崩解决方案

### 任务调度
- Quartz：功能强大的企业级调度框架
- 触发器、JobDetail配置

### 权限管理
- Shiro：认证、授权、加密、会话管理
- Spring Security：更现代的Spring生态安全框架

### 工作流
- Activiti7：BPMN 2.0规范，支持流程设计器

### 注册中心/配置中心
- Zookeeper：分布式协调服务
- Nacos：更现代的服务发现与配置管理（Spring Cloud Alibaba）

---

## 数据库

- MySQL事务、索引优化
- 慢查询分析与优化
- 分库分表策略

---

## 架构设计

### CAP定理
分布式系统不可能同时满足：
- **C（Consistency）**：一致性
- **A（Availability）**：可用性
- **P（Partition tolerance）**：分区容忍性

### 限流方案
- Sentinel：流量控制、熔断降级
- Resilience4j：轻量级熔断框架
- 令牌桶/漏桶算法

### 分布式锁
- Redis实现分布式锁
- Zookeeper临时有序节点
