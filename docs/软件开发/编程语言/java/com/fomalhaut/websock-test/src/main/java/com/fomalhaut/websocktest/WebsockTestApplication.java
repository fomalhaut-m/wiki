package com.fomalhaut.websocktest;

import com.fomalhaut.websocktest.websock.conf.WebSockConfig;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.context.annotation.Import;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication(scanBasePackages = {"com.fomalhaut.websocktest.websock.web"})
@EnableScheduling
@Import(value = { WebSockConfig.class })
public class WebsockTestApplication {
  public static void main(String[] args) {
    SpringApplication.run(WebsockTestApplication.class, args);
  }

}
