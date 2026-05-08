# Chat Memory 聊天记忆

## 问题背景

大模型本身**无状态**，每次对话都是独立的。要让 AI "记住"之前聊了什么，需要自己管理上下文。

Spring AI 通过 **Advisor 模式** 将 ChatMemory 接入 ChatClient，实现多轮对话记忆。

## 核心组件

### ChatMemory 接口

```java
public interface ChatMemory {
    void add(String conversationId, List<Message> messages);
    List<Message> get(String conversationId, int lastN);
    void clear(String conversationId);
}
```

### 内存实现

```java
// 消息窗口：只保留最近 N 条
MessageWindowChatMemory.builder()
    .maxMessages(10)
    .build();

// 或用 Repository 模式
InMemoryChatMemoryRepository
```

### 与 ChatClient 集成

```java
// 方式一：自动记忆拦截
ChatMemory memory = new MessageWindowChatMemory(10);
MessageChatMemoryAdvisor advisor = new MessageChatMemoryAdvisor(memory);

String response = chatClient.prompt()
    .advisors(advisor)                          // 注入记忆
    .advisors(a -> a.param("conversationId", "user-123")) // 绑定会话
    .user("我喜欢跑步")
    .call()
    .content();

// 方式二：手动管理
memory.add("user-123", List.of(new UserMessage("你好")));
memory.add("user-123", List.of(new AssistantMessage("你好！有什么可以帮你？")));
List<Message> history = memory.get("user-123", 10);
```

## 多会话隔离

通过不同的 `conversationId` 实现会话隔离：

```java
// 会话 A
chatClient.prompt()
    .advisors(a -> a.param("conversationId", "session-A"))
    .user("我叫张三")
    .call();

// 会话 B（独立记忆）
chatClient.prompt()
    .advisors(a -> a.param("conversationId", "session-B"))
    .user("我叫什么？")  // 不会回答"张三"
    .call();
```

## 自定义 ChatMemory 持久化

```java
@Component
public class MyChatMemory implements ChatMemory {
    private final MongoTemplate mongo;

    @Override
    public void add(String conversationId, List<Message> messages) {
        // 存入 MongoDB / Redis / DB
    }

    @Override
    public List<Message> get(String conversationId, int lastN) {
        // 按 lastN 读取
    }

    @Override
    public void clear(String conversationId) {
        // 清除会话
    }
}
```

## 完整示例入口

``https://github.com/fomalhaut-m/spring-ai-examples`/spring-ai-advisors-examples`

## 记忆策略

| 策略 | 说明 |
|------|------|
| MessageWindowChatMemory | 只保留最近 N 条，防止上下文溢出 |
| TokenWindowChatMemory | 按 token 数限制，更精确 |
| SummaryMemory | 自动摘要，节省 token |

## 适用场景

- 客服多轮对话
- 个人助手记住用户偏好
- 文档问答的上下文延续
