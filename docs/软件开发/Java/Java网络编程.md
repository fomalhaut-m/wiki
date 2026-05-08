# Java 网络编程

> 来源：Java网络编程笔记 | 标签：Java / 网络

---

## 两种开发模式

| 模式 | 说明 | 安全性 | 维护成本 |
|------|------|--------|----------|
| **C/S** | 开发客户端+服务端两套程序 | 高 | 高 |
| **B/S** | 只开发服务端，客户端用浏览器 | 低 | 低 |

---

## TCP 编程

### 核心类

| 类 | 说明 |
|------|------|
| **Socket** | 客户端连接 |
| **ServerSocket** | 服务端监听 |

### 客户端

```java
Socket socket = new Socket("127.0.0.1", 9999);
Scanner scanner = new Scanner(socket.getInputStream());
while (scanner.hasNext()) {
    System.out.println(scanner.nextLine());
}
```

### 服务端

```java
ServerSocket server = new ServerSocket(9999);
Socket client = server.accept();  // 等待连接
PrintStream out = new PrintStream(client.getOutputStream());
out.print("Hello World");
```

---

## TCP 多线程服务端

```java
ServerSocket server = new ServerSocket(9999);
while (true) {
    Socket socket = server.accept();
    new Thread(new ClientThread(socket)).start();  // 每个客户端一个线程
}
```

---

## UDP 编程

UDP特点：**不可靠连接**，但比TCP节约资源。

### 核心类

| 类 | 说明 |
|------|------|
| **DatagramPacket** | 数据包 |
| **DatagramSocket** | 数据包套接字 |

### 接收方

```java
DatagramSocket socket = new DatagramSocket(9999);
byte[] data = new byte[1024];
DatagramPacket packet = new DatagramPacket(data, data.length);
socket.receive(packet);  // 阻塞等待
System.out.println(new String(data));
```

### 发送方

```java
DatagramSocket socket = new DatagramSocket();
String msg = "Hello";
DatagramPacket packet = new DatagramPacket(
    msg.getBytes(), msg.length(),
    InetAddress.getLocalHost(), 9999
);
socket.send(packet);
```

---

## TCP vs UDP

| 对比 | TCP | UDP |
|------|-----|-----|
| 连接 | 面向连接（三次握手） | 无连接 |
| 可靠性 | 可靠 | 不可靠 |
| 速度 | 慢 | 快 |
| 资源 | 多 | 少 |
| 场景 | 文件传输、网页 | 视频、语音、游戏 |
