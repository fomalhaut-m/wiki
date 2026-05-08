# Shell 变量

## 变量定义

```bash
# 规范：
# - 等号两边不能有空格
# - 变量名只能使用英文字母、数字、下划线
# - 不能用 bash 关键字

name="runoob.com"
age=100
```

## 变量使用

```bash
# 输出变量（加 $）
echo $name
echo ${name}          # 推荐写法，加花括号界定边界

# 拼接
echo "Hello ${name}Script"   # 正确
echo "Hello $nameScript"     # 错误，会找 nameScript 变量
```

## 修改变量（重新赋值）

```bash
name="tom"
echo $name       # tom
name="alibaba"
echo $name       # alibaba
```

## 只读变量

```bash
readonly myUrl="http://www.google.com"
# 再次赋值会报错：This variable is read only.
```

## 删除变量

```bash
unset 变量名
echo $变量名     # 空
```

## 三种变量类型

| 类型 | 说明 |
|------|------|
| **局部变量** | 仅在当前 shell 有效，子 shell 无法访问 |
| **环境变量** | 当前 shell 及子进程都可访问 |
| **shell 变量** | shell 内置的变量 |

```bash
# 查看环境变量
env
printenv

# 设置环境变量（临时）
export JAVA_HOME=/usr/local/jdk
echo $JAVA_HOME
```

## 永久环境变量

写入配置文件中：

```bash
# /etc/profile（全局，所有用户生效）
# ~/.bashrc（当前用户生效）

# 修改后使之生效
source /etc/profile
```

## 特殊变量

| 变量 | 说明 |
|------|------|
| `$0` | 当前脚本文件名 |
| `$n` | 第 n 个参数（$1, $2 ...） |
| `$#` | 参数个数 |
| `$*` | 所有参数（合成一个字符串） |
| `$@` | 所有参数（各自独立） |
| `$$` | 当前进程 PID |
| `$?` | 上一个命令的退出状态（0=成功） |

```bash
#!/bin/bash
echo "脚本名: $0"
echo "第一个参数: $1"
echo "参数个数: $#"
echo "所有参数: $@"
echo "当前PID: $$"
```

## 字符串变量

### 单引号 vs 双引号

| 类型 | 说明 |
|------|------|
| **单引号** | 所见即所得，原样输出，不解析变量 |
| **双引号** | 可以解析变量和转义字符 |

```bash
name="world"
echo 'Hello $name'   # Hello $name（不解析）
echo "Hello $name"   # Hello world（解析变量）
```

### 字符串操作

```bash
str="hello world"

# 长度
echo ${#str}              # 11

# 切片
echo ${str:0:5}           # hello
echo ${str:6}             # world

# 替换
echo ${str/hello/hi}     # hi world
```
