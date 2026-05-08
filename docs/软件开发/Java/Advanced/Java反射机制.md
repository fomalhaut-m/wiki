# Java 反射机制

> 来源：反射笔记 | 标签：Java / 高级特性

---

## Class 类

反射的根源，一切从Class开始。

### 三种实例化方式

```java
// 1. 通过对象
Date date = new Date();
Class<?> c1 = date.getClass();

// 2. 通过类
Class<?> c2 = Date.class;

// 3. 通过字符串（可传入配置文件）
Class<?> c3 = Class.forName("java.util.Date");
```

---

## 反射实例化对象

```java
// JDK 8
Object obj = clazz.newInstance();

// JDK 9+（newInstance已弃用）
Object obj = clazz.getDeclaredConstructor().newInstance();
```

---

## 获取类结构

| 方法 | 说明 |
|------|------|
| `getPackage()` | 获取所在包 |
| `getSuperclass()` | 获取父类 |
| `getInterfaces()` | 获取实现的接口 |

```java
Class<?> clazz = CloudMessage.class;
clazz.getSuperclass();        // 父类
clazz.getInterfaces();        // 实现接口
```

---

## 反射调用构造方法

```java
// 获取构造方法
Constructor<?> con = clazz.getDeclaredConstructor(String.class, double.class);

// 调用构造实例化
Object obj = con.newInstance("nike", 99.0);
```

---

## 反射调用方法

```java
// 获取方法
Method setBrand = clazz.getDeclaredMethod("setBrand", String.class);
Method getBrand = clazz.getDeclaredMethod("getBrand");

// 调用方法
setBrand.invoke(object, "李宁");
Object result = getBrand.invoke(object);
```

---

## 反射属性赋值

```java
// 获取属性
Field field = clazz.getDeclaredField("brand");

// 取消封装
field.setAccessible(true);

// 赋值/取值
field.set(object, "李宁");
Object value = field.get(object);
```

---

## 反射与设计模式

### 工厂模式

```java
class Factory {
    public static IMessage getInstance(String className) {
        return (IMessage) Class.forName(className).newInstance();
    }
}
// 新增子类无需修改工厂类
IMessage msg = Factory.getInstance("NetPaper");
```

### 懒汉单例（线程安全）

```java
class Singleton {
    private static volatile Singleton instance;

    private Singleton() {}

    public static Singleton getInstance() {
        if (instance == null) {
            synchronized (Singleton.class) {
                if (instance == null) {
                    instance = new Singleton();
                }
            }
        }
        return instance;
    }
}
```

---

## Unsafe 工具

`sun.misc.Unsafe` 可在**不实例化**的情况下操作类方法，**不建议使用**——会破坏JVM垃圾回收机制。

```java
Field theUnsafe = Unsafe.class.getDeclaredField("theUnsafe");
theUnsafe.setAccessible(true);
Unsafe unsafe = (Unsafe) theUnsafe.get(null);
Object obj = unsafe.allocateInstance(Ball.class); // 不走构造方法
```
