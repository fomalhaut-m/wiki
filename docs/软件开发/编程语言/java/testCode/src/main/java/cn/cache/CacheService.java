package cn.cache;

import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.annotation.*;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

////主要用于配置该类中会用到的一些共用的缓存配置
//@CacheConfig(
//        // 名称
//        cacheNames = {"test:cache"}
//        // 如果在操作级别没有设置任何参数，则使用此参数代替默认值。
//        // 密钥生成器与自定义密钥的使用是互斥的。当为操作定义了这样的键时，这个键生成器的值将被忽略。
//        // keyGenerator = "",
//        // 如果没有设置，则使用自定义org.springframework.cache.CacheManager的bean名来创建默认的org.springframework.cache.interceptor.CacheResolver。
//        // 如果在操作级没有设置任何解析器和缓存管理器，并且没有通过cacheResolver设置缓存解析器，则使用这个解析器代替默认设置。
//        // cacheManager = "",
//        // 要使用的自定义org.springframework.cache.interceptor.CacheResolver的bean名。
//        // 如果没有在操作级别设置解析器和缓存管理器，则使用此解析器代替默认设置。
//        // cacheResolver = ""
//        )
@Service
@Slf4j(topic = "cache")
@CacheConfig(cacheManager = "test1")
public class CacheService {

    // 主要方法返回值加入缓存。同时在查询时，会先从缓存中取，若不存在才再发起对数据库的访问。
    @Cacheable(value = "myCache")
    public String cacheable(String id) {
        log.info("get cacheable id = {}", id);
        return "cacheable : " + id;

    }

    // 配置于函数上，能够根据参数定义条件进行缓存，与@Cacheable不同的是，每次回真实调用函数，所以主要用于数据新增和修改操作上。
    @CachePut(value = "myCache", key = "#id")
    public String cachePut(String id, String msg) {
        log.info("put cachePut id = {},msg = {}", id, msg);
        return "cacheput [ id = " + id + ", msg = " + msg + " ]";

    }

    // 配置于函数上，通常用在删除方法上，用来从缓存中移除对应数据
    @CacheEvict(value = "myCache", key = "#id")
    public String cacheEvict(String id) {
        log.info("cache evict id = {} =", id);
        return "cacheevict";

    }

    // 配置于函数上，组合多个Cache注解使用。
    @Caching(put =
             @CachePut(value = "myCache", key = "#id"),
             cacheable =
             @Cacheable(value = "myCache", key = "#id"),
             evict =
             @CacheEvict(value = "myCache", key = "#id")
    )
    public String caching(String id) {
        return "caching";

    }
}
