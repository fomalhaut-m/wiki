import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.SelectionKey;
import java.nio.channels.Selector;
import java.nio.channels.SocketChannel;
import java.util.Iterator;

public class NIOExampleClient {

    public static void main(String[] args) throws IOException {
        SocketChannel socketChannel = SocketChannel.open();
        socketChannel.configureBlocking(false); // 设置为非阻塞模式

        // 连接到服务器
        boolean isConnected = socketChannel.connect(new InetSocketAddress("localhost", 8080));
        while (!isConnected) {
            Selector selector = Selector.open();
            socketChannel.register(selector, SelectionKey.OP_CONNECT);
            selector.select();
            Iterator<SelectionKey> keys = selector.selectedKeys().iterator();
            while (keys.hasNext()) {
                SelectionKey key = keys.next();
                keys.remove();
                if (key.isConnectable()) {
                    SocketChannel channel = (SocketChannel) key.channel();
                    isConnected = channel.finishConnect();
                }
            }
        }

        System.out.println("已连接到服务器");

        // 使用控制台输入发送消息

        while (true) {
            // 等待控制台输入
            System.out.print("请输入消息：");

            String message = new java.util.Scanner(System.in).nextLine();

            // 发送消息
            ByteBuffer buffer = ByteBuffer.wrap(message.getBytes());
            socketChannel.write(buffer);
            System.out.println("已发送消息：" + message);

            // 读取服务器返回的消息
            ByteBuffer readBuffer = ByteBuffer.allocate(1024);
            int bytesRead = socketChannel.read(readBuffer);
            if (bytesRead > 0) {
                readBuffer.flip();
                byte[] bytes = new byte[readBuffer.remaining()];
                readBuffer.get(bytes);
                String receivedMessage = new String(bytes);
                System.out.println("收到服务器消息：" + receivedMessage);
            }

            if (message.equals("exit")) {
                break;
            }
        }

    }
}
