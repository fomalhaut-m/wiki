# Java 多线程基础

> 来源：Java多线程笔记 | 标签：Java / 多线程

---

## 创建线程的方式

### 1. 继承 Thread

```java
class MyThread extends Thread {
    @Override
    public void run() {
        for (int i = 0; i < 50; i++) {
            System.out.println(getName() + "[" + i + "]");
        }
    }
}

new MyThread("A").start();
```

### 2. 实现 Runnable（推荐）

```java
class MyRunnable implements Runnable {
    private int ticket = 20;
    @Override
    public void run() {
        for (int i = 0; i < 50; i++) {
            if (ticket > 0)
                System.out.println("卖票：" + ticket--);
        }
    }
}

new Thread(new MyRunnable()).start();
```

### 3. 实现 Callable（有返回值）

```java
class MyCallable implements Callable<String> {
    @Override
    public String call() {
        return "执行完成";
    }
}

FutureTask<String> future = new FutureTask<>(new MyCallable());
new Thread(future).start();
System.out.println(future.get());
```

---

## Thread vs Runnable

| 对比 | Thread | Runnable |
|------|--------|----------|
| 单继承 | 受限 | 不受限 |
| 资源共享 | 不方便 | 方便（多个线程操作同一对象） |

> **推荐使用Runnable**，更灵活且避免单继承局限。

---

## 线程安全

> 多个线程访问某个类时，不管如何交替执行，都不需要额外同步，这个类就是线程安全的。

### 无状态对象

不包含任何域，也不包含对其他域的引用。**无状态对象一定是线程安全的。**

---

## 竞态条件

当正确性依赖于线程执行时序，就会发生**竞态条件**（Race Condition）。

最常见的竞态条件类型：**先检查后执行（Check-Then-Act）**

```java
// 竞态条件示例
if (obj != null) {  // 检查
    obj.doSomething();  // 执行
}
```

### 避免方法

使用**同步机制**保证原子性。

---

## 同步机制

### synchronized 内置锁

```java
synchronized (lock) {
    // 访问或修改共享状态
}
```

特点：
- 线程在进入同步代码块前自动获取锁
- 退出时自动释放锁
- **内置锁是可重入的**（同一个线程可重复获取）

### synchronized 方法

```java
public synchronized void doSomething() {
    // 方法级别的同步
}
```

---

## Callable vs Runnable

| 对比 | Runnable | Callable |
|------|----------|----------|
| 返回值 | 无 | 有（泛型V） |
| 异常 | 不能抛出 | 可以抛出 |
| 方法名 | run() | call() |
