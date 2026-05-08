# Tool Calling 工具调用

## 原理

工具调用让大模型不只是"说话"，而是能**真正执行操作**。流程：

```
用户提问 → 模型判断需调用工具 → 执行工具 → 将结果返回模型 → 生成最终回答
```

Spring AI 支持三种工具定义方式：

## 方式一：注解式 `@Tool`

```java
public class DateTimeTools {

    @Tool(description = "获取当前日期和时间")
    public String getCurrentDateTime() {
        return LocalDateTime.now().toString();
    }

    @Tool(description = "计算两个日期之间的天数")
    public long daysBetween(@ToolParam(description = "开始日期") String start,
                            @ToolParam(description = "结束日期") String end) {
        return ChronoUnit.DAYS.between(
            LocalDate.parse(start), LocalDate.parse(end));
    }
}
```

注册到 ChatClient：
```java
ChatClient chatClient = ChatClient.builder(dedaultChatModel)
    .defaultTools(new DateTimeTools())  // 注入工具
    .build();
```

## 方式二：函数式 `Function<T, R>`

```java
// 定义函数
public class WeatherService {
    public String getWeather(String city) {
        return "北京今天晴，25度";
    }
}

Function<String, String> weatherFn = new Function<>() {
    @Override
    public String apply(String city) {
        return new WeatherService().getWeather(city);
    }
};

// 注册
ChatClient chatClient = ChatClient.builder(dedaultChatModel)
    .defaultTools(Function.create("weather", "查询城市天气", weatherFn))
    .build();
```

## 方式三：`MethodToolCallback`

```java
MethodToolCallback weatherCallback = MethodToolCallback.builder()
    .method(WeatherService.class.getMethod("getWeather", String.class))
    .toolCallback(new WeatherService())
    .build();
```

## `returnDirect` 模式

工具返回结果**直接返回给用户**，不经过模型二次处理：

```java
@Tool(returnDirect = true)
public String getWeather(String city) {
    return weatherService.query(city);  // 直接返回
}
// 模型调用工具后，结果直接输出，不继续生成
```

## 完整示例

``https://github.com/fomalhaut-m/spring-ai-examples`/spring-ai-chat-model-examples/ToolExamples`

## 常用工具场景

| 工具 | 说明 |
|------|------|
| 天气查询 | 实时数据 |
| 搜索增强 | 实时联网搜索 |
| 数据库查询 | 查企业业务数据 |
| 文件操作 | 读写本地文件 |
| API 调用 | 调第三方接口 |

## 与 MCP 的区别

| 维度 | Tool Calling | MCP |
|------|-------------|-----|
| 范围 | 同进程内 | 可跨网络调用远程服务 |
| 协议 | 厂商自定义 | 统一协议（Model Context Protocol） |
| 适用 | 本地业务逻辑 | 外部工具服务集成 |
