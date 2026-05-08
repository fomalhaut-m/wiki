# OutOfMemoryError

## 常见 OOM 类型

## 1. Java heap space

堆内存溢出，最常见。

**原因：** 对象创建过多，堆无法容纳；内存泄漏。

```java
// 不断向集合中添加对象，不释放
List<byte[]> list = new ArrayList<>();
while (true) {
    list.add(new byte[1024 * 1024]);  // 1MB
}
```

**排查：**
```bash
# 导出堆转储
-XX:+HeapDumpOnOutOfMemoryError
-XX:HeapDumpPath=/tmp/java_heap.hprof

# 使用 MAT 分析
# https:// eclipse.org/mat/
```

## 2. Metaspace（元空间溢出）

JDK 8+ 使用**元空间**替代永久代，存储类信息。

**原因：** 动态生成大量类（如 CGLIB、Spring 字节码、JS 引擎、动态 JSP）；类加载器泄漏。

```java
// 不断创建新的类加载器加载类
while (true) {
    new MyClassLoader().loadClass("Class" + i++);
}
```

**解决：**
```properties
-XX:MetaspaceSize=256m -XX:MaxMetaspaceSize=512m
```

## 3. unable to create new native thread

线程数超系统限制。

**原因：** 线程创建过多；或栈内存过大（`-Xss`）。

```java
// 不断创建线程
while (true) {
    new Thread(() -> {
        try { Thread.sleep(Long.MAX_VALUE); } catch (InterruptedException e) {}
    }).start();
}
```

**解决：**
- 减少 `-Xss` 栈大小
- 使用线程池替代手动创建线程
- 调整 `ulimit -u` 系统限制

## 4. Direct buffer memory（NIO 常见）

直接内存（堆外内存）溢出。

**原因：** 使用 NIO direct buffer 过多；ByteBuffer.allocateDirect() 未释放。

```java
// 不断分配直接内存
while (true) {
    ByteBuffer.allocateDirect(1024 * 1024);
}
```

**解决：**
- 检查是否正确释放 ByteBuffer
- 限制直接内存大小：`-XX:MaxDirectMemorySize=256m`

## 5. GC overhead limit exceeded

GC 花费时间超过 98%，回收不到 2% 堆内存。

**原因：** 内存持续不足；频繁 Full GC。

**解决：** 增加堆内存、修复内存泄漏。

## 排查工具

| 工具 | 用途 |
|------|------|
| `jps` | 查看 Java 进程 |
| `jstack <pid>` | 线程堆栈，死锁定位 |
| `jmap -heap <pid>` | 堆内存使用情况 |
| `jmap -dump:format=b,file=heap.hprof <pid>` | 导出堆转储 |
| `jhat heap.hprof` | 分析堆转储（简单） |
| MAT / VisualVM / JProfiler | 可视化分析 |
| `arthas` | 阿里诊断工具 |
