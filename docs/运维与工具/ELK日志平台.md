# ELK 日志平台

> 来源：ELK笔记 | 标签：运维 / 日志 / Elasticsearch

---

## 为什么需要 ELK

日志分析痛点：
- 日志量太大难以归档
- 文本搜索太慢
- 多维度查询困难

> ELK = Elasticsearch + Logstash + Kibana，开源一站式日志解决方案

---

## 组件介绍

| 组件 | 作用 |
|------|------|
| **Filebeat** | 轻量级日志收集 Agent，占用资源少 |
| **Logstash** | 日志搜集、分析、过滤（c/s架构） |
| **Elasticsearch** | 分布式搜索引擎，提供存储、分析、搜索 |
| **Kibana** | Web界面，日志分析友好 |

---

## Filebeat（Beats家族）

Beats 包含四种工具：

| 工具 | 说明 |
|------|------|
| **Filebeat** | 搜集文件数据 |
| **Packetbeat** | 搜集网络流量 |
| **Topbeat** | 搜集系统/进程/CPU/内存 |
| **Winlogbeat** | 搜集Windows事件日志 |

---

## ELK 工作流程

```
日志文件 → Filebeat → Logstash（过滤/修改） → Elasticsearch → Kibana
                                                        ↓
                                              存储 + 分析 + 搜索
```

---

## Elasticsearch 特点

- 分布式，零配置
- 自动发现
- 索引自动分片
- 索引副本机制
- RESTful 风格接口
- 多数据源支持

---

## Kibana 作用

- 汇总、分析、搜索重要日志数据
- 提供可视化 Web 界面
- 与 Elasticsearch 无缝衔接

---

## 官方文档

| 组件 | 链接 |
|------|------|
| Filebeat | https://www.elastic.co/cn/products/beats/filebeat |
| Logstash | https://www.elastic.co/cn/products/logstash |
| Kibana | https://www.elastic.co/cn/products/kibana |
| Elasticsearch | https://www.elastic.co/cn/products/elasticsearch |

中文社区：https://elasticsearch.cn/
