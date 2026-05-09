package com.fomalhaut.websocktest.websock.server;

import org.springframework.util.StringUtils;
import org.springframework.web.socket.*;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * @author luke
 */
public class SystemNotifySocketHandler implements WebSocketHandler {
  /**
   * 在线用户
   */
  private static final Map<String, WebSocketSession> sessionPool = new HashMap();

  /**
   * 获取用户表示
   *
   * @return
   */
  private String getAccountpostByToken(WebSocketSession session) {
    String token = (String) session.getAttributes().get("token");
    return token;
  }

  /**
   * 成功建立websocket-spring连接
   *
   * @param session
   * @throws Exception
   */
  @Override
  public void afterConnectionEstablished(WebSocketSession session) throws Exception {
    System.out.println("成功建立websocket-spring连接");
    // 获取登陆唯一标识
    String accountpost = getAccountpostByToken(session);
    System.out.println("账号岗位ID = " + accountpost);
    // 岗位站号不是空
    if (!StringUtils.isEmpty(accountpost)) {
      // 添加至在线用户中
      sessionPool.put(accountpost, session);
      session.sendMessage(new TextMessage(accountpost + "成功建立连接"));
      System.out.println(accountpost + "成功建立连接");
    };
  }

  /**
   * 收到客户端信息
   *
   * @param session
   * @param message
   * @throws Exception
   */
  @Override
  public void handleMessage(WebSocketSession session, WebSocketMessage<?> message) throws Exception {
    System.out.println("收到客户端信息");
    Object payload = message.getPayload();
    System.out.println("接收到的信息 [" + payload + "]");
  }

  /**
   * 连接出错
   *
   * @param session
   * @param throwable
   * @throws Exception
   */
  @Override
  public void handleTransportError(WebSocketSession session, Throwable throwable) throws Exception {
    if (session.isOpen()) {
      session.close();
    }
    System.out.println("连接出错");
    sessionPool.remove(getAccountpostByToken(session));
  }

  @Override
  public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
    System.out.println("连接已关闭：" + status);
    sessionPool.remove(getAccountpostByToken(session));
  }

  @Override
  public boolean supportsPartialMessages() {
    return false;
  }

  /**
   * 给某个用户发送消息
   *
   * @param accountPsotId 账号岗位ID
   * @param message
   */
  public static boolean sendMessageToUser(String accountPsotId, String message) {
    boolean flag = false;
    WebSocketSession session = sessionPool.get(accountPsotId);
    if (session.getAttributes().get("token").equals(accountPsotId)) {
      try {
        if (session.isOpen()) {
          session.sendMessage(new TextMessage(message));
          flag = true;
        }
      } catch (IOException e) {
        e.printStackTrace();
      }
    }
    return flag;
  }
}
