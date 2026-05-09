package cn.complicating.support;

import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.time.Instant;
import java.util.Objects;
import java.util.concurrent.TimeUnit;

/**
 * @author luke
 * @date
 */
@Slf4j(topic = "锁")
@Component
public class Lock {

    @Resource
    RedisTemplate<Integer, Long> redisTemplate;

    public void locked(int id) throws LockException {
        log.info("抢锁 [{}]",id);
        Boolean ifAbsent = redisTemplate.boundValueOps(id).setIfAbsent(Instant.now().toEpochMilli(), 5, TimeUnit.SECONDS);
        if (Objects.isNull(ifAbsent) || !ifAbsent) {
            log.error("没有抢到锁 [{}]",id);
            throw new LockException("没有抢到锁");
        }
        log.info("抢到锁 [{}]",id);
    }

    public void releaseLock(int id) {
        redisTemplate.delete(id);
        log.debug("释放锁");
    }

    public class LockException extends Exception {
        public LockException(String message) {
            super(message);
        }
    }
}
