# MySQL 快速上手

> 来源：个人笔记整理 | 标签：数据库 / MySQL

---

## 架构

```
连接层 → 服务层 → 引擎层 → 存储层
```

### 服务层
- SQL接口、缓存查询
- SQL分析、优化、解析
- 跨存储引擎功能

### 引擎层

| 对比项 | MyISAM | InnoDB |
|--------|--------|--------|
| 主外键 | 不支持 | 支持 |
| 事务 | 不支持 | 支持 |
| 行锁/表锁 | 表锁，不适合高并发 | 行锁，适合高并发 |
| 缓存 | 只缓存索引 | 索引+真实数据 |
| 默认安装 | Y | Y |

**选择：InnoDB（事务支持、行锁、高并发）**

---

## 索引

### 本质
索引是**排好序的快速查找数据结构**，可以理解为B+树。

### 优势
- 提高检索效率
- 降低数据库IO成本
- 降低排序CPU消耗

### 劣势
- 占用磁盘空间
- 更新表速度变慢

### 分类

| 类型 | 说明 |
|------|------|
| 单值索引 | 单个列 |
| 唯一索引 | 值唯一，允许空 |
| 复合索引 | 多个列 |
| 主键索引 | 主键，自动唯一 |

### 语法

```sql
-- 创建
CREATE INDEX idx_name ON table_name(col_name);

-- 删除
DROP INDEX idx_name ON table_name;

-- 查看
SHOW INDEX FROM table_name;
```

---

## Explain 执行计划

```sql
EXPLAIN SELECT * FROM table WHERE id = 1;
```

| 字段 | 说明 |
|------|------|
| type | 访问类型（system > const > ref > range > all） |
| key | 实际使用的索引 |
| rows | 扫描行数 |
| Extra | 优化提示（Using index/Using filesort） |

**最好达到 range，避免 all**

---

## 慢查询优化

1. **分析SQL**：查看执行计划
2. **减少笛卡尔积**：多表连接注意关联条件
3. **避免全表扫描**：建立索引、避免 `!=`、`NULL` 判断
4. **避免 filesort**：`ORDER BY` 要利用索引
