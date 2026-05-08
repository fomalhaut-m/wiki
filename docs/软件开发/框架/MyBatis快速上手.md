# MyBatis 快速上手

> 来源：MyBatis笔记 | 标签：框架 / MyBatis

---

## 三大特点

| 特点 | 说明 |
|------|------|
| **不屏蔽SQL** | 精确定位SQL，可优化，符合互联网性能优化特点 |
| **灵活映射** | 提供动态SQL，支持动态组装SQL |
| **Mapper接口** | 一个接口+一个XML创建映射器 |

---

## 核心组件

| 组件 | 说明 |
|------|------|
| **SqlSessionFactoryBuilder** | 构造器，Builder模式 |
| **SqlSessionFactory** | 工厂接口，生产SqlSession |
| **SqlSession** | 会话，发送SQL并返回结果 |
| **Mapper** | 映射器，接口+XML构成 |

---

## 动态SQL

### if 判断

```xml
<select id="findByParam" resultType="User">
    SELECT * FROM users WHERE 1=1
    <if test="uid != null">
        AND uid=#{uid}
    </if>
    <if test="uname != null and uname != ''">
        AND uname = #{uname}
    </if>
</select>
```

### where 封装

```xml
<select id="findByParam" resultType="User">
    SELECT * FROM users
    <where>
        <if test="uid != null">uid=#{uid}</if>
        <if test="uname != null">AND uname = #{uname}</if>
    </where>
</select>
```

### choose 分支

```xml
<select id="findByParamChoose" resultType="User">
    SELECT * FROM users WHERE 1=1
    <choose>
        <when test="uid != null">AND uid=#{uid}</when>
        <when test="uname != null">AND uname LIKE #{uname}</when>
        <otherwise>AND status=1</otherwise>
    </choose>
</select>
```

### set 更新

```xml
<update id="update">
    UPDATE users
    <set>
        <if test="uname != null">uname=#{uname},</if>
        <if test="birthday != null">birthday=#{birthday},</if>
    </set>
    WHERE uid=#{uid}
</update>
```

### foreach 遍历

```xml
<!-- IN 范围查找 -->
<select id="findByIds" resultType="User">
    SELECT * FROM users WHERE id IN
    <foreach collection="ids" item="id" open="(" separator="," close=")">
        #{id}
    </foreach>
</select>

<!-- 批量插入 -->
<insert id="saveList">
    INSERT INTO users (uname, birthday) VALUES
    <foreach collection="list" item="user" separator=",">
        (#{user.uname}, #{user.birthday})
    </foreach>
</insert>
```

---

## 取值区别

| 方式 | 说明 | 安全性 |
|------|------|--------|
| `#{}` | 预编译取值 | ✅ 安全 |
| `${}` | 字符串拼接 | ⚠️ 有SQL注入风险 |

> 表名、原生关键字不支持占位符时，才用 `${}`

---

## 参数传递

| 方式 | 语法 |
|------|------|
| 单个参数 | `#{参数名}` |
| 多个参数 | `#{param1}`, `#{param2}` 或 `@Param` |
| POJO对象 | `#{属性名}` |
| Map | `#{key}` |

```java
// @Param注解
User findById(@Param("id") Integer id, @Param("name") String name);
// SQL: WHERE id=#{id} AND name=#{name}
```

---

## 缓存机制

### 一级缓存（SqlSession级）

- 默认一直开启
- 一次会话期间查询的数据放入本地缓存
- **失效**：不同SqlSession、增删改操作

### 二级缓存（namespace级）

```xml
<!-- 开启 -->
<setting name="cacheEnabled" value="true"/>

<!-- Mapper中配置 -->
<cache eviction="LRU" flushInterval="60000" size="512" readOnly="true"/>
```

| 属性 | 说明 |
|------|------|
| eviction | 回收策略：LRU/FIFO/SOFT/WEAK |
| flushInterval | 刷新间隔（毫秒） |
| size | 缓存元素数量 |
| readOnly | true=只读不安全快，false=复制更安全 |
