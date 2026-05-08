# Java List 集合

> 来源：Java集合笔记 | 标签：Java / 集合

---

## 三大实现对比

| 特性 | ArrayList | LinkedList | Vector |
|------|-----------|------------|--------|
| 底层结构 | 动态数组 | 双向链表 | 动态数组 |
| 线程安全 | 不安全 | 不安全 | 线程安全（synchronized） |
| 随机访问 | O(1) 快速 | O(n) 慢 | O(1) |
| 插入/删除 | O(n) | O(1) | O(n) |
| 扩容机制 | 1.5倍 | 无需扩容 | 2倍 |

---

## ArrayList 特点

- 底层是**动态数组**
- 默认容量10，扩容1.5倍
- 高频随机访问性能优秀
- JDK 1.8之后懒加载：第一次add时才创建容量

```java
// 空参构造（懒加载）
public ArrayList() {
    this.elementData = DEFAULTCAPACITY_EMPTY_ELEMENTDATA;
}
```

---

## LinkedList 特点

- 底层是**双向链表**
- 头尾操作O(1)
- 不需要扩容
- 也可用作栈、队列、双端队列

```java
// 作为栈使用
linkedList.push(element);
linkedList.pop();

// 作为队列使用
linkedList.offer(element);
linkedList.poll();
```

---

## Vector 特点

- 线程安全（方法都加了synchronized）
- 扩容2倍
- 被ArrayList替代，仅在需要线程安全时使用

---

## 选型建议

| 场景 | 推荐 |
|------|------|
| 高频随机访问 | ArrayList |
| 高频插入删除 | LinkedList |
| 需要线程安全 | Vector 或 `Collections.synchronizedList()` |
| 作为栈/队列 | LinkedList |

---

## List 特有方法

```java
list.add(index, element);      // 指定位置插入
list.get(index);               // 获取指定位置元素
list.indexOf(obj);             // 查找元素位置
list.listIterator();           // 获取List迭代器
```
