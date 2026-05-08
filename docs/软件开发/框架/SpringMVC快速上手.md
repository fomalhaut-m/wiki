# Spring MVC 快速上手

> 来源：SpringMVC笔记 | 标签：框架 / Spring MVC

---

## 什么是Spring MVC

Spring MVC是Spring框架的一个模块，基于MVC设计模式的Web框架。

> 无需和Spring进行整合即可单独使用。

---

## MVC组件

| 组件 | 说明 |
|------|------|
| **Controller** | 控制器，处理请求 |
| **Model** | 模型（pojo/action/service/dao） |
| **View** | 视图（jsp/freemarker/thymeleaf） |

---

## Spring MVC 请求流程

```
1. 请求 → DispatcherServlet（前端控制器）
2. DispatcherServlet → HandlerMapping 查找Handler
3. HandlerMapping → 返回Handler
4. DispatcherServlet → HandlerAdapter 执行Handler
5. HandlerAdapter → Handler
6. Handler → 返回 ModelAndView
7. DispatcherServlet → ViewResolver 解析视图
8. ViewResolver → 返回 View
9. View → 渲染模型数据
10. 响应结果
```

---

## 核心组件

| 组件 | 说明 |
|------|------|
| **DispatcherServlet** | 前端控制器，接收请求、响应结果 |
| **HandlerMapping** | 根据URL查找Handler |
| **HandlerAdapter** | 按规则执行Handler |
| **View Resolver** | 解析视图，解析真正的视图 |

---

## JSON数据交互

### 环境准备

1. 引入Jackson包
2. 配置 `<mvc:annotation-driven/>`

### 两种方式

| 方式 | 说明 |
|------|------|
| 请求json、输出json | 需要前端将请求转成json |
| 请求key/value、输出json | 常用方式 |

---

## 常用注解

| 注解 | 说明 |
|------|------|
| `@Controller` | 标注控制器 |
| `@RequestMapping` | 请求映射 |
| `@ResponseBody` | 返回JSON/XML |
| `@RequestBody` | 接收JSON参数 |
| `@PathVariable` | 路径参数 |
| `@RequestParam` | 请求参数 |
