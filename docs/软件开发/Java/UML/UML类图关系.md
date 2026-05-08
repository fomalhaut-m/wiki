# UML类图六大关系

> 来源：设计模式笔记 | 标签：设计模式 / UML

---

## 六种关系

| 关系 | 说明 | 符号 |
|------|------|------|
| **依赖** | 使用到对方 | `---→` 虚线箭头 |
| **泛化** | 继承 | `---→` 实线空心三角 |
| **实现** | 实现接口 | `---→` 虚线空心三角 |
| **关联** | 类之间的联系 | `───→` 实线箭头 |
| **聚合** | 整体与部分，可分开 | `◇───→` 空心菱形 |
| **组合** | 整体与部分，不可分 | `◆───→` 实心菱形 |

---

## 1. 依赖

**只要在类中用到了对方，就存在依赖关系。**

```java
class Person {
    // 1. 类型的成员属性
    private IDCard card;

    // 2. 方法的返回类型
    IDCard getCard() { return card; }

    // 3. 接收的参数类型
    void setCard(IDCard card) { this.card = card; }

    // 4. 方法中使用到
    void someMethod() {
        card.show();
    }
}
```

---

## 2. 泛化（继承）

继承关系，是依赖关系的特例。

```java
class A extends B {}
// A 和 B 存在泛化关系
```

---

## 3. 实现

实现接口，是依赖关系的特例。

```java
class A implements B {}
// A 和 B 存在实现关系
```

---

## 4. 关联

类与类之间的联系，是依赖关系的特例。

**导航性**：双向或单向关系。

```java
// 单向一对一
class Person { private IDCard card; }
class IDCard {}

// 双向一对一
class Person { private IDCard card; }
class IDCard { private Person person; }
```

---

## 5. 聚合

整体和部分可以分开，是关联关系的特例。

```java
// 电脑由键盘、显示器、鼠标组成
// 各个配件可以独立存在
class Computer { private Keyboard keyboard; }
class Keyboard {}
```

---

## 6. 组合

整体和部分不可分割，是关联关系的特例。

```java
// 人和心脏
// 人不存在了，心脏也没意义
class Person {
    private Heart heart;
    Person() { this.heart = new Heart(); }
}
class Heart {}
```

---

## 记忆口诀

> 依赖最基本，泛化实现是特例  
> 关联导航性，聚合可分开，组合不可分
