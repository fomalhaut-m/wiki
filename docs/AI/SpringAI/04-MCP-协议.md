# MCP 协议（Model Context Protocol）

## 是什么

MCP 是一个**开放协议**，用于将 AI 模型与外部工具和数据源连接。比 Tool Calling 更通用，可以连接远程服务器。

官方定位：
> A protocol that enables AI applications to connect with external tools and data sources.

## 架构

```
┌─────────────┐       MCP Protocol        ┌─────────────────┐
│  AI 应用    │ ◄──────────────────────► │  MCP Server      │
│ (Spring AI) │  STDIO / SSE / HTTP      │ (任意实现)       │
└─────────────┘                          └─────────────────┘
       │                                        │
       │                                        ▼
       │                                 ┌─────────────────┐
       │                                 │  实际工具/资源  │
       │                                 │ (文件系统/API)  │
       └────────────────────────────────►│                 │
                                         └─────────────────┘
```

## 传输方式

| 方式 | 场景 |
|------|------|
| STDIO | 本地进程通信，延迟最低 |
| SSE（Server-Sent Events） | 远程服务，支持服务端推送 |
| Streamable HTTP | 双向流，支持实时响应 |

## MCP 服务端示例（Spring AI）

``https://github.com/fomalhaut-m/spring-ai-examples`/spring-ai-mcp-server-examples`

### 注解驱动暴露工具

```java
@McpTool(description = "获取城市天气预报")
public WeatherResponse getTemperature(
    @McpToolParam(description = "纬度") double lat,
    @McpToolParam(description = "经度") double lon,
    @McpToolParam(description = "城市名") String city)
{
    // 调用 Open-Meteo API
    return weatherService.query(lat, lon, city);
}
```

### 注解说明

| 注解 | 用途 |
|------|------|
| `@McpTool` | 声明一个工具方法 |
| `@McpToolParam` | 声明工具参数描述 |
| `@McpResource` | 暴露一个资源（文件/数据） |
| `@McpPrompt` | 暴露提示模板 |

### 依赖

```xml
<dependency>
    <groupId>org.springframework.ai</groupId>
    <artifactId>spring-ai-starter-mcp-server-webflux</artifactId>
</dependency>
```

## MCP 客户端示例（Spring AI）

``https://github.com/fomalhaut-m/spring-ai-examples`/spring-ai-mcp-client-examples`

### 连接 STDIO 本地服务器

```java
// 启动本地 MCP 文件系统服务器
// npx -y @modelcontextprotocol/server-filesystem .

McpStdioClientCallbackTransport transport = new McpStdioClientCallbackTransport(
    ProcessBuilder.start("npx", "-y",
        "@modelcontextprotocol/server-filesystem", ".")
);
McpWebClient client = McpWebClient.create(transport);

// 自动注册为 Spring AI 工具
chatClient.prompt()
    .tools(client)
    .user("帮我读取根目录的 README.md")
    .call();
```

### 连接 SSE 远程服务器

```java
McpSseClientCallbackTransport transport = new McpSseClientCallbackTransport(
    URI.create("https://your-mcp-server.com/sse")
);
```

## MCP 市场

[MCP Market (mcpmarket.cn)](https://mcpmarket.cn) 提供大量现成 MCP 服务器：

- 高德地图（地理编码、路径规划）
- GitHub（仓库操作）
- 数据库（SQL 查询）
- Slack/钉钉（消息推送）

## 适用场景

| 场景 | MCP 优势 |
|------|---------|
| 调用外部 API（地图/天气） | 不暴露密钥，协议统一 |
| 连接数据库做 RAG | 语义搜索 + 精确数据 |
| 企业内部工具 | 统一协议，易管理 |
| 文件系统访问 | 安全沙箱，可控权限 |
