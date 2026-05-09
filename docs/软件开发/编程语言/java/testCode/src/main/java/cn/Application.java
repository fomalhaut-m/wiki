package cn;

import com.ulisesbocchio.jasyptspringboot.environment.StandardEncryptableEnvironment;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.retry.annotation.EnableRetry;

@EnableCaching
@EnableRetry
@SpringBootApplication()
@Slf4j(topic = "Application.class")
public class Application {

    public static void main(String[] args) {
        new SpringApplicationBuilder()
                .environment(new StandardEncryptableEnvironment())
                .sources(Application.class).run(args);
        log.info("  __                   __                              .___      \n" +
                "_/  |_  ____   _______/  |_             ____  ____   __| _/____  \n" +
                "\\   __\\/ __ \\ /  ___/\\   __\\  ______  _/ ___\\/  _ \\ / __ |/ __ \\ \n" +
                " |  | \\  ___/ \\___ \\  |  |   /_____/  \\  \\__(  <_> ) /_/ \\  ___/ \n" +
                " |__|  \\___  >____  > |__|             \\___  >____/\\____ |\\___  >\n" +
                "           \\/     \\/                       \\/           \\/    \\/ ");
    }
}
