# ELK 日志平台入门

## 为什么需要 ELK

传统日志管理的问题：
- 日志分散在多台服务器
- 无法实时查看
- 难以搜索和分析
- 日志文件体积过大难以维护

**ELK 是一套分布式日志采集、存储、搜索、可视化系统。**

## ELK 是什么

ELK = Elasticsearch + Logstash + Kibana

| 组件 | 作用 |
|------|------|
| **Elasticsearch** | 分布式搜索引擎，存储和检索日志 |
| **Logstash** | 日志采集、过滤、转换工具 |
| **Kibana** | 可视化 Web 界面 |
| **Filebeat** | 轻量级日志采集 Agent（推荐替代 Logstash 采集端） |

## 架构一：简单架构

```
Filebeat → Logstash → Elasticsearch → Kibana
```

- 优点：搭建简单
- 缺点：Logstash 资源消耗大，不适合大规模

## 架构二：引入消息队列

```
Filebeat → Kafka/Redis → Logstash → Elasticsearch → Kibana
```

- 优点：解耦，削峰填谷，防止数据丢失
- 适合中等规模

## 架构三：生产级架构

```
Beats(多点) → Kafka → Logstash(集群) → Elasticsearch(集群) → Kibana
```

- 优点：支持横向扩展，适合大规模日志分析
- Kafka 缓冲，Logstash 集群消费，Elasticsearch 集群存储

## Filebeat 工作原理

Filebeat 有两个核心组件：

### Harvester（收割器）

负责读取单个文件内容，逐行读取并发送。会在以下情况关闭：
- 文件被删除或重命名
- `close_inactive` 超时
- `scan_frequency` 扫描间隔（默认 10s）

### Prospector（探测器）

负责找到要收割的文件，追踪文件列表。配置示例：

```yaml
filebeat.prospectors:
  - input_type: log
    paths:
      - /apps/logs/*/info.log
```

**特点：** 只追踪本地文件，不能监控远程文件。

### 持久化与可靠性

Filebeat 将读取进度保存在 `/var/lib/filebeat/registry`，重启后可从上次位置继续，不会漏数据。

## Logstash 工作流程

```
Input → Filter → Output
```

### Input（输入）

| 来源 | 说明 |
|------|------|
| `file` | 文件系统，日志文件 |
| `syslog` | 514 端口，系统日志 |
| `redis` | 从 Redis 读取 |
| `beats` | 从 Filebeat 接收 |

### Filter（过滤/转换）

| 插件 | 说明 |
|------|------|
| `grok` | 正则解析，将非结构化日志转为结构化字段 |
| `mutate` | 字段操作：重命名、删除、替换 |
| `drop` | 丢弃不需要的日志 |
| `geoip` | 根据 IP 追加地理位置信息 |

### Output（输出）

| 目标 | 说明 |
|------|------|
| `elasticsearch` | 写入 ES |
| `file` | 写入文件 |
| `graphite` | 写入监控系统 |

## Kibana

Kibana 为 Elasticsearch 提供可视化 Web 界面：
- 搜索查询
- 图表展示
- 仪表盘配置
- 告警规则

## 快速启动（Docker）

```bash
# Elasticsearch
docker run -p 9200:9200 \
  -e "discovery.type=single-node" \
  elasticsearch:7.17.0

# Kibana
docker run -p 5601:5601 kibana:7.17.0

# Filebeat（需配置文件）
docker run -v ./filebeat.yml:/filebeat.yml filebeat:7.17.0
```
