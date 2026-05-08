# Java 线程池

> 来源：线程池笔记 | 标签：Java / 并发 / 线程池

---

## 线程池三大优势

| 优势 | 说明 |
|------|------|
| **降低资源消耗** | 复用已有线程，避免创建/销毁开销 |
| **提高响应速度** | 任务无需等待线程创建 |
| **提高可管理性** | 统一分配、调优、监控 |

---

## 三种创建方式

| 方法 | 特点 | 队列 |
|------|------|------|
| `newFixedThreadPool(n)` | 固定n个线程 | LinkedBlockingQueue |
| `newSingleThreadExecutor()` | 单线程 | LinkedBlockingQueue |
| `newCachedThreadPool()` | 弹性扩张 | SynchronousQueue |

###阿里巴巴规范

> **强制**：不允许使用`Executors`创建，必须用`ThreadPoolExecutor`，避免OOM。

---

## ThreadPoolExecutor 七大参数

```java
new ThreadPoolExecutor(
    int corePoolSize,          // 核心线程数
    int maximumPoolSize,       // 最大线程数
    long keepAliveTime,         // 空闲线程存活时间
    TimeUnit unit,              // 时间单位
    BlockingQueue<Runnable> workQueue,  // 任务队列
    ThreadFactory threadFactory,// 线程工厂
    RejectedExecutionHandler handler    // 拒绝策略
);
```

---

## 工作原理

```
任务进来 → 判断核心线程数 → 放入队列 → 判断最大线程数 → 启动拒绝策略
```

1. 线程数 < corePoolSize → 直接创建核心线程运行
2. 线程数 >= corePoolSize → 放入队列
3. 队列满 且 线程数 < maximumPoolSize → 创建非核心线程运行
4. 队列满 且 线程数 >= maximumPoolSize → 启动拒绝策略

---

## 四种拒绝策略

| 策略 | 行为 |
|------|------|
| **AbortPolicy**（默认） | 抛异常 |
| **CallerRunsPolicy** | 退回给调用者 |
| **DiscardOldestPolicy** | 丢弃队列中最久的任务 |
| **DiscardPolicy** | 直接丢弃 |

---

## 合理配置线程池

```java
int CPU核数 = Runtime.getRuntime().availableProcessors();
```

| 类型 | 配置公式 |
|------|----------|
| **CPU密集型** | CPU核数 + 1 |
| **IO密集型** | CPU核数 × 2 |
| **IO密集型（通用）** | CPU核数 / (1 - 阻塞系数)，阻塞系数≈0.8~0.9 |

---

## 自定义线程池示例

```java
ExecutorService threadPool = new ThreadPoolExecutor(
    2, 5, 5L, TimeUnit.SECONDS,
    new LinkedBlockingQueue<>(3),
    Executors.defaultThreadFactory(),
    new ThreadPoolExecutor.AbortPolicy()
);
```
