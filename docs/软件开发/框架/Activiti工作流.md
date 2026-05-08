# Activiti 工作流

> 来源：Activiti笔记 | 标签：框架 / 工作流

---

## 什么是工作流

工作流(Workflow)：业务过程的部分或整体在计算机环境下的自动化。

> 将纸质流转方式转为自动化流程

---

## 工作流核心概念

| 概念 | 说明 |
|------|------|
| **流程定义** | 预定义的工作流规则 |
| **流程实例** | 流程定义的执行实例 |
| **任务** | 数据的流转、权限、状态 |

---

## 流程生命周期

```
流程定义 → 流程实例 → 任务执行 → 完成
```

---

## 常用API

| 服务 | 说明 |
|------|------|
| **RepositoryService** | 流程部署管理 |
| **RuntimeService** | 流程运行管理 |
| **TaskService** | 任务管理 |
| **HistoryService** | 历史记录 |

---

## 部署流程

```java
// classpath方式
RepositoryService repositoryService = processEngine.getRepositoryService();
Deployment deploy = repositoryService
    .createDeployment()
    .name("请假流程")
    .addClasspathResource("HelloWorld.bpmn")
    .addClasspathResource("HelloWorld.png")
    .deploy();

// zip方式
InputStream inputStream = getClass().getResourceAsStream("/流程.zip");
repositoryService
    .createDeployment()
    .name("请假流程")
    .addZipInputStream(new ZipInputStream(inputStream))
    .deploy();
```

---

## 启动流程

```java
RuntimeService runtimeService = processEngine.getRuntimeService();
// 通过key启动
runtimeService.startProcessInstanceByKey("流程定义Key");
```

---

## 查询任务

```java
TaskService taskService = processEngine.getTaskService();
List<Task> list = taskService
    .createTaskQuery()
    .taskAssignee("张三")
    .list();
```

---

## 办理任务

```java
TaskService taskService = processEngine.getTaskService();
taskService.complete("任务ID");
```

---

## 框架对比

| 框架 | BPMN2.0 | CMMN | DMN | 多实例加/减签 |
|------|:--------:|:----:|:---:|:------------:|
| Activiti5/6 | ✅ | ❌ | ❌ | ❌ |
| Flowable | ✅ | ✅ | ✅ | ✅ |
