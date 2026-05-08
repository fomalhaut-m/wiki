# Shell 运算符

## 算术运算符

```bash
# 写法一：expr（整数运算）
val=`expr 2 + 2`      # 注意：+ 两边要有空格

# 写法二：$[ ]（推荐）
val=$[2+3]

# 写法三：$(( ))（现代写法）
val=$((2+3))
```

| 运算符 | 说明 | 示例 |
|--------|------|------|
| `+` | 加 | `expr $a + $b` |
| `-` | 减 | `expr $a - $b` |
| `*` | 乘（需转义） | `expr $a \* $b` |
| `/` | 除 | `expr $a / $b` |
| `%` | 取余 | `expr $a % $b` |
| `==` | 相等 | `[ $a == $b ]` |
| `!=` | 不等 | `[ $a != $b ]` |

```bash
a=10; b=20
echo $[a + b]     # 30
echo $[a * b]     # 200（乘号需转义在 expr 中）
echo $[a / b]     # 0
echo $[a % b]     # 10
```

> **注意：** 条件表达式方括号内部**必须加空格**，如 `[ $a == $b ]`

## 关系运算符

只支持**数字**比较。

| 运算符 | 说明 |
|--------|------|
| `-eq` | equal，等于 |
| `-ne` | not equal，不等 |
| `-gt` | greater than，大于 |
| `-lt` | less than，小于 |
| `-ge` | greater or equal，大于等于 |
| `-le` | less or equal，小于等于 |

```bash
a=10; b=20
if [ $a -eq $b ]; then
    echo "相等"
else
    echo "不相等"
fi
```

## 布尔运算符

| 运算符 | 说明 |
|--------|------|
| `!` | 非 |
| `-o` | 或（or） |
| `-a` | 与（and） |

```bash
a=10; b=20
if [ $a -lt 100 -a $b -gt 15 ]; then
    echo "a<100 且 b>15"
fi
```

## 逻辑运算符（[[ ]]）

| 运算符 | 说明 |
|--------|------|
| `&&` | 逻辑与 |
| `||` | 逻辑或 |

```bash
if [[ $a -lt 100 && $b -gt 100 ]]; then
    echo "条件满足"
fi
```

## 字符串运算符

| 运算符 | 说明 |
|--------|------|
| `=` | 相等 |
| `!=` | 不等 |
| `-z` | 长度为 0 |
| `-n` | 长度不为 0 |
| `$` | 字符串非空 |

```bash
a="abc"; b="efg"
if [ $a = $b ]; then echo "相等"; else echo "不等"; fi
if [ -z $a ]; then echo "为空"; else echo "非空"; fi
```

## 文件测试运算符

| 运算符 | 说明 |
|--------|------|
| `-e file` | 文件存在 |
| `-f file` | 普通文件（非目录） |
| `-d file` | 目录 |
| `-r file` | 可读 |
| `-w file` | 可写 |
| `-x file` | 可执行 |
| `-s file` | 文件非空 |
| `-L file` | 符号链接 |

```bash
file="test.sh"
if [ -f "$file" ]; then
    echo "是普通文件"
fi
if [ -x "$file" ]; then
    echo "可执行"
fi
```

## 条件语句

```bash
# if 语句
if [ 条件 ]; then
    命令
fi

# if-else
if [ 条件 ]; then
    命令1
else
    命令2
fi

# if-elif
if [ 条件1 ]; then
    命令1
elif [ 条件2 ]; then
    命令2
else
    命令3
fi
```

## 循环

```bash
# for 循环
for i in 1 2 3 4 5; do
    echo "i = $i"
done

# C 风格 for
for ((i=1; i<=5; i++)); do
    echo "i = $i"
done

# while 循环
a=1
while [ $a -le 5 ]; do
    echo "a = $a"
    a=$[a+1]
done
```

## Case 语句

```bash
case 值 in
模式1)
    命令1
    ;;
模式2)
    命令2
    ;;
*)
    默认命令
    ;;
esac
```
