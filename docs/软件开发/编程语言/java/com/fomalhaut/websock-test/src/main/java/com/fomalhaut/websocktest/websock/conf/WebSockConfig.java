package com.fomalhaut.websocktest.websock.conf;

import com.fomalhaut.websocktest.websock.server.SystemNotifySocketHandler;
import com.fomalhaut.websocktest.websock.server.SystemNotifySocketHandshakeInterceptor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

/**
 * @author luke
 */
@Configuration
public class WebSockConfig {
  /**
   * 注册拦截器
   */
  @Configuration
  @EnableWebMvc
  @EnableWebSocket
  public class WebSocketConfig implements WebMvcConfigurer, WebSocketConfigurer {
    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
      //注册 系统通知socket服务
      registry.addHandler(systemNotifySocketHandler(), "/systemInfoSocketServer").addInterceptors(new SystemNotifySocketHandshakeInterceptor()).setAllowedOrigins("*");
      registry.addHandler(systemNotifySocketHandler(), "/sockjs/systemInfoSocketServer").addInterceptors(new SystemNotifySocketHandshakeInterceptor()).setAllowedOrigins("*").withSockJS();
    }

    @Bean
    public SystemNotifySocketHandler systemNotifySocketHandler() {
      return new SystemNotifySocketHandler();
    }
  }
}
