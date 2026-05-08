# JVM 与 GC

## JVM 内存区域

```
线程共享：
  ├─ 堆（Heap）：对象实例、数组
  └─ 方法区（Method Area）：类信息、常量、静态变量、JIT 编译代码

线程私有：
  ├─ 虚拟机栈（VM Stack）：方法调用、局部变量
  ├─ 本地方法栈（Native Stack）：Native 方法
  └─ 程序计数器（PC Register）：当前指令地址
```

### 堆内存

```
年轻代（Young Gen）
  ├─ Eden 区（伊甸园）
  └─ Survivor 区（S0 / S1，各 1:1）

老年代（Old Gen / Tenured Gen）
```

| 参数 | 说明 |
|------|------|
| `-Xms` | 堆最小值 |
| `-Xmx` | 堆最大值 |
| `-Xmn` | 年轻代大小 |
| `-XX:SurvivorRatio=8` | Eden:S0:S1 = 8:1:1 |

**对象分配流程：**
1. 优先在 Eden 分配
2. 大对象直接进老年代（`-XX:PretenureSizeThreshold`）
3. 长期存活对象进入老年代（`-XX:MaxTenuringThreshold`，默认 15）

## 垃圾回收算法

### 标记-清除（Mark-Sweep）

先标记所有存活对象，再清除未标记的。**缺点：产生内存碎片**。

### 复制（Coping）

把存活对象复制到另一块空区，整体清空原区。**缺点：可用内存减半**。年轻代 Minor GC 用此算法。

### 标记-整理（Mark-Compact）

标记存活对象后，**把存活对象向一端移动**，消除内存碎片。老年代常用。

### 分代收集

| 代 | GC 类型 | 算法 |
|----|---------|------|
| 年轻代 | Minor GC | 复制 |
| 老年代 | Major GC / Full GC | 标记-整理 |

## 垃圾收集器

### 常见组合

| 组合 | 新生代 | 老年代 |
|------|--------|--------|
| Serial + Serial Old | Serial | Serial Old（单线程） |
| ParNew + CMS | ParNew（多线程） | CMS（并发标记清除） |
| Parallel Scavenge + Parallel Old | Parallel（吞吐量优先） | Parallel Old |
| G1 | G1（Region，分代回收） | G1 |

### CMS（Concurrent Mark Sweep）

**四阶段：**
1. 初始标记（STW）- 标记 GC Root 直接引用的对象
2. 并发标记 - 追踪存活对象（不停顿）
3. 重新标记（STW）- 修正并发期间产生的变化
4. 并发清除 - 清除垃圾（不停顿）

**优点：** 并发收集、低停顿  
**缺点：** 产生内存碎片、对 CPU 敏感、浮动垃圾

### G1（Garbage First）

把堆划分为大小相等的 **Region**，跟踪各 Region 的垃圾量，优先回收垃圾最多的 Region。

**适合大堆（> 4GB）**，目标：**可预测停顿时间**。

### ZGC / Shenandoah

低延迟 GC，停顿时间 < 10ms，支持 TB 级堆。

## JVM 参数

| 参数 | 说明 |
|------|------|
| `-Xms512m -Xmx512m` | 堆大小固定 |
| `-XX:+UseG1GC` | 使用 G1 |
| `-XX:MaxGCPauseMillis=200` | 最大 GC 停顿时间 |
| `-XX:+HeapDumpOnOutOfMemoryError` | OOM 时导出堆转储 |
| `-XX:HeapDumpPath=./java_pid.hprof` | 堆转储路径 |
| `-Xss1m` | 栈大小 |

## 常见 OOM

- `java.lang.OutOfMemoryError: Java heap space` — 堆溢出
- `java.lang.OutOfMemoryError: Metaspace` — 元空间溢出
- `java.lang.OutOfMemoryError: unable to create new native thread` — 线程超限
- `java.lang.OutOfMemoryError: Direct buffer memory` — 直接内存溢出
