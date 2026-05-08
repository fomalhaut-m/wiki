# IO 与网络编程

## File 类

```java
File f = new File("C:/test.txt");

// 判断
f.exists()
f.isDirectory()
f.isFile()
f.canRead() / canWrite() / canExecute()

// 信息
f.length()       // 文件字节大小
f.lastModified() // 最后修改时间

// 操作
f.createNewFile()
f.mkdir()        // 创建单级目录
f.mkdirs()       // 创建多级目录
f.delete()       // 删除文件/空目录（非空删不掉）
f.renameTo(dest) // 重命名或移动
```

## IO 流分类

```
字节流：InputStream / OutputStream（处理图片/音频等二进制）
字符流：Reader / Writer（处理文本，自动编码转换）
```

### 字节流

```java
// 文件字节流
FileInputStream fis = new FileInputStream("a.txt");
FileOutputStream fos = new FileOutputStream("b.txt");

// 带缓冲的字节流（推荐）
BufferedInputStream bis = new BufferedInputStream(new FileInputStream("a.txt"));
BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream("b.txt"));

// 读取
byte[] buf = new byte[1024];
int len;
while ((len = bis.read(buf)) != -1) {
    bos.write(buf, 0, len);
}

// 关闭
bis.close();  // 关闭外层流即可
```

### 字符流

```java
// 字符输入流
FileReader fr = new FileReader("a.txt");
BufferedReader br = new BufferedReader(new FileReader("a.txt"));

// 字符输出流
FileWriter fw = new FileWriter("b.txt");
BufferedWriter bw = new BufferedWriter(new FileWriter("b.txt"));

// 读取一行
String line = br.readLine();
// 写入一行（不自动换行）
bw.newLine();  // 换行
bw.write(line);
```

### 转换流

```java
// 字节流 → 字符流（指定编码）
InputStreamReader isr = new InputStreamReader(
    new FileInputStream("a.txt"), "UTF-8");
OutputStreamWriter osw = new OutputStreamWriter(
    new FileOutputStream("b.txt"), "GBK");
```

## 序列化

把对象转成字节流，可传输或持久化。

### 序列化接口

```java
public class User implements Serializable {
    private static final long serialVersionUID = 1L;
    private String name;
    private int age;
    // transient 修饰的字段不序列化
    private transient String password;
}
```

### 序列化/反序列化

```java
// 序列化
ObjectOutputStream oos = new ObjectOutputStream(
    new FileOutputStream("user.obj"));
oos.writeObject(user);
oos.close();

// 反序列化
ObjectInputStream ois = new ObjectInputStream(
    new FileInputStream("user.obj"));
User u = (User) ois.readObject();
ois.close();
```

**注意：**
- `serialVersionUID` 用于版本校验，不一致会抛 `InvalidClassException`
- `transient` 字段不参与序列化
- `static` 字段也不序列化

## 网络编程

### TCP 通信

**服务端：**

```java
ServerSocket ss = new ServerSocket(8888);
Socket socket = ss.accept();  // 阻塞等连接

// 读
BufferedReader br = new BufferedReader(
    new InputStreamReader(socket.getInputStream()));
String msg = br.readLine();

// 写
BufferedWriter bw = new BufferedWriter(
    new OutputStreamWriter(socket.getOutputStream()));
bw.write("Hello Client");
bw.newLine();
bw.flush();

// 关闭
bw.close(); br.close(); socket.close(); ss.close();
```

**客户端：**

```java
Socket socket = new Socket("127.0.0.1", 8888);

// 写
BufferedWriter bw = new BufferedWriter(
    new OutputStreamWriter(socket.getOutputStream()));
bw.write("Hello Server");
bw.newLine();
bw.flush();

// 读
BufferedReader br = new BufferedReader(
    new InputStreamReader(socket.getInputStream()));
String msg = br.readLine();

bw.close(); br.close(); socket.close();
```

### UDP 通信

**DatagramSocket + DatagramPacket**，无连接，不可靠。

```java
// 发送
DatagramSocket ds = new DatagramSocket();
byte[] buf = "Hello".getBytes();
DatagramPacket packet = new DatagramPacket(
    buf, buf.length, InetAddress.getByName("127.0.0.1"), 8888);
ds.send(packet);
ds.close();

// 接收
DatagramSocket ds = new DatagramSocket(8888);
byte[] buf = new byte[1024];
DatagramPacket packet = new DatagramPacket(buf, buf.length);
ds.receive(packet);  // 阻塞
String msg = new String(packet.getData(), 0, packet.getLength());
ds.close();
```

### HTTP 通信（HttpURLConnection）

```java
URL url = new URL("https://api.example.com/data");
HttpURLConnection conn = (HttpURLConnection) url.openConnection();
conn.setRequestMethod("GET");
conn.setConnectTimeout(5000);

int code = conn.getResponseCode();
InputStream in = conn.getInputStream();
// 读响应...
conn.disconnect();
```
