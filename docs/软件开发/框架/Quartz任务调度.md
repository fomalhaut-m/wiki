# Quartz 任务调度

> 来源：Quartz笔记 | 标签：Java / 调度 / Quartz

---

## 三大核心概念

| 概念 | 说明 |
|------|------|
| **Scheduler** | 调度器，负责管理任务和触发器 |
| **JobDetail** | 任务定义，包含任务的业务逻辑 |
| **Trigger** | 触发器，定义任务的执行时机 |

> 一个 Job 可以对应多个 Trigger，但一个 Trigger 只能对应一个 Job

---

## 创建调度器

```java
SchedulerFactory sf = new StdSchedulerFactory();
Scheduler scheduler = sf.getScheduler();
```

---

## 常用 API

| 方法 | 说明 |
|------|------|
| `scheduleJob(jobDetail, trigger)` | 调度任务，返回开始时间 |
| `start()` | 启动调度器 |
| `standby()` | 挂起（暂停）调度器 |
| `shutdown()` | 关闭调度器 |
| `rescheduleJob(triggerName, trigger)` | 重新调度已存在的任务 |

---

## Trigger 类型

### SimpleTrigger — 固定时间/间隔

```java
Trigger trigger = TriggerBuilder.newTrigger()
    .withIdentity("myTrigger", "group1")
    .startNow()
    .withSchedule(SimpleScheduleBuilder.simpleSchedule()
        .withIntervalInSeconds(5)
        .repeatForever())
    .build();
```

### CronTrigger — Cron表达式

```java
Trigger trigger = TriggerBuilder.newTrigger()
    .withIdentity("myTrigger", "group1")
    .withSchedule(CronScheduleBuilder.cronSchedule("0 0 10 * * ?"))
    .build();
```

---

## JobDetail 示例

```java
JobDetail jobDetail = JobBuilder.newJob(MyJob.class)
    .withIdentity("myJob", "group1")
    .usingManifestData("key", "value")
    .build();

// 执行时获取数据
@Override
public void execute(JobExecutionContext context) throws Exception {
    JobDataMap data = context.getJobDetail().getJobDataMap();
    String value = data.getString("key");
}
```

---

## CRON 表达式

| 位置 | 说明 | 范围 |
|------|------|------|
| 1 | 秒 | 0-59 |
| 2 | 分钟 | 0-59 |
| 3 | 小时 | 0-23 |
| 4 | 日 | 1-31 |
| 5 | 月 | 1-12 |
| 6 | 周 | 1-7（1=周日） |

### 常用示例

| 表达式 | 含义 |
|--------|------|
| `0 0 10 * * ?` | 每天上午10点 |
| `0 0/5 * * * ?` | 每5分钟 |
| `0 30 9 * * ?` | 每天9:30 |
| `0 0 12 * * ?` | 每天中午12点 |
