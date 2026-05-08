# SQL 查询总结

> 来源：SQL笔记 | 标签：数据库 / SQL

---

## 基础操作

```sql
USE 数据库名称;           -- 选择数据库
SET NAMES utf8;          -- 设置字符集
SELECT * FROM 表名;       -- 查询数据
```

> SQL 对大小写不敏感（SELECT = select）

---

## 连接查询

### 内连接（笛卡尔积）

```sql
-- 无条件（笛卡尔积）
SELECT 列名 FROM 表1, 表2;

-- 有条件
SELECT 列名 FROM 表1, 表2 WHERE 连接条件 AND 其他条件;
```

### INNER JOIN

```sql
SELECT 列名 FROM 表1 INNER JOIN 表2 ON 条件 WHERE 其他条件;
```

### 外连接

```sql
-- 左外连接
SELECT * FROM 左表 LEFT OUTER JOIN 右表 ON 条件;

-- 右外连接
SELECT * FROM 左表 RIGHT OUTER JOIN 右表 ON 条件;

-- Oracle特有写法
SELECT * FROM 表1, 表2 WHERE 表1.列(+) = 表2.列;
```

### 完全外连接

```sql
SELECT * FROM 表1 FULL OUTER JOIN 表2 ON 条件;
```

### 特殊连接

```sql
-- 笛卡尔积（cross join + where）
SELECT * FROM 表1 CROSS JOIN 表2 WHERE 条件;

-- 自然连接（自动匹配同名列）
SELECT * FROM 表1 NATURAL JOIN 表2;

-- using子句（指定等值字段）
SELECT * FROM 表1 JOIN 表2 USING(列名);
```

---

## DDL 常用语句

| 语句 | 说明 |
|------|------|
| `CREATE DATABASE` | 创建数据库 |
| `ALTER DATABASE` | 修改数据库 |
| `CREATE TABLE` | 创建表 |
| `ALTER TABLE` | 变更表结构 |
| `DROP TABLE` | 删除表 |
| `CREATE INDEX` | 创建索引 |
| `DROP INDEX` | 删除索引 |

## DML 常用语句

| 语句 | 说明 |
|------|------|
| `SELECT` | 查询 |
| `INSERT INTO` | 插入 |
| `UPDATE` | 更新 |
| `DELETE` | 删除 |

---

## SQL执行顺序

```sql
SELECT DISTINCT    -- 5. 去重
FROM              -- 1. 确定表
JOIN ON           -- 2. 连接
WHERE             -- 3. 过滤
GROUP BY          -- 4. 分组
HAVING            -- 6. 条件过滤
ORDER BY          -- 7. 排序
LIMIT             -- 8. 限制
```
