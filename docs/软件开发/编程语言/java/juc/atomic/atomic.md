# 原子操作类

>
> 基础
> AtomicBoolean
> AtomicInteger
> AtomicLong
> 
> 数组
> AtomicIntegerArray
> AtomicLongArray
> AtomicReferenceArray
> 
> 引用
> AtomicReference
> AtomicMarkableReference
> AtomicStampedReference
> 
> 对象引用
> AtomicIntegerFieldUpdater
> AtomicLongFieldUpdater
> AtomicReferenceFieldUpdater

## 基础原子类

1. AtomicInteger

```java
// Unsafe 底层实现
private static final Unsafe U = Unsafe.getUnsafe();
// 可见性
private volatile int value;

// cas 机制
public final native boolean compareAndSwapInt(Object o, long offset, int expected, int x);
```
2. AtomicLong \ AtomicBoolean
> 与AtomicInteger 一致
 
3. AtomicBoolean

```java
private static final VarHandle VALUE;
```
> VarHandle 是 jdk 9 提供的方法
> Varhandle是对变量或参数定义的变量系列的动态强类型引用，包括静态字段，非静态字段，数组元素或堆外数据结构的组件。 
> 在各种访问模式下都支持访问这些变量，包括简单的读/写访问，volatile 的读/写访问以及 CAS (compare-and-set)访问。
> 简单来说 Variable 就是对这些变量进行绑定，通过 Varhandle 直接对这些变量进行操作。



### 总结
addAndGet 利用循环, 重复写入, 直到写入成功
```java
public final class Unsafe {
    @IntrinsicCandidate
    public final int getAndAddInt(Object o, long offset, int delta) {
        int v;
        do {
            // 获取当前值
            v = getIntVolatile(o, offset);
        } while (
            // 根据当前值和设定值设置, 如果当前值和系统的值不一致则失败
                !weakCompareAndSetInt(o, offset, v, v + delta)
        );
        return v;
    }


    @IntrinsicCandidate
    public final boolean weakCompareAndSetInt(Object o, long offset, int expected, int x) {
        // cas 方法
        return compareAndSetInt(o, offset, expected, x);
    }

    @IntrinsicCandidate
    // cas 方法, native 调用 : native 的接口调用了非java实现
    public final native boolean compareAndSetInt(Object o, long offset, int expected, int x);
}
```

### demo 
```java
public class AtomicBasic {

    public static void main(String[] args) {
        AtomicInteger atomicInteger = new AtomicInteger();

        atomicInteger.addAndGet(1);

        System.out.println(atomicInteger);

        AtomicLong atomicLong = new AtomicLong();
        //  = 0 . 没有修改
        atomicLong.compareAndSet( 0,2 );

        System.out.println(atomicLong);
        // = 1 . 修改了
        atomicLong.compareAndSet( 1,2 );

        System.out.println(atomicLong);

        AtomicBoolean atomicBoolean = new AtomicBoolean();

        atomicBoolean.compareAndSet(true, true);
        // = false . 没有修改
        System.out.println(atomicBoolean);

        atomicBoolean.compareAndSet(false,true);
        // true . 修改了
        System.out.println(atomicBoolean);
    }
}

```

## 数组

### demo

```java
public class AtomicArray {

    public static void main(String[] args) {
        // 定义一个数
        String[] names = {"leiming", "wangrui","leiwen"};

        // 使用原子数组引用
        AtomicReferenceArray<String> array = new AtomicReferenceArray<>(names);

        System.out.println("[当前内容] :"+array);

        // 修改内容
        array.set(2,"zhaodongyan");

        System.out.println("[当前内容] :"+array);

        // 使用cas方法, 元数据不正确不会被修改

        array.compareAndSet(1, "?","yaojing");

        System.out.println("[当前内容] :"+array);

        // 使用cas方法

        array.compareAndSet(1, "wangrui","leiming2");

        System.out.println("[当前内容] :"+array);

    }
}

```

```log
[当前内容] :[leiming, wangrui, leiwen]
[当前内容] :[leiming, wangrui, zhaodongyan]
[当前内容] :[leiming, wangrui, zhaodongyan]
[当前内容] :[leiming, leiming2, zhaodongyan]
```

## 引用类型

> AtomicReference : 引用类型的原子类
> AtomicMarkableReference : 带版本号 引用类型的原子类
> AtomicStampedReference : 带标记的 引用类型的原子类
> 

### AtomicReference

```java
    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    public static class Book {
        private String name;
        private long price;
    }
```

```java
    @Test
    public void testAtomicReference() {

        Book juc = new Book("学习juc", 20L);
        Book java = new Book("java基础", 21L);
        Book pmp = new Book("pmp", 99L);

        AtomicReference atomicReference = new AtomicReference(juc);
        atomicReference.compareAndSet(juc, java);

        System.out.println("[更换结果 已更换] :" + atomicReference);

        atomicReference.compareAndSet(new Book("学习juc", 20L), java);

        System.out.println("[更换结果 未更换:重写hash和eq 无法更换] :" + atomicReference);

        System.out.println("由此得知, 对象引用,对比的是 内存引用地址");
    }
```

### AtomicStampedReference
```java
    public static void testAtomicStampedReference() {

        Book juc1 = new Book("juc第一版", 1L);
        Book juc2 = new Book("juc第贰版", 2L);

        AtomicStampedReference<Book> asr
                // 第一个参数 是对象 , 第二个是版本戳
                // 按理每次修改需要增加一次版本号
                = new AtomicStampedReference<>(juc1, 1);

        boolean b = asr.compareAndSet(juc1, juc2, 2, 2);
        System.err.println("[错误示例] " + b + " , [内容] " + asr);


        b = asr.compareAndSet(juc1, juc2, 1, 2);
        System.out.println("[正确示例] " + b + " , [内容] " + asr);

    }
```


