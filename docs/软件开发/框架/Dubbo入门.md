# Dubbo 入门

> 来源：Dubbo笔记 | 标签：架构 / RPC / Dubbo

---

## 什么是Dubbo

Apache Dubbo 是高性能、轻量级的开源Java RPC框架。

**三大核心能力**：
1. 面向接口的远程方法调用
2. 智能容错和负载均衡
3. 服务自动注册和发现

---

## 分布式架构演进

### 1. 单一应用架构
- 所有功能部署在一个应用中
- 适用于小型网站
- 缺点：扩展性差，协同难

### 2. 垂直应用架构
- 按业务拆分成多个独立应用
- 缺点：公共模块无法复用

### 3. 分布式服务架构
- 核心业务抽取为独立服务
- 需要RPC框架

### 4. 流动计算架构（SOA）
- 调度中心治理资源
- 提高机器利用率

---

## RPC 核心原理

RPC（远程过程调用）：让调用远程机器上的函数就像调用本地函数一样。

**两个核心模块**：
- 通讯
- 序列化

常见RPC框架：Dubbo、gRPC、Thrift、HSF

---

## Dubbo 架构

```
┌─────────────────────────────────────┐
│           服务消费者 Consumer        │
└──────────────┬──────────────────────┘
               │
    ┌──────────▼──────────┐
    │      注册中心 Registry │
    └──────────┬──────────┘
               │
┌──────────────▼──────────────────────┐
│           服务提供者 Provider        │
└──────────────────────────────────────┘
               │
    ┌──────────▼──────────┐
    │      监控中心 Monitor │
    └─────────────────────┘
```

### 各角色说明

| 角色 | 说明 |
|------|------|
| **Provider** | 服务提供者，启动时向注册中心注册 |
| **Consumer** | 服务消费者，向注册中心订阅服务 |
| **Registry** | 注册中心，返回提供者地址列表 |
| **Monitor** | 监控中心，统计调用次数和时间 |

### 调用流程

1. 服务容器启动，加载运行Provider
2. Provider向注册中心注册自己提供的服务
3. Consumer启动，向注册中心订阅所需服务
4. 注册中心推送地址列表给Consumer
5. Consumer基于负载均衡选一台Provider调用
6. Consumer和Provider每分钟向Monitor发送统计数据

---

## 支持的注册中心

| 注册中心 | 说明 |
|----------|------|
| **Zookeeper** | 推荐生产环境使用 |
| Nacos | 轻量级，支持配置管理 |
| Redis | 简单场景 |
| Multicast | 广播模式 |
| Simple | 开发测试用 |

---

## Spring Boot 集成

```xml
<dependency>
    <groupId>org.apache.dubbo</groupId>
    <artifactId>dubbo-spring-boot-starter</artifactId>
    <version>2.7.8</version>
</dependency>
```

```yaml
dubbo:
  application:
    name: dubbo-provider
  registry:
    address: zookeeper://localhost:2181
  protocol:
    name: dubbo
    port: 20880
```
