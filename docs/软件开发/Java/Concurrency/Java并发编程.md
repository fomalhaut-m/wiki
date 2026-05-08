# Java 并发编程

> 来源：JDK并发包笔记 | 标签：Java / 并发

---

## ReentrantLock vs synchronized

| 特性 | ReentrantLock | synchronized |
|------|---------------|--------------|
| 性能 | 差不多（JDK优化后） | 差不多 |
| 可重入 | ✅ | ✅ |
| 可中断 | ✅（lockInterruptibly） | ❌ |
| 可限时 | ✅（tryLock） | ❌ |
| 公平锁 | ✅（构造参数） | ❌ |
| 功能丰富度 | 更强 | 简单交给JVM |

### 基本用法

```java
ReentrantLock lock = new ReentrantLock();
lock.lock();
try {
    // 临界区
} finally {
    lock.unlock(); // 必须finally释放
}
```

### 可重入

```java
lock.lock();
lock.lock(); // 可反复获取同一把锁
try {
    i++;
} finally {
    lock.unlock();
    lock.unlock(); // 需要释放同样次数
}
```

### 可中断（死锁处理）

```java
lock1.lockInterruptibly();
try {
    // 可响应中断跳出
} finally {
    lock1.unlock();
}
```

### 可限时

```java
if (lock.tryLock(5, TimeUnit.SECONDS)) {
    // 5秒内获取到锁
} else {
    // 获取失败
}
```

### 公平锁

```java
ReentrantLock fairLock = new ReentrantLock(true); // 公平锁
```

---

## Condition（await/signal）

与 `Object.wait()/signal()` 类似，但配合ReentrantLock使用：

```java
Lock lock = new ReentrantLock();
Condition condition = lock.newCondition();

condition.await();      // 等待
condition.signal();     // 唤醒一个
condition.signalAll();  // 唤醒全部
```

---

## Semaphore（共享锁）

限制定时段可进入临界区的线程数：

```java
Semaphore semaphore = new Semaphore(5);
semaphore.acquire();    // 获取许可
try {
    // 临界区
} finally {
    semaphore.release(); // 释放许可
}
```

---

## ReadWriteLock（读写锁）

- 读-读不互斥
- 读-写互斥
- 写-写互斥

```java
ReentrantReadWriteLock rwLock = new ReentrantReadWriteLock();
Lock readLock = rwLock.readLock();
Lock writeLock = rwLock.writeLock();
```

---

## CountDownLatch（倒数计数）

等待N个线程完成后主线程再继续：

```java
CountDownLatch end = new CountDownLatch(10);
end.countDown();  // 每个线程完成时调用
end.await();      // 主线程等待
```

---

## CyclicBarrier（循环栅栏）

N个线程互相等待，全部到齐后执行动作，然后可重复使用：

```java
CyclicBarrier barrier = new CyclicBarrier(10, () -> {
    // 所有线程到齐后执行
});
barrier.await(); // 等待其他线程
```

---

## LockSupport（线程阻塞原语）

比 `suspend/resume` 更安全，不会引起线程冻结：

```java
LockSupport.park();      // 阻塞当前线程
LockSupport.unpark(t);  // 唤醒线程t
```

---

## ConcurrentHashMap

分段锁实现，高并发下优于 `synchronizedMap`：

```java
ConcurrentHashMap<String, Object> map = new ConcurrentHashMap<>();
map.put("key", "value");
```

---

## BlockingQueue（阻塞队列）

典型的生产者-消费者实现：

```java
BlockingQueue<Integer> queue = new LinkedBlockingQueue<>(10);
queue.put(1);    // 阻塞直到队列有空位
queue.take();    // 阻塞直到队列有元素
```
