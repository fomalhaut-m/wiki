# HTTP 协议详解

> 来源：HTTP报文笔记 | 标签：网络 / HTTP

---

## 报文组成

HTTP报文由三部分组成：

| 部分 | 说明 |
|------|------|
| **起始行** | 描述报文内容和含义 |
| **首部（Header）** | 属性信息 |
| **主体（Body）** | 可选的数据部分（文本或二进制） |

### 请求报文格式

```
<method> <request-URL> <version>
<headers>

<entity-body>
```

### 响应报文格式

```
<version> <status> <reason-phrase>
<headers>

<entity-body>
```

---

## 请求方法

| 方法 | 说明 |
|------|------|
| **GET** | 请求资源 |
| **POST** | 提交数据 |
| **PUT** | 上传资源 |
| **DELETE** | 删除资源 |
| **HEAD** | 仅获取头部 |
| **OPTIONS** | 预检请求 |

---

## 状态码

| 类别 | 范围 | 说明 |
|------|------|------|
| **1xx** | 100-199 | 信息性 |
| **2xx** | 200-299 | 成功 |
| **3xx** | 300-399 | 重定向 |
| **4xx** | 400-499 | 客户端错误 |
| **5xx** | 500-599 | 服务器错误 |

### 常见状态码

| 状态码 | 说明 |
|--------|------|
| 200 | OK |
| 301 | 永久重定向 |
| 302 | 临时重定向 |
| 304 | Not Modified（缓存） |
| 400 | Bad Request |
| 401 | Unauthorized |
| 403 | Forbidden |
| 404 | Not Found |
| 500 | Internal Server Error |
| 502 | Bad Gateway |
| 503 | Service Unavailable |

---

## 首部Header

### 通用首部

| 首部 | 说明 |
|------|------|
| Date | 报文创建时间 |
| Connection | 连接管理（keep-alive/close） |
| Cache-Control | 缓存控制 |

### 请求首部

| 首部 | 说明 |
|------|------|
| Host | 目标主机 |
| User-Agent | 用户代理 |
| Accept | 可接受的媒体类型 |
| Accept-Encoding | 可接受的编码 |
| Cookie | Cookie信息 |

### 响应首部

| 首部 | 说明 |
|------|------|
| Server | 服务器信息 |
| Set-Cookie | 设置Cookie |
| ETag | 资源标识 |

### 实体首部

| 首部 | 说明 |
|------|------|
| Content-Type | 媒体类型 |
| Content-Length | 内容长度 |
| Content-Encoding | 编码方式 |
| Last-Modified | 最后修改时间 |

---

## Keep-Alive 连接

HTTP/1.1 默认使用持久连接：

```
Connection: keep-alive
```

在一个TCP连接上可以发送多个请求，减少了连接建立的开销。

---

## 缓存相关

| 首部 | 说明 |
|------|------|
| Cache-Control | max-age, no-cache, no-store |
| ETag | 资源版本标识 |
| Last-Modified | 最后修改时间 |
| If-None-Match | 条件请求（ETag） |
| If-Modified-Since | 条件请求（时间） |

---

## HTTPS

SSL/TLS 加密通道：

1. 客户端发起HTTPS请求
2. 服务器发送证书
3. 客户端验证证书有效性
4. 密钥协商
5. 加密通信

HTTP默认端口：**80**  
HTTPS默认端口：**443**
