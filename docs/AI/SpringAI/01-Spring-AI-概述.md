# Spring AI 概述

Spring AI 是 Spring 生态中的 AI 开发框架，提供了统一抽象的 AI 模型调用接口。其核心价值在于：**告别各厂商 SDK 的差异化调用**，用一套 API 接入所有大模型。

## 技术栈

- Spring Boot 3.3.5
- Spring AI 1.1.4
- Java 17+

## 支持的模型

| 模型 | 依赖 | 说明 |
|------|------|------|
| OpenAI | spring-ai-starter-model-openai | GPT-3.5 / GPT-4 |
| DeepSeek | spring-ai-starter-model-deepseek | DeepSeek V3 / R1 |
| MiniMax | spring-ai-starter-model-minimax | abab / M2 系列 |
| 智谱 AI | spring-ai-starter-model-zhipuai | GLM-3 / GLM-4 |
| Ollama | spring-ai-starter-model-ollama | 本地模型 |
| Anthropic | spring-ai-starter-model-anthropic | Claude 系列 |
| Mistral AI | spring-ai-starter-model-mistral-ai | Mistral 系列 |
| HuggingFace | spring-ai-starter-model-huggingface | HF 模型 |

## 最小示例

依赖：
```xml
<dependency>
    <groupId>org.springframework.ai</groupId>
    <artifactId>spring-ai-starter-model-minimax</artifactId>
</dependency>
```

配置：
```properties
spring.ai.minimax.api-key=${MINIMAX_API_KEY}
```

调用：
```java
@RestController
public class ChatController {
    private final ChatClient chatClient;

    public ChatController(ChatClient chatClient) {
        this.chatClient = chatClient;
    }

    @GetMapping("/chat")
    public String chat(@RequestParam String message) {
        return chatClient.prompt()
            .user(message)
            .call()
            .content();
    }
}
```

## 核心 API 演变

Spring AI 先后有两套 API：

| API | 说明 |
|-----|------|
| `ChatClient`（新） | Spring AI 1.1+ 主推，统一抽象，支持所有模型 |
| `AiTemplate`（旧） | 早期 API，已不推荐 |

## 项目源码

`https://github.com/fomalhaut-m/spring-ai-examples` 包含 8 个子项目：

| 项目 | 用途 |
|------|------|
| spring-ai-chat-model-examples | 多模型 + 嵌入 + 工具调用 |
| spring-ai-advisors-examples | 多轮对话记忆 |
| spring-ai-mcp-client-examples | MCP 客户端 |
| spring-ai-mcp-server-examples | MCP 服务器 |
| spring-ai-rag-examples | RAG 基础流程 |
| spring-ai-rag-chroma-examples | RAG + Chroma |
| spring-ai-rag-redis-examples | RAG + Redis Stack |
| spring-ai-wiki-examples | 完整知识库系统 |
