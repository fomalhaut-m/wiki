# Redis 事务

> 来源：Redis笔记 | 标签：数据库 / Redis

---

## 事务命令

| 命令 | 说明 |
|------|------|
| `MULTI` | 标记事务开始 |
| `EXEC` | 执行所有事务块内命令 |
| `DISCARD` | 取消事务，放弃所有命令 |
| `WATCH key [key...]` | 监视key，事务前被修改则打断 |
| `UNWATCH` | 取消所有key监视 |

---

## 使用流程

```
MULTI  →  命令入队  →  EXEC  →  执行
```

```redis
MULTI
INCR user_id
INCR user_id
SET name "luke"
EXEC
```

---

## 特性

### 隔离操作
- 事务中的所有命令都会序列化、按顺序执行
- 不会被其他客户端命令打断

### 无隔离级别
- 命令在提交前不会实际执行
- 不存在"脏读"问题（因为根本没执行）

### 不保证原子性
- 如果一条命令失败，**不会回滚**
- 其后的命令仍然会执行

---

## WATCH 监视

```redis
WATCH lock lock_times
MULTI
SET lock "luke"
INCR lock_times
EXEC
```

- 如果被监视的key在事务执行前被其他命令修改，事务**被打断**（返回nil）
- 用于实现乐观锁

---

## 典型场景

### 乐观锁（CAS）
```redis
WATCH balance
GET balance
MULTI
DECRBY balance 100
EXEC
```

### 取消事务
```redis
MULTI
SET name "luke"
DISCARD   # 放弃所有命令
```
