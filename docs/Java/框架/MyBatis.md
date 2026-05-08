# MyBatis

## 概述

半自动 ORM 框架，SQL 与 Java 代码分离，灵活可控。

## 核心组件

| 组件 | 说明 |
|------|------|
| `SqlSessionFactoryBuilder` | 构建 SqlSessionFactory |
| `SqlSessionFactory` | 创建 SqlSession |
| `SqlSession` | 操作数据库的会话 |
| `Mapper` | 映射器，定义 SQL 方法 |

## 映射文件

### CRUD

```xml
<mapper namespace="com.example.UserMapper">

    <insert id="save" parameterType="User">
        INSERT INTO user(name, age) VALUES(#{name}, #{age})
        <selectKey keyProperty="id" resultType="Long" order="AFTER">
            SELECT LAST_INSERT_ID()
        </selectKey>
    </insert>

    <select id="findById" resultType="User">
        SELECT * FROM user WHERE id = #{id}
    </select>

    <update id="update" parameterType="User">
        UPDATE user SET name = #{name}, age = #{age} WHERE id = #{id}
    </update>

    <delete id="delete" parameterType="long">
        DELETE FROM user WHERE id = #{id}
    </delete>

</mapper>
```

### resultMap（结果映射）

```xml
<resultMap id="userMap" type="User">
    <id property="id" column="id"/>
    <result property="name" column="name"/>
    <result property="age" column="age"/>
    <!-- 一对一关联 -->
    <association property="dept" javaType="Dept">
        <id property="id" column="dept_id"/>
        <result property="name" column="dept_name"/>
    </association>
    <!-- 一对多关联 -->
    <collection property="orders" ofType="Order">
        <id property="id" column="order_id"/>
        <result property="amount" column="amount"/>
    </collection>
</resultMap>
```

## 动态 SQL

```xml
<!-- if -->
<select id="findByCondition" resultType="User">
    SELECT * FROM user
    <where>
        <if test="name != null">AND name = #{name}</if>
        <if test="age != null">AND age = #{age}</if>
    </where>
</select>

<!-- set（更新用） -->
<update id="updateSelective" parameterType="User">
    UPDATE user
    <set>
        <if test="name != null">name = #{name},</if>
        <if test="age != null">age = #{age},</if>
    </set>
    WHERE id = #{id}
</update>

<!-- foreach -->
<select id="findByIds" resultType="User">
    SELECT * FROM user WHERE id IN
    <foreach collection="list" item="id" open="(" separator="," close=")">
        #{id}
    </foreach>
</select>

<!-- sql 片段 -->
<sql id="baseColumn">id, name, age</sql>
<select id="findAll" resultType="User">
    SELECT <include refid="baseColumn"/> FROM user
</select>
```

## 全局配置

```xml
<!-- mybatis-config.xml -->
<settings>
    <setting name="cacheEnabled" value="true"/>     <!-- 开启二级缓存 -->
    <setting name="lazyLoadingEnabled" value="true"/> <!-- 懒加载 -->
    <setting name="logImpl" value="SLF4J"/>
</settings>
```

## 一级缓存 vs 二级缓存

| 缓存 | 范围 | 生命周期 |
|------|------|---------|
| 一级缓存 | SqlSession | 同一 SqlSession 内 |
| 二级缓存 | SqlSessionFactory | 跨 SqlSession，可跨线程 |

## 逆向工程（Generator）

```xml
<plugin>
    <plugin>
        <groupId>org.mybatis.generator</groupId>
        <artifactId>mybatis-generator-maven-plugin</artifactId>
        <version>1.4.2</version>
    </plugin>
</plugin>
```

运行 `mvn mybatis-generator:generate`，自动生成 Mapper 接口、XML、实体类。

## 分页插件（PageHelper）

```java
PageHelper.startPage(pageNum, pageSize);
List<User> list = userMapper.selectAll();
PageInfo<User> pageInfo = new PageInfo<>(list);

pageInfo.getTotal();     // 总记录数
pageInfo.getPages();     // 总页数
pageInfo.getList();     // 当前页数据
```
