---
title: RabbitMQ消息队列入门
---

# RabbitMQ消息队列

## 简介

RabbitMQ是实现了AMQP协议的开源消息中间件，用于在分布式系统中存储和转发消息。

## 快速启动

```bash
# Windows启动脚本
init_rabbitmq.bat
```

## 核心概念

| 概念 | 说明 |
|------|------|
| **Producer** | 消息生产者 |
| **Consumer** | 消息消费者 |
| **Exchange** | 交换机，路由消息 |
| **Queue** | 队列，存储消息 |
| **Binding** | 绑定，连接交换机和队列 |

## 常见应用场景

- 异步处理
- 应用解耦
- 流量削峰
- 日志处理
- 消息推送