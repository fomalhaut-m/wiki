# Java 字节码指令

> 来源：字节码笔记 | 标签：JVM / 字节码

---

## 常量入栈指令

| 指令码 | 助记符 | 描述 |
|--------|--------|------|
| 0x01 | aconst_null | null入栈 |
| 0x02 | iconst_m1 | -1(int)入栈 |
| 0x03~0x08 | iconst_0~5 | 0~5(int)入栈 |
| 0x09~0x0a | lconst_0~1 | 0~1(long)入栈 |
| 0x0b~0x0d | fconst_0~2 | 0~2(float)入栈 |
| 0x0e~0x0f | dconst_0~1 | 0~1(double)入栈 |
| 0x10 | bipush | byte值扩展成int入栈 |
| 0x11 | sipush | short值扩展成int入栈 |
| 0x12 | ldc | 从常量池取int/float/string入栈 |
| 0x13 | ldc_w | 从常量池取常量（宽索引） |
| 0x14 | ldc2_w | 从常量池取long/double入栈 |

---

## 局部变量加载指令

| 类型前缀 | 说明 |
|----------|------|
| iload/istore | int类型 |
| lload/lstore | long类型 |
| fload/fstore | float类型 |
| dload/dstore | double类型 |
| aload/astore | 引用类型 |

---

## 方法调用指令

| 指令 | 说明 |
|------|------|
| invokevirtual | 调用实例方法（虚方法分派） |
| invokestatic | 调用类/静态方法 |
| invokeinterface | 调用接口方法 |
| invokespecial | 调用构造器/私有方法/父类方法 |
| invokedynamic | 调用动态绑定的方法（lambda、方法句柄） |

---

## 控制转移指令

| 类型 | 说明 |
|------|------|
| ifeq/ifne | int等于/不等于零 |
| if_icmpeq/if_icmpne | int比较相等/不相等 |
| if_acmpeq/if_acmpne | 引用比较相等/不相等 |
| goto | 无条件跳转 |
| tableswitch | switch-case（密集表） |
| lookupswitch | switch-case（稀疏表） |

---

## 其他常用指令

| 指令 | 说明 |
|------|------|
| new | 创建新对象实例 |
| newarray | 创建数组 |
| arraylength | 获取数组长度 |
| getfield/getstatic | 获取字段值/静态字段 |
| putfield/putstatic | 设置字段值/静态字段 |
| return/ireturn/lreturn | void/int/long返回值 |
| athrow | 抛出异常 |
| monitorenter/monitorexit | 同步块入口/出口 |

---

## 栈操作指令

| 指令 | 说明 |
|------|------|
| dup | 复制栈顶元素 |
| pop | 弹出栈顶元素 |
| swap | 交换栈顶两个元素 |
| nop | 无操作 |

> 学习字节码有助于理解多线程、反射、lambda的底层原理
