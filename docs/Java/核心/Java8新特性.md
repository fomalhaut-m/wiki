# Java8 新特性

## Lambda 表达式

Lambda 是匿名函数，可理解为"一段可以传递的代码"。

### 语法格式

```java
// 无参无返回
() -> System.out.println("Hello")

// 一个参数（括号可省略）
n -> System.out.println(n)

// 多参数，有返回
(a, b, c) -> { return a * b * c; }

// 只有一条 return，可省略大括号和 return
(a, b) -> a + b
```

> **规则：**
> - 左右遇一，省略括号
> - 左侧推断类型，省略类型
> - 能省则省
> - **需要函数式接口支持**

### 函数式接口

只包含一个抽象方法的接口，加上 `@FunctionalInterface` 可做检查。

**四大核心函数式接口：**

| 类型 | 接口 | 方法 | 用途 |
|------|------|------|------|
| 消费型 | `Consumer<T>` | `accept(T t)` | 消费数据，无返回 |
| 供给型 | `Supplier<T>` | `get()` | 返回数据 |
| 函数型 | `Function<T, R>` | `apply(T t)` | 转换，返回 R |
| 断定型 | `Predicate<T>` | `test(T t)` | 判断，返回 boolean |

### 方法引用

把已有方法当成 Lambda：

```java
// 对象的实例方法
emp::getAge

// 类名 :: 静态方法
System.out::println

// 类名 :: 实例方法（第一个参数是调用者）
String::equals
```

### 构造器引用

```java
// 无参
Supplier<Emp> sp = Emp::new;

// 有参
Function<String, Emp> ft = Emp::new;

// 多参
BiFunction<Integer, String, Emp> bf = Emp::new;
```

## Stream API

三步走：**创建流 → 中间操作 → 终止操作**

### 创建流

```java
// Collection 派生
list.stream()
list.parallelStream()  // 并行流

// Arrays
Arrays.stream(arr)

// of
Stream.of(1, 2, 3)

// 无限流
Stream.iterate(0, x -> x + 2)   // 迭代
Stream.generate(Math::random)     // 生成
```

### 中间操作

`filter / map / limit / sorted / distinct`

### 终止操作

**匹配：**
- `allMatch` — 全匹配
- `anyMatch` — 至少一个
- `noneMatch` — 都不匹配

**查找：**
- `findFirst` / `findAny`
- `count / max / min`

**归约：**
```java
// 求和
Optional<Integer> sum = list.stream().reduce((x, y) -> x + y);

// 最大值
list.stream().map(User::getAge).max(Integer::compare);
```

**收集：**
```java
List<String> names = list.stream()
    .map(User::getName)
    .collect(Collectors.toList());
```

> **注意：** 流一旦执行终止操作，就不能再次使用。

## Optional 容器

解决 `NullPointerException`，把 null 包装成安全容器。

```java
Optional<String> name = Optional.ofNullable(user.getName());

// 安全取值
String result = name.orElse("默认值");
String result = name.orElseGet(() -> "计算得出的默认值");

// 判断
name.ifPresent(System.out::println);

// 链式
user.getAddress()
    .flatMap(Address::getZipCode)
    .orElse("000000");
```

## 新时间 API

旧 `java.util.Date` 问题多，Java8 引入 `java.time` 包。

```java
// LocalDate / LocalTime / LocalDateTime
LocalDate today = LocalDate.now();
LocalDateTime dt = LocalDateTime.now();

// 格式化
dt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"))

// 减加日期
today.minusDays(3)
today.plusMonths(1)

// Duration / Period
Duration.between(start, end)
Period.between(date1, date2)

// Instant（时间戳）
Instant.now().toEpochMilli()
```
