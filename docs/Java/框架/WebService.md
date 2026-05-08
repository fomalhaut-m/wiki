# WebService

## 概述

WebService 是跨语言、跨平台的远程调用技术，基于 SOAP / HTTP。

**常用框架：**
- JAX-WS（Metro / CXF）
- Apache CXF（主流）

## SOAP vs REST

| 对比 | SOAP WebService | RESTful |
|------|----------------|---------|
| 协议 | SOAP + XML | HTTP + JSON |
| 复杂度 | 高 | 低 |
| 性能 | 较低 | 较高 |
| 标准 | WS-* 规范（安全/事务等） | 无强制标准 |
| 适用 | 企业级集成 | 互联网 API |

## Apache CXF（主流实现）

### 发布服务

```java
// 定义接口
@WebService
public interface HelloService {
    String sayHello(String name);
}

// 实现
@WebService(endpointInterface = "com.example.HelloService")
public class HelloServiceImpl implements HelloService {
    @Override
    public String sayHello(String name) {
        return "Hello " + name;
    }
}

// 发布
public static void main(String[] args) {
    HelloServiceImpl impl = new HelloServiceImpl();
    Endpoint.publish("http://localhost:8080/hello", impl);
}
```

### 客户端调用

```java
// 方式一：生成客户端（wsdl2java）
// wsdl2java -d src -p com.example.http://localhost:8080/hello?wsdl

// 方式二：直接调用
JaxWsProxyFactoryBean factory = new JaxWsProxyFactoryBean();
factory.setServiceClass(HelloService.class);
factory.setAddress("http://localhost:8080/hello");

HelloService client = (HelloService) factory.create();
String result = client.sayHello("luke");
```

## Spring Boot 整合 CXF

```xml
<dependency>
    <groupId>org.apache.cxf</groupId>
    <artifactId>cxf-spring-boot-starter-jaxws</artifactId>
</dependency>
```

```java
@Bean
public Endpoint helloEndpoint() {
    EndpointImpl endpoint = new EndpointImpl(bus, new HelloServiceImpl());
    endpoint.publish("/hello");
    return endpoint;
}
```

## WSDL 说明

WSDL（Web Services Description Language）描述服务：

```
wsdl:definitions
  wsdl:service      — 服务名和端口
  wsdl:port        — 绑定地址
  wsdl:binding     — 协议绑定（SOAP/HTTP）
  wsdl:operation    — 操作名
  wsdl:message     — 消息格式
  wsdl:types       — 数据类型（XSD）
```

## SOAP 消息示例

```xml
<!-- 请求 -->
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <sayHello xmlns="http://example.com/">
      <arg0>luke</arg0>
    </sayHello>
  </soap:Body>
</soap:Envelope>

<!-- 响应 -->
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <sayHelloResponse xmlns="http://example.com/">
      <return>Hello luke</return>
    </sayHelloResponse>
  </soap:Body>
</soap:Envelope>
```
