package cn.cache.comfig;

import com.google.common.collect.Lists;
import org.springframework.cache.Cache;
import org.springframework.cache.CacheManager;
import org.springframework.cache.support.SimpleCacheManager;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.data.redis.cache.RedisCache;
import org.springframework.data.redis.cache.RedisCacheConfiguration;
import org.springframework.data.redis.cache.RedisCacheManager;
import org.springframework.data.redis.cache.RedisCacheWriter;
import org.springframework.data.redis.connection.RedisConnectionFactory;

import java.util.List;

@Configuration
public class CacheConfig {

    @Bean(value = "test1")
    public CacheManager cacheManager1( RedisConnectionFactory redisConnectionFactory){
        SimpleCacheManager simpleCacheManager = new SimpleCacheManager();
        List<Cache> caches = Lists.newArrayList();
        Cache redisCache = RedisCacheManager.builder().cacheWriter(RedisCacheWriter.nonLockingRedisCacheWriter( redisConnectionFactory)).build().getCache("redisCache");
        caches.add(redisCache);
        simpleCacheManager.setCaches(caches);
        return simpleCacheManager;
    }
}
