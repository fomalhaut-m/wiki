# Java 原子操作类

> 来源：JUC原子类笔记 | 标签：Java / 并发 / JUC

---

## 原子类分类

| 类别 | 类型 |
|------|------|
| **基础类型** | AtomicInteger, AtomicLong, AtomicBoolean |
| **数组类型** | AtomicIntegerArray, AtomicLongArray, AtomicReferenceArray |
| **引用类型** | AtomicReference, AtomicMarkableReference, AtomicStampedReference |
| **字段更新器** | AtomicIntegerFieldUpdater, AtomicLongFieldUpdater, AtomicReferenceFieldUpdater |

---

## 核心原理：CAS

CAS（Compare-And-Swap）通过循环重试实现原子操作：

```java
// Unsafe底层
compareAndSwapInt(Object o, long offset, int expected, int x)
```

```java
// AtomicInteger addAndGet 循环CAS实现
public final int getAndAddInt(Object o, long offset, int delta) {
    int v;
    do {
        v = getIntVolatile(o, offset);  // 获取当前值
    } while (!weakCompareAndSetInt(o, offset, v, v + delta));  // CAS重试
    return v;
}
```

---

## 基础原子类

```java
AtomicInteger atomicInteger = new AtomicInteger();

atomicInteger.addAndGet(1);
atomicInteger.compareAndSet(0, 2);  // CAS操作
```

---

## AtomicReference 引用类型

```java
AtomicReference<Book> ref = new AtomicReference<>(book);

// CAS修改引用
ref.compareAndSet(oldBook, newBook);
```

### ABA问题

> A线程修改为B，B线程修改回A，CAS会成功但实际已被修改过。

**解决**：使用带版本号的 AtomicStampedReference：

```java
AtomicStampedReference<Book> asr =
    new AtomicStampedReference<>(book, 1);

// 修改时比对版本号
asr.compareAndSet(book, newBook, stamp, stamp + 1);
```

---

## 字段更新器

> 注意：字段必须用 `volatile` 修饰！

```java
public class Book {
    private String name;
    private volatile long price;  // 必须volatile
}

AtomicLongFieldUpdater<Book> updater =
    AtomicLongFieldUpdater.newUpdater(Book.class, "price");

updater.set(book, 99L);  // 原子修改
```

---

## LongAdder（高性能计数）

比 AtomicLong 性能更高，适用于高并发场景：

```java
LongAdder adder = new LongAdder();
adder.add(1);
adder.increment();
long sum = adder.sum();
```

> 原理：分段 CAS，多个累加单元竞争，减少冲突
