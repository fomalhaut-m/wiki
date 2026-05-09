// 引入包

import java.io.*;

// 文件 NIO 示例
public class NIOExample {

   // 向文件写入一段话, 再读出来
    public static void main(String[] args) throws Exception {
            // 创建一个文件
            File file = new File("test.txt");
            // 创建一个文件输出流
            FileOutputStream fos = new FileOutputStream(file);
            // 创建一个文件输出流缓冲区
            BufferedOutputStream bos = new BufferedOutputStream(fos);
            // 写入一段话
            bos.write("Hello World!".getBytes());
            // 关闭输出流
            bos.close();
            System.out.println("文件已写入");


            // 创建一个文件输入流
            FileInputStream fis = new FileInputStream(file);
            // 创建一个文件输入流缓冲区
            BufferedInputStream bis = new BufferedInputStream(fis);
            byte[] buffer = new byte[1024];
            int length = bis.read(buffer);
            while (length != -1) {
                System.out.println(new String(buffer, 0, length));
                length = bis.read(buffer);
            }
            bis.close();
            file.delete();
            System.out.println("文件已删除");
    }

}