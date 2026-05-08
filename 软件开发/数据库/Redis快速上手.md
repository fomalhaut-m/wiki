# Redis 快速上手

> 来源：个人笔记整理 | 标签：数据库 / Redis

---

## 简介

Redis（Remote Dictionary Server）是高性能的 key-value 数据库。

### 三大特点

1. **支持数据持久化** — 内存数据保存到磁盘，重启可再次加载
2. **支持多种数据结构** — string、list、set、zset、hash
3. **支持数据备份** — master-slave 模式

### 优势

| 优势 | 说明 |
|------|------|
| 性能极高 | 读 110000次/s，写 81000次/s |
| 丰富数据类型 | Strings、Lists、Hashes、Sets、Ordered Sets |
| 原子性 | 单操作原子性，支持事务（MULTI/EXEC） |
| 丰富特性 | 发布订阅、key过期、计数器等 |

---

## 能做什么

1. **内存存储和持久化**：异步持久化，不影响继续服务
2. **取最新N个数据**：如最新10条评论ID
3. **模拟HttpSession**：需要过期时间的功能
4. **发布/订阅消息系统**
5. **定时器、计数器**

---

## 数据类型

### String（字符串）
```
SET key value
GET key
```

### List（列表）
```
LPUSH mylist value1
LRANGE mylist 0 -1
```

### Set（集合）
```
SADD myset value1 value2
SMEMBERS myset
```

### Hash（哈希）
```
HSET myhash field1 value1
HGET myhash field1
```

### Zset（有序集合）
```
ZADD myzset 1 one 2 two
ZRANGE myzset 0 -1
```

---

## 持久化

### RDB（Redis DataBase）
- 定时生成数据快照
- 适合大规模数据恢复
- 可能丢失最近数据

### AOF（Append Only File）
- 记录每个写操作
- 数据完整性更高
- 文件较大，恢复慢

**建议：结合使用**

---

## 常见配置

```conf
# 绑定IP
bind 127.0.0.1
# 端口
port 6379
# 密码
requirepass yourpassword
# 最大内存
maxmemory 2gb
# 持久化策略
appendonly yes
appendfsync everysec
```

---

## 应用场景

| 场景 | 说明 |
|------|------|
| 缓存 | 热数据加速访问 |
| 会话存储 | 用户登录状态 |
| 分布式锁 | Redis实现分布式锁 |
| 排行榜 | Zset实现 |
| 消息队列 | List实现 |
