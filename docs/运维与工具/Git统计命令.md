# Git 统计命令

> 来源：团队Git规范 | 标签：开发工具 / Git

---

## 查看个人代码量

```bash
git log --author="username" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }' -
```

**输出示例：**
```
added lines: 120745, removed lines: 71738, total lines: 49007
```

---

## 统计每个人增删行数

```bash
git log --format='%aN' | sort -u | while read name; do echo -en "$name\t"; git log --author="$name" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2} END { printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }' -; done
```

**输出示例：**
```
Max-laptop    added lines: 1192, removed lines: 748, total lines: 444
chengshuai    added lines: 120745, removed lines: 71738, total lines: 49007
```

---

## 仓库提交者排名前5

```bash
git log --pretty='%aN' | sort | uniq -c | sort -k1 -n -r | head -n 5
```

---

## 贡献者数量

```bash
git log --pretty='%aN' | sort -u | wc -l
```

---

## 提交数统计

```bash
git log --oneline | wc -l
```

---

## 提交量统计

```bash
git log --stat|perl -ne 'END { print $c } $c += $1 if /(\d+) insertions/'
```
