package com.fomalhaut.websocktest.websock.web;

import com.fomalhaut.websocktest.websock.server.SystemNotifySocketHandler;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

/**
 * @author luke
 */
@RestController("socket")
public class SocketController {
  @ResponseBody
  @GetMapping("send")
  public String sendSocketMessage(@RequestParam("user") String user, @RequestParam("msg") String msg) {
    SystemNotifySocketHandler.sendMessageToUser(user, msg);
    return "发送成功";
  }
}
