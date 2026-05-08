# Activiti 工作流

## 概述

Activiti 是轻量级开源 BPMN（Business Process Model and Notation）引擎，用于**流程设计、部署、执行和管理**。

## 核心 API

| API | 说明 |
|------|------|
| `RepositoryService` | 流程定义（部署/查询） |
| `RuntimeService` | 流程运行（启动/查询实例） |
| `TaskService` | 任务办理（签收/完成） |
| `HistoryService` | 历史记录 |
| `IdentityService` | 用户/组管理 |

## 流程定义与部署

### 部署流程（BPMN 文件）

```java
RepositoryService rs = processEngine.getRepositoryService();

// 部署（从 classpath）
Deployment deploy = rs.createDeployment()
    .addClasspathResource("processes/myProcess.bpmn")
    .name("请假流程")
    .deploy();

System.out.println("部署ID: " + deploy.getId());
```

### 查询流程定义

```java
List<ProcessDefinition> list = rs.createProcessDefinitionQuery()
    .processDefinitionKey("leaveProcess")
    .latestVersion()
    .list();
```

## 流程实例

### 启动实例

```java
RuntimeService runtimeService = processEngine.getRuntimeService();

ProcessInstance instance = runtimeService.startProcessInstanceByKey("leaveProcess",
    Collections.singletonMap("employee", "luke"));

System.out.println("实例ID: " + instance.getId());
```

### 完成任务

```java
TaskService taskService = processEngine.getTaskService();

// 查询当前任务
Task task = taskService.createTaskQuery()
    .processInstanceId(instance.getId())
    .taskAssignee("manager")
    .singleResult();

// 完成任务
taskService.complete(task.getId());
```

## BPMN 2.0 要素

### 用户任务

```xml
<userTask id="submitLeave" name="提交请假" activiti:assignee="${employee}"/>
<userTask id="approveLeave" name="经理审批" activiti:assignee="manager"/>
```

### 排他网关（分支）

```xml
<exclusiveGateway id="approvalGateway" name="审批网关"/>
<!-- 流程走向：${approved == true} → 同意航线否 → 拒绝航线 -->
```

### 流程变量

```java
// 设置变量
runtimeService.setVariable(instance.getId(), "days", 5);
runtimeService.setVariable(instance.getId(), "approved", true);

// 获取变量
Integer days = (Integer) runtimeService.getVariable(instance.getId(), "days");
```

## 监听器

```java
// 执行监听器
<userTask id="someTask" name="Some Task">
  <extensionElements>
    <activiti:taskListener event="complete"
      class="com.example.MyTaskListener"/>
  </extensionElements>
</userTask>
```

```java
public class MyTaskListener implements TaskListener {
    @Override
    public void notify(DelegateTask delegateTask) {
        delegateTask.setVariable("listenerVar", "已执行");
    }
}
```

## Spring Boot 整合

```xml
<dependency>
    <groupId>org.activiti</groupId>
    <artifactId>activiti-spring-boot-starter</artifactId>
</dependency>
```

```properties
spring.activiti.database-schema-update=true
spring.activiti.check-process-definitions=true
spring.activiti.history-level=full
```
