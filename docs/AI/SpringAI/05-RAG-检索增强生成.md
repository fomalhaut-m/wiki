# RAG 检索增强生成

## 是什么

RAG = Retrieval-Augmented Generation，即"先检索再生成"。

大模型的弱点：**知识有截止日期，且可能 hallucinate（瞎编）**。RAG 通过检索真实文档，让生成有据可查。

## 核心流程

```
文档 → 分割(Chunk) → 向量化(Embedding) → 存入向量数据库
                                            │
用户问题 ──► 向量化 ──► 相似度检索 ──► 拼接上下文 ──► LLM 生成回答
```

**6 个步骤：**

| 步骤 | 操作 | 说明 |
|------|------|------|
| 1 | 文档加载 | PDF / Word / HTML / Markdown |
| 2 | 文本分割 | 按段落/句子/Token 切成 Chunk |
| 3 | 向量化 | Embedding 模型转成向量 |
| 4 | 存储 | 存入 VectorStore |
| 5 | 检索 | 相似度搜索（余弦/欧氏距离） |
| 6 | 生成 | 将检索结果作为上下文传给 LLM |

## 向量数据库对比

`https://github.com/fomalhaut-m/spring-ai-examples` 中两个实战项目：

### Chroma（轻量级）

```bash
docker run -p 8000:8000 ghcr.io/chroma-core/chroma:1.0.0
```

```java
ChromaApi chromaApi = new ChromaApi("http://localhost:8000");
ChromaVectorStore store = ChromaVectorStore.builder(chromaApi, embeddingModel)
    .collectionName("my-rag")
    .initializeSchema(true)
    .build();
```

特点：开源免费、轻量、易部署，适合中小型知识库。

### Redis Stack（企业级）

```bash
docker run -p 6379:6379 redis/redis-stack
```

```java
RedisVectorStore store = RedisVectorStore.builder(
    new JedisPooled("localhost", 6379), embeddingModel)
    .indexName("my-rag-index")
    .prefix("rag:")
    .metadataFields(
        MetadataField.tag("category"),
        MetadataField.numeric("year"))
    .initializeSchema(true)
    .build();
```

特点：高性能、支持 HNSW/FLAT 索引、企业级部署成熟。

## 元数据过滤

检索时按元数据精筛：

```java
Filter.Expression filter = new FilterExpressionBuilder()
    .and(
        new FilterExpressionBuilder().in("category", "database"),
        new FilterExpressionBuilder().gte("year", 2023)
    )
    .build();

vectorStore.similaritySearch(SearchRequest.builder()
    .query("如何优化 SQL")
    .filterExpression(filter)
    .topK(5)
    .build());
```

## RAG 进阶方向

| 方向 | 说明 |
|------|------|
| **重排序 (Re-Ranker)** | 先召回 20 条，用 Re-Ranker 精选 5 条 |
| **混合搜索** | 关键词 + 向量搜索融合 |
| **知识图谱 RAG** | 用 Graph 表达实体关系 |
| **多模态 RAG** | 支持图片、PDF 图表检索 |
| **Agentic RAG** | 让 Agent 决定查什么、查几个、是否再查 |

## 完整知识库示例

``https://github.com/fomalhaut-m/spring-ai-examples`/spring-ai-wiki-examples` 包含：

- Spring AI ChatClient（对话）
- MongoDB（多会话记忆）
- Chroma（向量存储）
- MCP（高德地图集成）
- RAG（知识库问答）

**架构图：**

```
用户 ──► ChatClient ──► MiniMax LLM
              │
              ├─► MongoDB（记忆）
              │
              └─► Chroma（RAG 检索）
```
