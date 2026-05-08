# WebService 入门

> 来源：WebService笔记 | 标签：框架 / WebService

---

## 什么是WebService

WebService是一种跨语言、跨操作系统的远程调用技术。

---

## 三大要素

| 要素 | 说明 |
|------|------|
| **SOAP** | 简单对象访问协议，HTTP+XML |
| **WSDL** | WebService说明书，描述服务 |
| **UDDI** | 目录服务，注册和搜索Web服务 |

---

## Java三种规范

| 规范 | 数据格式 | 说明 |
|------|----------|------|
| **JAX-WS** | XML | 常用，隐藏SOAP细节 |
| **JAXM&SAAJ** | XML | 底层SOAP，控制更多 |
| **JAX-RS** | XML/JSON | REST风格 |

---

## SOAP协议

SOAP = HTTP + XML

**组成**：
- **Envelope**：必须，XML根元素
- **Headers**：可选
- **Body**：必须，包含执行的方法和发送的数据

---

## WSDL

描述WebService服务端对外发布的服务：
- 服务名称（类）
- 接口方法名称
- 接口参数
- 返回数据类型

---

## 应用场景

- 应用程序集成
- 软件重用
- 跨防火墙通信
- 企业内部系统间接口调用
- 面向公网的WebService服务

---

## 优缺点

### 优点
- 跨平台互通性
- 软件复用
- 成本低、可读性强
- 可以传对象

### 缺点
- 效率低（XML传输数据量大）
- 简单接口可用HTTP+JSON替代

---

## SOA 面向服务架构

SOA是一种思想，将应用程序的不同功能单元通过中立契约联系起来。

> WebService是SOA的一种较好实现方式。
