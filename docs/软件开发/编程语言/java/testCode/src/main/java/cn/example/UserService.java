package cn.example;

import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserService {


    final UserExampleRepository userExampleRepository;

    public UserService(UserExampleRepository userExampleRepository) {
        this.userExampleRepository = userExampleRepository;
    }

    public List<User> findByUser(User user) {
        ExampleMatcher matching = ExampleMatcher.matchingAll();

        matching.withMatcher("name", ExampleMatcher.GenericPropertyMatchers.startsWith()); // 开始匹配
        matching.withMatcher("name", ExampleMatcher.GenericPropertyMatchers.endsWith()); // 末尾匹配
        matching.withMatcher("name", ExampleMatcher.GenericPropertyMatchers.contains()); // 包含
        matching.withMatcher("name", ExampleMatcher.GenericPropertyMatchers.caseSensitive()); // 大小写匹配
        matching.withMatcher("name", ExampleMatcher.GenericPropertyMatchers.exact()); // 精准查找
        matching.withMatcher("name", ExampleMatcher.GenericPropertyMatchers.regex()); // 正则表达式

        matching.withIgnoreNullValues(); // 忽略空值
        matching.withIncludeNullValues(); // 包含空值

        matching.isIgnoreCaseEnabled(); // 是否启动忽略大小写

        matching.withIgnorePaths("sex", "age"); // 以上规则无视的字段

        Sort.Order name = Sort.Order.desc("name"); // name 倒排

        List<User> users = userExampleRepository.findAll(Example.of(user, matching), Sort.by(name));


        Page<User> all = userExampleRepository.findAll(Example.of(user, matching), Pageable.unpaged());// 不分页


        Page<User> page = userExampleRepository.findAll(Example.of(user, matching), PageRequest.of(0 , 10));// 分页

        return users;
    }

}
