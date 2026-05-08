# Spring Cloud 微服务

> 来源：Spring Cloud笔记 | 标签：微服务 / Spring Cloud

---

## 微服务特征

| 特征 | 说明 |
|------|------|
| **小（Small）** | 粒度小，专注一件事 |
| **独（Own process）** | 单独进程，独立部署 |
| **轻（Lightweight）** | 轻量级通信（HTTP/REST） |
| **松（Loose）** | 松耦合，可独立升级发布 |

---

## 微服务优点

- 独立测试、部署、升级、发布
- 提升开发交流效率
- 按需扩展（x扩展 + z扩展）
- 提高容错性（一个服务故障不影响全局）
- 技术栈不受限（各服务可选不同技术）
- 便于组建小团队

---

## 微服务缺点

- 分布式系统复杂性
- 服务间通信问题
- 服务注册与发现
- 分布式事务问题
- 数据隔离与报表处理
- 服务管理/编排复杂性

---

## 微服务常见组件

| 组件 | 说明 |
|------|------|
| **服务注册中心** | 服务地址注册与发现 |
| **负载均衡** | 透明分发请求到合适节点 |
| **服务网关** | 统一入口，实现鉴权、路由、限流、A/B测试 |
| **配置中心** | 集中管理配置 |
| **熔断器** | 故障隔离，防止雪崩 |
| **链路追踪** | 请求链路可视化 |

---

## Spring Cloud 组件生态

| 组件 | 替代方案 |
|------|----------|
| **Eureka** | Consul / Nacos |
| **Ribbon** | LoadBalancer |
| **Feign** | OpenFeign |
| **Gateway** | Zuul |
| **Hystrix** | Resilience4j / Sentinel |
| **Config** | Nacos Config |
| **Sleuth** | SkyWalking / Zipkin |

---

## 核心配置文件

```yaml
spring:
  application:
    name: user-service
  cloud:
    nacos:
      discovery:
        server-addr: nacos:8848
```

---

## 服务调用流程

```
用户 → 网关 → 服务注册中心 → 发现服务 → 负载均衡 → 调用服务
                                      ↓
                                 配置中心
                                      ↓
                                 链路追踪
```
