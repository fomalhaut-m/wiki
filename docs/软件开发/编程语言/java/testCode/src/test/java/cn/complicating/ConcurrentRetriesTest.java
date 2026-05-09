package cn.complicating;

import cn.Application;
import cn.complicating.service.AccountService;
import cn.complicating.service.FinanceService;
import cn.complicating.support.Lock;
import lombok.extern.slf4j.Slf4j;
import org.databene.contiperf.PerfTest;
import org.databene.contiperf.junit.ContiPerfRule;
import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

@Slf4j(topic = "并发测试")
@RunWith(SpringRunner.class)
@SpringBootTest(classes = Application.class)
public class ConcurrentRetriesTest {

    @Rule
    public ContiPerfRule contiPerfRule = new ContiPerfRule();

    @Autowired
    FinanceService financeService;
    @Autowired
    AccountService accountService;

    @Test
    public void init() {
        log.info("{}初始化帐号 --- 开始", Thread.currentThread().getId());
        accountService.update(1, 10000d);
        accountService.update(2, 10000d);
        log.info("{}初始化帐号 --- 结束", Thread.currentThread().getId());
    }

    @Test
    public void after() {
        log.info("{}结束查询 --- 开始", Thread.currentThread().getId());
        System.out.println("帐号 1 = " + accountService.find(1).get());
        System.out.println("帐号 2 = " + accountService.find(2).get());
        log.info("{}结束查询 --- 结束", Thread.currentThread().getId());
    }

    /**
     * 收款
     */
    @Test
    public void collection() {
        log.info("线程[{}]工作... 普通收款", Thread.currentThread().getId());
        try {
            log.info("线程[{}]工作... 收款", Thread.currentThread().getId());
            financeService.collection(1, 500);
        } catch (Lock.LockException e) {
            log.error("线程[{}]工作... 抢锁异常 ... 并重试失败", Thread.currentThread().getId());
        }
    }


    /**
     * 并发收款
     */
    @Test
    @PerfTest(invocations = 200, threads = 100)
    public void beComplicatedByCollection() {
        log.info("线程[{}]工作... 并发收款", Thread.currentThread().getId());
        try {
            log.info("线程[{}]工作... 收款", Thread.currentThread().getId());
            financeService.collection(1, 1);
        } catch (Lock.LockException e) {
            log.error("线程[{}]工作... 抢锁异常 ... 并重试失败", Thread.currentThread().getId());
        }
    }


    /**
     * 转账
     */
    @Test
    public void transfer() {
        log.info("线程[{}]工作... 普通转账", Thread.currentThread().getId());
        try {
            log.info("线程[{}]工作... 转账", Thread.currentThread().getId());
            financeService.transfer(1, 2, 500);
        } catch (Lock.LockException e) {
            log.error("线程[{}]工作... 抢锁异常 ... 并重试失败", Thread.currentThread().getId());
        }
    }

    /**
     * 并发转账1
     */
    @Test
    @PerfTest(invocations = 200, threads = 50)
    public void beComplicatedByTransfer() {
        log.info("线程[{}]工作... 普通转账", Thread.currentThread().getId());
        try {
            log.info("线程[{}]工作... 转账", Thread.currentThread().getId());
            financeService.transfer(1, 2, 5);
        } catch (Lock.LockException e) {
            log.error("线程[{}]工作... 抢锁异常 ... 并重试失败", Thread.currentThread().getId());
        }
    }
    /**
     * 并发转账2
     */
    @Test
    @PerfTest(invocations = 400, threads = 50)
    public void beComplicatedByTransfer2() {
        log.info("线程[{}]工作... 普通转账", Thread.currentThread().getId());
        try {
            log.info("线程[{}]工作... 转账", Thread.currentThread().getId());
            financeService.transfer(1, 2, 10);
        } catch (Lock.LockException e) {
            log.error("线程[{}]工作... 抢锁异常 ... 并重试失败", Thread.currentThread().getId());
        }
    }


}
