# Java IO 流

> 来源：Java IO笔记 | 标签：Java / IO

---

## IO流分类

| 分类 | 输入流 | 输出流 |
|------|--------|--------|
| **字节流** | InputStream | OutputStream |
| **字符流** | Reader | Writer |

---

## 操作流程

```
1. 通过File类确定文件路径
2. 创建流对象（字节流/字符流）
3. 读/写操作
4. 关闭流（close()）
```

---

## 字节流

### FileOutputStream（输出）

```java
// 覆盖写入
FileOutputStream fos = new FileOutputStream("demo.txt");
fos.write("hello".getBytes());
fos.close();

// 追加写入
FileOutputStream fos = new FileOutputStream("demo.txt", true);
```

### FileInputStream（输入）

```java
FileInputStream fis = new FileInputStream("demo.txt");
byte[] buffer = new byte[1024];
int len = fis.read(buffer);  // 读取到buffer
fis.close();
```

---

## 字符流

### FileWriter / FileReader

```java
// 写入
FileWriter fw = new FileWriter("demo.txt");
fw.write("内容");
fw.close();

// 读取
FileReader fr = new FileReader("demo.txt");
char[] buffer = new char[1024];
int len = fr.read(buffer);
fr.close();
```

---

## 缓冲流（性能优化）

```java
// 字节缓冲流
BufferedInputStream bis = new BufferedInputStream(new FileInputStream("demo.txt"));
BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream("demo.txt"));

// 字符缓冲流
BufferedReader br = new BufferedReader(new FileReader("demo.txt"));
BufferedWriter bw = new BufferedWriter(new FileWriter("demo.txt"));
```

---

## 转换流

```java
// 字节流转字符流
InputStreamReader isr = new InputStreamReader(new FileInputStream("demo.txt"), "UTF-8");
OutputStreamWriter osw = new OutputStreamWriter(new FileOutputStream("demo.txt"), "UTF-8");
```

---

## 序列化（对象流）

```java
// 序列化（写出对象）
ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream("obj.dat"));
oos.writeObject(new User("luke", 18));

// 反序列化（读取对象）
ObjectInputStream ois = new ObjectInputStream(new FileInputStream("obj.dat"));
User user = (User) ois.readObject();
```

> 对象必须实现 `Serializable` 接口
