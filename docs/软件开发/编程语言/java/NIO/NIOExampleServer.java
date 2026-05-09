import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.SelectionKey;
import java.nio.channels.Selector;
import java.nio.channels.ServerSocketChannel;
import java.nio.channels.SocketChannel;
import java.util.Iterator;

public class NIOExampleServer {


    public static void main(String[] args) throws IOException {
        // 创建ServerSocketChannel, 这行代码创建了一个ServerSocketChannel实例，它是用于监听新进来的TCP连接的通道。
        ServerSocketChannel serverSocketChannel = ServerSocketChannel.open();
        // 设置为非阻塞模式, 这行代码将ServerSocketChannel设置为非阻塞模式，意味着当执行如accept()或read()等操作时，如果没有数据可读或没有连接可接受，操作会立即返回而不是阻塞等待。
        serverSocketChannel.configureBlocking(false);

        // 绑定端口, 此操作将服务器绑定到本地的8080端口，以便开始监听来自客户端的连接请求。
        serverSocketChannel.bind(new InetSocketAddress(8080));

        // 创建Selector并注册ServerSocketChannel到Selector上，监听ACCEPT事件
        // Selector是NIO的核心组件，用于检查一个或多个Channel是否有可以进行I/O操作的事件（如读、写、连接接受等）。
        Selector selector = Selector.open();

        //register(selector, SelectionKey.OP_ACCEPT)将ServerSocketChannel注册到Selector上，并指定感兴趣的事件为OP_ACCEPT，即监听新的连接请求。
        serverSocketChannel.register(selector, SelectionKey.OP_ACCEPT);

        System.out.println("服务器已启动，等待连接...");

        // 主循环等待连接与数据: 这个无限循环是服务器的核心逻辑，持续监控Selector以处理就绪的事件
        while (true) {
            // 选择一组键，其相应的通道已为 I/O 操作准备就绪。
            // selector.select()会阻塞直到至少有一个通道在你注册的事件上就绪。
            // 随后遍历selectedKeys()迭代器，这些键表示已就绪的通道及其事件。
            selector.select();

            // 获取此选择器的已选择键集
            Iterator<SelectionKey> iterator = selector.selectedKeys().iterator();
            System.out.println("准备就绪的键数量: " + selector.selectedKeys().size());
            while (iterator.hasNext()) {

                SelectionKey key = iterator.next();
                System.out.println("准备就绪的键: " + key);

                iterator.remove(); // 防止重复处理

                // 当有新的客户端连接请求到达时，此分支被执行，接受连接并将新客户端的SocketChannel设置为非阻塞模式，然后注册到Selector上监听读事件(OP_READ)。
                if (key.isAcceptable()) {
                    System.out.println("接收连接就绪");
                    // 若接收连接就绪
                    ServerSocketChannel server = (ServerSocketChannel) key.channel();
                    SocketChannel client = server.accept(); // 接受连接
                    client.configureBlocking(false); // 设置为非阻塞模式
                    client.register(selector, SelectionKey.OP_READ); // 注册到selector，监听READ事件
                    System.out.println("新客户端连接: " + client);
                } else
                    // 当已建立连接的客户端有数据可读时，调用readData(key)方法来处理读取数据的操作。这里readData是一个自定义方法，需要单独实现来处理实际的数据读取逻辑。
                    if (key.isReadable()) {
                    // 若读就绪
                    readData(key);

                }
            }
        }
    }

    private static void readData(SelectionKey key) throws IOException {
        SocketChannel client = (SocketChannel) key.channel();

        ByteBuffer buffer = ByteBuffer.allocate(1024);

        int readBytes = client.read(buffer);

        if (readBytes > 0) {

            buffer.flip();
            String data = new String(buffer.array(), 0, readBytes);
            System.out.println("接收到消息: " + data);
            ByteBuffer outBuffer = ByteBuffer.wrap(data.getBytes());

            switch (data) {
                // 简单写一个固定的对话
                case "你好":
                    outBuffer = ByteBuffer.wrap("你好".getBytes());
                    break;
                case "你好吗":
                    outBuffer = ByteBuffer.wrap("我很好".getBytes());
                    break;
                case "你叫什么名字":
                    outBuffer = ByteBuffer.wrap("我叫小明".getBytes());
                    break;
                case "你今年几岁":
                    outBuffer = ByteBuffer.wrap("我今年18岁".getBytes());
                    break;
                case "你喜欢什么":
                    outBuffer = ByteBuffer.wrap("我喜欢吃鸡腿".getBytes());
                    break;
                case "你喜欢吃什么":
                    outBuffer = ByteBuffer.wrap("我喜欢吃鸡腿".getBytes());
                    break;
                default:
                    outBuffer = ByteBuffer.wrap("未知消息".getBytes());
            }
            System.out.println("发送消息给客户端: " + outBuffer);

            client.write(outBuffer); // 将接收到的消息回传给客户端
            buffer.clear();

        } else {

            client.close();
        }
    }
}
