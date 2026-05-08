# SpringMVC

## 工作流程

```
浏览器请求
    ↓
DispatcherServlet（前端控制器）
    ↓
HandlerMapping（找到处理器）
    ↓
HandlerAdapter（执行处理器）
    ↓
Controller（业务逻辑）
    ↓
ViewResolver（视图解析器）
    ↓
View（渲染视图）
    ↓
响应浏览器
```

## 常用注解

| 注解 | 说明 |
|------|------|
| `@Controller` | 标记控制层 |
| `@RequestMapping` | 请求映射 |
| `@GetMapping / @PostMapping` | GET/POST 专用映射 |
| `@RequestParam` | 接收请求参数 |
| `@PathVariable` | 接收路径参数 |
| `@RequestBody` | 接收 JSON 请求体 |
| `@ResponseBody` | 返回 JSON（非视图） |
| `@RestController` | = @Controller + @ResponseBody |
| `@ModelAttribute` | 接收模型属性 |
| `@SessionAttributes` | 把模型属性存 session |
| `@Validated` | 参数校验 |

## 参数接收

```java
// 基本类型（自动转换）
@RequestMapping("/get")
public String get(@RequestParam(defaultValue = "1") int id) { }

// 路径参数
@RequestMapping("/user/{id}")
public String getUser(@PathVariable Integer id) { }

// JSON 请求体
@RequestMapping("/save")
public String save(@RequestBody User user) { }

// 表单参数
public String save(@ModelAttribute User user) { }
```

## 数据响应

```java
// 返回字符串（视图名）
return "user/detail";

// 返回 JSON（对象自动转 JSON）
@ResponseBody
public User getUser() {
    return new User("luke", 26);
}

// 返回视图 + 模型
public ModelAndView getUser() {
    ModelAndView mv = new ModelAndView("user");
    mv.addObject("user", user);
    return mv;
}

// 转发 / 重定向
return "forward:/other";
return "redirect:/other";
```

## RESTful 风格

```java
@GetMapping("/users")       // 查所有
@GetMapping("/users/{id}") // 查一个
@PostMapping("/users")      // 新增
@PutMapping("/users/{id}")  // 修改
@DeleteMapping("/users/{id}") // 删除
```

## 处理模型数据

```java
// ModelAndView
@RequestMapping("/test")
public ModelAndView test() {
    ModelAndView mv = new ModelAndView("test");
    mv.addObject("name", "luke");
    return mv;
}

// Model / ModelMap
public String test(Model model) {
    model.addAttribute("name", "luke");
    return "test";
}

// @SessionAttributes — 在类上标记
@SessionAttributes("user")
public class UserController { }
```

## 静态资源处理

```xml
<!-- 方式一：mvc:default-servlet-handler -->
<mvc:default-servlet-handler/>

<!-- 方式二：mvc:resources -->
<mvc:resources mapping="/static/**" location="/static/"/>
<mvc:resources mapping="/js/**" location="/js/"/>
```

## 异常处理

```java
// 方式一：@ExceptionHandler
@ExceptionHandler(Exception.class)
public ModelAndView handleException(Exception e) {
    ModelAndView mv = new ModelAndView("error");
    mv.addObject("msg", e.getMessage());
    return mv;
}

// 方式二：SimpleMappingExceptionResolver
@Bean
public SimpleMappingExceptionResolver exceptionResolver() {
    SimpleMappingExceptionResolver r = new SimpleMappingExceptionResolver();
    r.setDefaultErrorView("error");
    r.setExceptionAttribute("msg");
    return r;
}
```

## 文件上传

```java
@PostMapping("/upload")
public String upload(@RequestParam("file") MultipartFile file) throws IOException {
    if (!file.isEmpty()) {
        file.transferTo(new File("/upload/" + file.getOriginalFilename()));
    }
    return "success";
}
```

**配置：**
```properties
spring.servlet.multipart.max-file-size=10MB
spring.servlet.multipart.max-request-size=50MB
```
