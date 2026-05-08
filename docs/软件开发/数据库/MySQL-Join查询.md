# MySQL 七种Join查询

> 来源：MySQL高级笔记 | 标签：数据库 / MySQL / SQL

---

## SQL执行顺序

### 手写顺序
```sql
SELECT → DISTINCT → FROM → JOIN → ON → WHERE → GROUP BY → HAVING → ORDER BY → LIMIT
```

### 机读顺序
```sql
FROM → ON → JOIN → WHERE → GROUP BY → HAVING → SELECT → DISTINCT → ORDER BY → LIMIT
```

---

## 七种Join图解

```
Table A        Table B
   ┌────┐        ┌────┐
   │ 1  │        │ 2  │
   │ 2  │        │ 3  │
   │ 3  │        │ 4  │
   └────┘        └────┘
```

| Join类型 | 说明 | 结果 |
|----------|------|------|
| **INNER JOIN** | 交集 | 2, 3 |
| **LEFT JOIN** | A全部 + B交集 | 1, 2, 3 |
| **RIGHT JOIN** | B全部 + A交集 | 2, 3, 4 |
| **LEFT JOIN ... WHERE B IS NULL** | A独有 | 1 |
| **RIGHT JOIN ... WHERE A IS NULL** | B独有 | 4 |
| **FULL OUTER JOIN** | A∪B | 1, 2, 3, 4 |
| **FULL OUTER JOIN ... WHERE** | A∪B去交集 | 1, 4 |

---

## 七种SQL

```sql
-- 1. 内连接（交集）
SELECT * FROM A INNER JOIN B ON A.key = B.key;

-- 2. 左连接（A全部）
SELECT * FROM A LEFT JOIN B ON A.key = B.key;

-- 3. 右连接（B全部）
SELECT * FROM A RIGHT JOIN B ON B.key = B.key;

-- 4. A独有
SELECT * FROM A LEFT JOIN B ON A.key = B.key WHERE B.key IS NULL;

-- 5. B独有
SELECT * FROM A RIGHT JOIN B ON A.key = B.key WHERE A.key IS NULL;

-- 6. 全连接（A∪B）
SELECT * FROM A FULL OUTER JOIN B ON A.key = B.key;

-- 7. 去交集（A独有 + B独有）
SELECT * FROM A FULL OUTER JOIN B ON A.key = B.key
WHERE A.key IS NULL OR B.key IS NULL;
```

---

## 性能优化建议

| 问题 | 原因 | 解决 |
|------|------|------|
| SQL慢 | 查询语句不佳 | 优化SQL |
| 索引失效 | 单值/复合索引问题 | 检查索引使用 |
| 关联查询多 | 表设计问题 | 减少JOIN |
| 等待时间长 | 锁竞争 | 检查并发 |

---

## 索引失效情况

1. **单值索引**：只用一个字段建立索引
2. **复合索引**：两个以上字段建立索引，但未遵循最左前缀原则
3. **失效场景**：使用函数、LIKE以%开头、OR前后不同类型等
