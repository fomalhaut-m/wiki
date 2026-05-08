# Java 集合体系

> 来源：Java集合笔记 | 标签：Java / 集合

---

## 集合框架图

```
Iterable
  └── Collection
        ├── List（有序、可重复）
        │     ├── ArrayList
        │     ├── LinkedList
        │     └── Vector
        ├── Set（无序、不可重复）
        │     ├── HashSet
        │     ├── LinkedHashSet
        │     └── TreeSet
        └── Queue（先进先出）
              └── LinkedList
```

---

## Collection 核心方法

| 方法 | 说明 |
|------|------|
| `add(E e)` | 添加元素 |
| `addAll(Collection)` | 添加一组元素 |
| `contains(Object)` | 包含（需equals支持） |
| `remove(Object)` | 删除（需equals支持） |
| `iterator()` | 返回迭代器 |
| `size()` | 元素数量 |
| `toArray()` | 转为数组 |

---

## List vs Set vs Queue

| 集合 | 特点 | 实现 |
|------|------|------|
| **List** | 有序、可重复 | ArrayList, LinkedList, Vector |
| **Set** | 无序、不可重复 | HashSet, TreeSet |
| **Queue** | 先进先出 | LinkedList |

---

## Map（独立体系）

```
Map
  ├── HashMap
  ├── LinkedHashMap
  ├── TreeMap
  └── Hashtable
```

---

## 选型建议

| 场景 | 推荐 |
|------|------|
| 高频随机访问 | ArrayList |
| 高频插入删除 | LinkedList |
| 需要线程安全 | Vector |
| 需要排序 | TreeSet |
| 需要去重且保持插入顺序 | LinkedHashSet |
| K-V键值对 | HashMap |

---

## Collections 工具类

| 方法 | 说明 |
|------|------|
| `Collections.EMPTY_LIST` | 空列表（不可变） |
| `Collections.EMPTY_MAP` | 空映射（不可变） |
| `Collections.EMPTY_SET` | 空集合（不可变） |
| `Collections.sort(list)` | 排序 |
| `Collections.reverse(list)` | 反转 |
| `Collections.shuffle(list)` | 洗牌 |
