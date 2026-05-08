# MySQL Explain 分析

> 来源：MySQL高级笔记 | 标签：数据库 / MySQL / 优化

---

## 作用

使用 `EXPLAIN` 模拟优化器执行SQL，分析性能瓶颈：

```sql
EXPLAIN SELECT * FROM table_name WHERE ...
```

---

## 关键字段

| 字段 | 说明 |
|------|------|
| **id** | 执行顺序，优先级高的先执行 |
| **select_type** | 查询类型 |
| **table** | 表名 |
| **type** | 访问类型 |
| **possible_keys** | 可能使用的索引 |
| **key** | 实际使用的索引 |
| **key_len** | 索引长度 |
| **rows** | 预估扫描行数 |
| **Extra** | 额外信息 |

---

## id 执行顺序

| 情况 | 说明 |
|------|------|
| id相同 | 从上往下顺序执行 |
| id不同 | 值越大优先级越高 |
| id相同又不同 | 相同为一组，组内顺序；越大越先执行 |

---

## select_type 查询类型

| 类型 | 说明 |
|------|------|
| **SIMPLE** | 简单SELECT，不含子查询/UNION |
| **PRIMARY** | 复杂查询的最外层 |
| **SUBQUERY** | 子查询 |
| **DERIVED** | 衍生表（FROM子句的子查询） |
| **UNION** | UNION查询 |
| **UNION RESULT** | UNION结果 |

---

## type 访问类型（从好到差）

| 类型 | 说明 |
|------|------|
| **system** | 系统表，只有一行 |
| **const** | 主键或唯一索引，最多一行匹配 |
| **eq_ref** | 唯一性索引扫描 |
| **ref** | 非唯一索引扫描 |
| **range** | 索引范围扫描 |
| **index** | 全索引扫描 |
| **ALL** | 全表扫描（最差） |

---

## Extra 重要信息

| 信息 | 说明 |
|------|------|
| **Using index** | 覆盖索引，性能好 |
| **Using where** | WHERE条件过滤 |
| **Using temporary** | 临时表，查询需优化 |
| **Using filesort** | 文件排序，无法用索引，需优化 |
| **Using join buffer** | 使用了连接缓存 |
| **Impossible WHERE** | WHERE永远为false |

---

## 优化目标

- `type` 至少达到 **range**
- `key` 必须有值
- `rows` 越少越好
- `Extra` 避免 `Using filesort` 和 `Using temporary`
