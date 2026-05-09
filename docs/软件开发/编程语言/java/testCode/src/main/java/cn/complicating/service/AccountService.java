package cn.complicating.service;

import cn.complicating.repository.Account;
import cn.complicating.repository.AccountRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

/**
 * @author luke
 * @date
 */
@Slf4j(topic = "帐号service")
@Service
public class AccountService {
    @Autowired
    private AccountRepository accountRepository;


    @Transactional
    public void update(long accountNumber, double variableFunds) {
        accountRepository.save(new Account(accountNumber, variableFunds));
    }

    @Transactional
    public Optional<Account> find(long accountNumber) {
       return accountRepository.findById(accountNumber);
    }

    @Transactional
    public void fundingChanges(long accountNumber, double variableFunds) {
        log.info("线程[{}]工作... 帐号:{} --- 查找", Thread.currentThread().getId(), accountNumber);
        Account one = accountRepository.getOne(accountNumber);
        double money = one.getMoney() + variableFunds;
        log.info("线程[{}]工作... 帐号:{}  --- 资金变动 [{}] >>> [{}]", Thread.currentThread().getId(), accountNumber, variableFunds, money);
        one.setMoney(money);
        log.info("线程[{}]工作... 帐号:{}  --- 持久化", Thread.currentThread().getId(), accountNumber);
        accountRepository.save(one);
        log.info("线程[{}]工作... 帐号:{}  --- 持久化完成", Thread.currentThread().getId(), accountNumber);
    }
}
