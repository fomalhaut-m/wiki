# MySQL 索引详解

> 来源：MySQL高级笔记 | 标签：数据库 / MySQL / 索引

---

## 什么是索引

索引是**帮助MySQL高效获取数据的数据结构**。本质是排好序的快速查找数据结构。

> 数据本身之外，数据库还维护着满足特定查找算法的数据结构，这种数据结构以某种方式指向数据，这种数据结构就是索引。

除了B+树索引，还有哈希索引、全文索引、R-Tree索引等。

---

## 优势与劣势

| 优势 | 劣势 |
|------|------|
| 提高检索效率，降低IO成本 | 索引占用磁盘空间 |
| 降低排序CPU消耗 | 降低更新表速度（insert/update/delete） |

---

## 索引分类

| 类型 | 说明 |
|------|------|
| **单值索引** | 一个索引只包含单个列 |
| **唯一索引** | 索引列值必须唯一，允许空值 |
| **复合索引** | 一个索引包含多个列 |
| **全文索引** | 全文检索 |

---

## 基本语法

```sql
-- 创建索引
CREATE [UNIQUE] INDEX index_name ON table_name (column_name(length));
ALTER TABLE table_name ADD [UNIQUE] INDEX index_name ON (column_name(length));

-- 删除索引
DROP INDEX [index_name] ON table_name;

-- 查看索引
SHOW INDEX FROM table_name;

-- 修改索引
ALTER TABLE table_name ADD PRIMARY KEY (column_name);          -- 主键索引
ALTER TABLE table_name ADD UNIQUE INDEX index_name (column_name);  -- 唯一索引
ALTER TABLE table_name ADD INDEX index_name (column_name);     -- 普通索引
ALTER TABLE table_name ADD FULLTEXT INDEX index_name (column_name); -- 全文索引
```

---

## B+树索引原理

B+树查找过程（以3层B+树为例）：

1. 第一次IO：把根节点加载到内存，用二分法确定目标在某个子节点
2. 第二次IO：通过指针加载子节点，重复查找
3. 第三次IO：找到最终数据

> 3层B+树可表示上百万数据，仅需3次IO。没有索引则需要百万次IO。

---

## 何时使用索引

1. 主键自动建立唯一索引
2. 频繁作为查询条件的字段
3. 外键关联字段
4. 排序字段（通过索引访问可提高排序速度）
5. 分组或统计字段
6. 高并发时倾向使用组合索引

## 不使用索引

1. 表记录太少（300万以上性能下降）
2. 经常增删改的字段
3. 索引值重复率接近1（即区分度低）

---

## Explain 分析

使用 `EXPLAIN` 查看SQL执行计划：

```sql
EXPLAIN SELECT * FROM table_name WHERE ...
```

关键字段：
- **type**：访问类型（const, ref, range, all 等）
- **key**：实际使用的索引
- **rows**：预计扫描的行数
- **Extra**：额外信息（Using index, Using filesort 等）
