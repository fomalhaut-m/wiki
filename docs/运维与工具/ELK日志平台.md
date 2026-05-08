# ELK 日志平台

> 来源：个人笔记整理 | 标签：运维 / ELK

---

## 架构

```
Logstash/Beats → Elasticsearch → Kibana
```

| 组件 | 说明 |
|------|------|
| **Elasticsearch** | 分布式搜索引擎，存储和检索日志 |
| **Logstash** | 日志收集、处理、转发 |
| **Kibana** | 可视化界面 |
| **Beats** | 轻量级数据收集器 |

---

## Elastic Agent（推荐）

替代传统Filebeat、Metricbeat，轻量级采集器。

### 安装步骤

```bash
# Debian/Ubuntu
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor
echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list
sudo apt-get update && sudo apt-get install elastic-agent

# 注册
sudo elastic-agent install --fleet-server-url=https://fleet-server:8220 --enrollment-token=TOKEN --force
```

### 验证

```bash
sudo systemctl status elastic-agent
# Kibana Fleet页面确认 Agent状态 Online
```

---

## Kibana 配置

### Fleet模块流程

1. 创建策略（Policy）
2. 添加集成（如System日志）
3. 生成注册令牌
4. 目标服务器执行注册命令
5. 验证数据流入

### 常用查看

| 功能 | 说明 |
|------|------|
| **Discover** | 查看日志数据 |
| **Dashboard** | 预构建仪表板 |
| **Dev Tools** | 查询ES API |

---

## 常见问题

| 问题 | 解决 |
|------|------|
| Agent Offline | 检查网络、防火墙、日志 |
| 数据未显示 | 确认索引存在、验证ES连接 |
| SSL证书错误 | 复制CA证书或添加 `--insecure` |

---

## 参考命令

```bash
# 查看索引
GET /_cat/indices

# 查看Agent状态
sudo systemctl status elastic-agent

# 查看日志
sudo cat /var/log/elastic-agent/elastic-agent.log
```
