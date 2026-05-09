package cn.complicating.service;

import cn.complicating.support.Lock;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * @author luke
 * @date
 */
@Slf4j(topic = "支付service")
@Service
public class PayService {
    @Resource
    private AccountService accountService;


    public void pay(int accountNumber, double variableFunds) throws Lock.LockException {
        accountService.fundingChanges(accountNumber, variableFunds); 
    }
}
