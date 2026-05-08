# Spring AI 学习路径

## 概览

Spring AI 是 Spring 生态的 AI 开发框架，提供统一抽象的 AI 模型调用接口，支持多模型、记忆管理、工具调用和 RAG。

## 文章索引

| 文章 | 内容 |
|------|------|
| [01 - Spring AI 概述](/AI/SpringAI/01-Spring-AI-概述) | 框架介绍、支持模型列表、最小示例 |
| [02 - Chat Memory 聊天记忆](/AI/SpringAI/02-ChatMemory-聊天记忆) | Advisor 模式、多会话隔离、自定义持久化 |
| [03 - Tool Calling 工具调用](/AI/SpringAI/03-Tool-Calling-工具调用) | @Tool 注解、函数式调用、returnDirect |
| [04 - MCP 协议](/AI/SpringAI/04-MCP-协议) | 客户端与服务端、STDIO/SSE 传输、MCP Market |
| [05 - RAG 检索增强生成](/AI/SpringAI/05-RAG-检索增强生成) | 六步流程、Chroma/Redis 对比、进阶方向 |

## 配套源码

`https://github.com/fomalhaut-m/spring-ai-examples` 包含 8 个可直接运行的子项目。

## 技术栈

- Spring Boot 3.3.5
- Spring AI 1.1.4
- Java 17+
