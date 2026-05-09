package com.fomalhaut.websocktest.websock.server;

import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.HandshakeInterceptor;

import java.util.Map;

/**
 * @author luke
 */
public class SystemNotifySocketHandshakeInterceptor implements HandshakeInterceptor {
  /**
   * 关联HttpSession和WebSocketSession，
   * beforeHandShake方法中的Map参数 就是对应websocketSession里的属性
   *
   * @param request
   * @param response
   * @param webSocketHandler
   * @param map
   * @return
   * @throws Exception
   */
  @Override
  public boolean beforeHandshake(ServerHttpRequest request, ServerHttpResponse response, WebSocketHandler webSocketHandler, Map<String, Object> map) throws Exception {
    if (request instanceof ServletServerHttpRequest) {
      ServletServerHttpRequest r = (ServletServerHttpRequest) request;
      String token = r.getServletRequest().getParameter("token");
      map.put("token", token);
    }
    return true;
  }

  @Override
  public void afterHandshake(ServerHttpRequest serverHttpRequest, ServerHttpResponse serverHttpResponse, WebSocketHandler webSocketHandler, Exception e) {

  }
}
