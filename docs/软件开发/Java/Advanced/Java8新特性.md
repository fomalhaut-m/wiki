# Java 8 新特性

> 来源：个人笔记整理 | 标签：Java / 新特性

---

## Lambda 表达式

Lambda 是一个**匿名函数**，将代码像数据一样传递。

### 语法

```java
// 无参，无返回值
() -> System.out.println("Lambda体")

// 一个参数
n -> System.out.println("数字=" + n)

// 两个以上参数，有返回值
(a, b, c) -> a * b * c

// 多语句
(a, b, c) -> {
    int d = a * b * c;
    return d;
};
```

### 简化规则

> **左右遇一括号省，左侧推断类型省，能省则省**

⚠️ 需要函数式接口支持

---

## 函数式接口

- 只包含一个抽象方法的接口
- `@FunctionalInterface` 注解检查是否是函数式接口

```java
@FunctionalInterface
public interface MyFunction {
    public double getValue();
}
```

---

## Stream API

### 三步走

```
创建Stream → 中间操作 → 终止操作
```

### 创建Stream

```java
// Collection
list.stream();           // 顺序流
list.parallelStream();    // 并行流

// Arrays
Arrays.stream(nums);

// Stream.of
Stream.of(1, 2, 3, 4, 5);

// 无限流
Stream.iterate(0, x -> x + 3);    // 迭代
Stream.generate(Math::random);       // 生成
```

### 中间操作

```java
filter()    // 过滤
map()       // 映射
sorted()    // 排序
distinct()  // 去重
limit()     // 截断
skip()      // 跳过
```

### 终止操作

```java
forEach()       // 遍历
collect()       // 收集
toList()        // 转List
toSet()         // 转Set
count()         // 计数
max/min()       // 最大/最小
reduce()        // 归约
findFirst()     // 返回第一个
anyMatch()      // 任意匹配
allMatch()      // 全部匹配
noneMatch()     // 无匹配
```

---

## Optional 容器类

避免 NPE（NullPointerException）。

```java
Optional.ofNullable(user)
    .map(User::getName)
    .orElse("默认值");
```

---

## 新时间 API

```java
// LocalDateTime
LocalDateTime.now();
LocalDateTime.of(2026, 5, 8, 12, 30);

// 格式化
DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
String dateStr = now.format(formatter);
```
