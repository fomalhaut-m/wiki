# Java NIO 入门

> 来源：NIO笔记 | 标签：Java / NIO / IO

---

## 传统IO vs NIO

| 特性 | 传统IO | NIO |
|------|--------|-----|
| 抽象 | 面向流（Stream） | 面向块（Buffer） |
| 阻塞 | 阻塞式 | 非阻塞式 |
| 线程模型 | 一个连接一个线程 | 多路复用 |

**NIO 把IO抽象成块**，块被读入内存后是 byte[]，一次可以读或写多个字节。

---

## 三大核心组件

### 1. Channel（通道）

用于源节点与目标节点的连接。Channel本身不存储数据，需要配合缓冲区传输。

**常见Channel类型：**
- FileChannel — 文件
- SocketChannel — TCP客户端
- ServerSocketChannel — TCP服务端
- DatagramChannel — UDP

### 2. Buffer（缓冲区）

负责数据的存取，本质是数组（byte[]、char[]、IntBuffer等）。

**创建缓冲区：**
```java
ByteBuffer buffer = ByteBuffer.allocate(1024);
```

**核心属性：**
- capacity — 容量
- position — 当前位置
- limit — 限制

**核心操作：**
```java
buffer.put(byte[]);   // 写入
buffer.flip();        // 切换读写
buffer.get();         // 读取
buffer.clear();       // 清空
```

### 3. Selector（选择器）

多路复用器，用于处理多个Channel的事件。

**工作流程：**
1. 注册Channel到Selector
2. 调用select()等待事件
3. 遍历就绪的SelectionKey处理事件

```java
Selector selector = Selector.open();
channel.register(selector, SelectionKey.OP_READ);
```

---

## NIO vs IO 对比

| 场景 | 传统IO | NIO |
|------|--------|-----|
| 连接数少 | 一个连接一个线程，浪费 | 线程更少，性能更好 |
| 连接数多 | 线程开销大 | 多路复用，性能好 |
| 适合 | 文件复制、流式处理 | 网络通信、并发连接 |

---

## 应用场景

- **NIO**：RPC框架（Dubbo）、Netty、Redis
- **传统IO**：文件流处理、简单的网络通信
