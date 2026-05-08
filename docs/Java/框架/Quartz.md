# Quartz 任务调度

## 概述

Quartz 是 Java 开源任务调度框架，支持** cron 表达式**、集群模式。

## 核心概念

| 概念 | 说明 |
|------|------|
| Job | 任务，具体要执行的工作 |
| JobDetail | 任务的描述信息 |
| Trigger | 触发器，定义执行时间和规则 |
| Scheduler | 调度器，把 Job 和 Trigger 绑定 |

## 快速使用

### 定义 Job

```java
public class MyJob implements Job {
    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
        System.out.println("任务执行，当前时间：" + new Date());
    }
}
```

### 绑定 Job 和 Trigger

```java
Scheduler scheduler = StdSchedulerFactory.getDefaultScheduler();

// JobDetail
JobDetail job = JobBuilder.newJob(MyJob.class)
    .withIdentity("myJob", "group1")
    .build();

// Trigger（简单触发器）
Trigger trigger = TriggerBuilder.newTrigger()
    .withIdentity("myTrigger", "group1")
    .startNow()
    .withSchedule(SimpleScheduleBuilder.simpleSchedule()
        .withIntervalInSeconds(10)
        .repeatForever())
    .build();

// 注册并启动
scheduler.scheduleJob(job, trigger);
scheduler.start();
scheduler.shutdown();
```

## Trigger 类型

### SimpleTrigger

```java
.withSchedule(SimpleScheduleBuilder.simpleSchedule()
    .withIntervalInMinutes(1)
    .withRepeatCount(10))  // 执行 11 次
```

### CronTrigger（推荐）

```java
.withSchedule(CronScheduleBuilder.cronSchedule("0 0 8 * * ?"))  // 每天 8 点
.withSchedule(CronScheduleBuilder.cronSchedule("0 30 18 ? * MON-FRI"))  // 工作日 18:30
```

### Cron 表达式

```
秒 分 时 日 月 周
0 0 12 * * ?       每天 12:00
0 30 8 * * ?       每天 8:30
0 0/5 * * * ?      每 5 分钟
0 0 9 ? * 2#3      每月第 3 个周一 9:00
```

## Spring Boot 整合

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-quartz</artifactId>
</dependency>
```

```java
@Configuration
public class QuartzConfig {

    @Bean
    public JobDetail myJobDetail() {
        return JobBuilder.newJob(MyJob.class)
            .withIdentity("myJob", "group1")
            .storeDurably()
            .build();
    }

    @Bean
    public Trigger myTrigger() {
        return TriggerBuilder.newTrigger()
            .forJob(myJobDetail())
            .withIdentity("myTrigger", "group1")
            .withSchedule(CronScheduleBuilder.cronSchedule("0/10 * * * * ?"))
            .build();
    }
}
```
