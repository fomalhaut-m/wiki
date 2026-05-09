package cn.complicating.service;

import cn.complicating.support.Lock;
import lombok.extern.slf4j.Slf4j;
import org.springframework.retry.annotation.Retryable;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * The type Finance service.
 *
 * @author luke
 * @date
 */
@Slf4j(topic = "财务service")
@Service
public class FinanceService {

    @Resource
    private PayService payService;
    @Resource
    private Lock lock;

    public static volatile int numberOfRetries = 1;

    public static volatile int abnormalTimes = 1;


    /**
     * 收款
     *
     * @param accountNumber 帐号
     * @param receiptFunds  收款资金
     */
    @Retryable(value = {Lock.LockException.class}, maxAttempts = 5)
    public void collection(int accountNumber, double receiptFunds) throws Lock.LockException {
        log.info("线程[{}]工作... 第{}次", Thread.currentThread().getId(), numberOfRetries++);
        log.info("线程[{}]工作... 收款 --- 收款 --- 抢锁 <<<", Thread.currentThread().getId());
        lock.locked(accountNumber);
        log.info("线程[{}]工作... 收款 --- 收款--- 开始 <<<", Thread.currentThread().getId());
        try {
            payService.pay(accountNumber, receiptFunds);
        } catch (Exception e) {
            log.error("线程[{}]工作... 收款 数据库异常 , 第{}次", Thread.currentThread().getId(), abnormalTimes++);
        }

        lock.releaseLock(accountNumber);
        log.info("线程[{}]工作... 收款 --- 收款变动 --- 结束 <<<", Thread.currentThread().getId());
    }

    /**
     * 转账
     *
     * @param paymentAccount   付款帐户
     * @param receivingAccount 收款账户
     * @param receiptFunds     收款资金
     */
    @Retryable(value = {Lock.LockException.class}, maxAttempts = 5)
    public void transfer(int paymentAccount, int receivingAccount, double receiptFunds) throws Lock.LockException {
        log.info("线程[{}]工作... 第{}次", Thread.currentThread().getId(), numberOfRetries++);
        log.info("线程[{}]工作... 转账 {}--- {} 资转账 --- 抢锁 <<<", Thread.currentThread().getId(), paymentAccount, receivingAccount);
        lock.locked(paymentAccount);
        lock.locked(receivingAccount);
        log.info("线程[{}]工作... 转账 {}--- {} 转账--- 开始 <<<", Thread.currentThread().getId(), paymentAccount, receivingAccount);
        try {
            payService.pay(paymentAccount, -receiptFunds);
            payService.pay(receivingAccount, receiptFunds);
        } catch (Exception e) {
            log.error("线程[{}]工作... 转账 {}--- {} 数据库异常 , 第{}次", Thread.currentThread().getId(), abnormalTimes++, paymentAccount, receivingAccount);
        }

        lock.releaseLock(paymentAccount);
        lock.releaseLock(receivingAccount);
        log.info("线程[{}]工作... 转账 --- 转账变动 --- 结束 <<<", Thread.currentThread().getId());
    }
}