### AtomicMarkableReference
```java
    public static void testAtomicMarkableReference() {

        Book juc1 = new Book("juc第一版", 1L);
        Book juc2 = new Book("juc第贰版", 2L);

        AtomicMarkableReference<Book> asr
                // 给定标记, 其实类似于版本号,只不过只有 true 和 false 2个值
                = new AtomicMarkableReference<>(juc1, true);

        boolean b = asr.compareAndSet(juc1, juc2, false, true);
        System.err.println("[错误示例] " + b + " , [内容] " + asr);


        b = asr.compareAndSet(juc1, juc2, true, true);
        System.out.println("[正确示例] " + b + " , [内容] " + asr);

    }
```

> ##  扩展 ABA 问题
> 
> 简单理解, 就是2个工程师打开相同的程序文件, A 打开后没有处理 , B 打开并处理;
> 
> B处理完成, 保存关闭, 但是 A 浏览的文件并没有变化, 然后A保存后 就把 B 修改的内容覆盖了;
> 

# 原子属性的修改

在 JUC中 有原子类的属性修改器, 利用属性修改器, 可以安全的修改属性的内容;

提供了 3 种属性修改器

1. 原子整形属性修改器 abstract AtomicIntegerFieldUpdater
   - AtomicIntegerFieldUpdaterImpl
2. 原子长整形属性修改器 abstract AtomicLongFieldUpdater
   - 实现 CASUpdater 和 LockedUpdater
3. 原子引用类型属性修改器 abstract AtomicReferenceFieldUpdater

## AtomicLongFieldUpdater

### 必须使用 volatile 关键字定义, 否则无法运行
```java
    public static void testLongUpdaterIsVolatile() {
        AtomicLongFieldUpdater<Book> updater
                = AtomicLongFieldUpdater.newUpdater(Book.class, "price");

        // price 必须使用 volatile 关键字定义, 否则无法运行
        // Exception in thread "main" java.lang.IllegalArgumentException: Must be volatile type
    }

public static class Book {
   private String name;
   
   // volatile 关键字
   private volatile long price;

   public Book(String name, long price) {
      this.name = name;
      this.price = price;
   }

   @Override
   public String toString() {
      return new StringJoiner(", ", Book.class.getSimpleName() + "[", "]")
              .add("name='" + name + "'")
              .add("price=" + price)
              .toString();
   }
}
```

### 示例
```java
    public static void testLongUpdater() {
        Book book = new Book("longUpdater", 100L);
        System.out.println("修改之前 : "+ book);

        // 修改属性, set 中实现了原子的属性修改
        book.setPrice(99L);

        System.out.println("修改之后 : "+ book);


        // 另一种写法, 不在set中

        AtomicLongFieldUpdater<Book> updater
                = AtomicLongFieldUpdater.newUpdater(Book.class, "price");
        updater.set(book,88L);

        System.out.println("第二次修改后 : "+ book);

    }

public static class Book {
    private String name;
    private volatile long price;

    public Book(String name, long price) {
        this.name = name;
        this.price = price;
    }

    public void setPrice(long price) {

        AtomicLongFieldUpdater<Book> fieldUpdater
                = AtomicLongFieldUpdater.newUpdater(Book.class, "price");

        fieldUpdater.set(this, price);
    }
}
```

不同的场景, 需要使用不同的原子类

## AtomicLongFieldUpdater 的实现

```java
    public static void testLongUpdaterIsVolatile() {
        AtomicLongFieldUpdater<Book> updater
                = AtomicLongFieldUpdater.newUpdater(Book.class, "price");

        // price 必须使用 volatile 关键字定义, 否则无法运行
        // Exception in thread "main" java.lang.IllegalArgumentException: Must be volatile type

        System.out.println(updater);
    }
```

```text
java.util.concurrent.atomic.AtomicLongFieldUpdater$CASUpdater@b1bc7ed
```

会根据不同的 jvm 有不同的实现

```java
    @CallerSensitive
    public static <U> AtomicLongFieldUpdater<U> newUpdater(Class<U> tclass,
                                                           String fieldName) {
        Class<?> caller = Reflection.getCallerClass();
        if (AtomicLong.VM_SUPPORTS_LONG_CAS)
            return new CASUpdater<U>(tclass, fieldName, caller);
        else
            return new LockedUpdater<U>(tclass, fieldName, caller);
    }
```


# 原子类的计算

1. DoubleAdder 
2. LongAdder 
3. LongAccumulator 
4. DoubleAccumulator

## DoubleAccumulator

```java
    public static void main(String[] args) {

        DoubleAccumulator da = new DoubleAccumulator(
                // 累加函数
                (x, y) -> x + y,
                // 初始值
                0d
        );

        da.accumulate(1.0);

        System.out.println(" 结果 : "+da);
        da.accumulate(3);

        System.out.println(" 结果 : "+da);
        da.accumulate(5.0);

        System.out.println(" 结果 : "+da);

    }
```

## DoubleAdder
```java
    public static void main(String[] args) {
        DoubleAdder adder = new DoubleAdder();

        adder.add(2.0);

        System.out.println("add = "+adder);
        adder.add(2.0);

        System.out.println("add = "+adder);

}
```