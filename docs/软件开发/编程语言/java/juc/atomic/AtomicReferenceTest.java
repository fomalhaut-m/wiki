package atomic;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.StringJoiner;
import java.util.concurrent.atomic.AtomicMarkableReference;
import java.util.concurrent.atomic.AtomicReference;
import java.util.concurrent.atomic.AtomicStampedReference;

public class AtomicReferenceTest {


    public static void main(String[] args) {
        testAtomicMarkableReference();
    }

    public static void testAtomicReference() {

        Book juc = new Book("学习juc", 20L);
        Book java = new Book("java基础", 21L);
        Book pmp = new Book("pmp", 99L);

        AtomicReference atomicReference = new AtomicReference(juc);
        atomicReference.compareAndSet(juc, java);

        System.out.println("[更换结果 已更换] :" + atomicReference);

        atomicReference.compareAndSet(new Book("学习juc", 20L), java);

        System.out.println("[更换结果 未更换:重写hash和eq 无法更换] :" + atomicReference);

        System.out.println("由此得知, 对象引用,对比的是 内存引用地址");
    }


    public static void testAtomicStampedReference() {

        Book juc1 = new Book("juc第一版", 1L);
        Book juc2 = new Book("juc第贰版", 2L);

        AtomicStampedReference<Book> asr
                // 第一个参数 是对象 , 第二个是版本戳
                // 按理每次修改需要增加一次版本号
                = new AtomicStampedReference<>(juc1, 1);

        boolean b = asr.compareAndSet(juc1, juc2, 2, 2);
        System.err.println("[错误示例] " + b + " , [内容] " + asr);


        b = asr.compareAndSet(juc1, juc2, 1, 2);
        System.out.println("[正确示例] " + b + " , [内容] " + asr);

    }

    public static void testAtomicMarkableReference() {

        Book juc1 = new Book("juc第一版", 1L);
        Book juc2 = new Book("juc第贰版", 2L);

        AtomicMarkableReference<Book> asr
                // 给定标记, 其实类似于版本号,只不过只有 true 和 false 2个值
                = new AtomicMarkableReference<>(juc1, true);

        boolean b = asr.compareAndSet(juc1, juc2, false, true);
        System.err.println("[错误示例] " + b + " , [内容] " + asr);


        b = asr.compareAndSet(juc1, juc2, true, true);
        System.out.println("[正确示例] " + b + " , [内容] " + asr);

    }


    public static class Book {
        private String name;
        private long price;

        public Book(String name, long price) {
            this.name = name;
            this.price = price;
        }

        @Override
        public String toString() {
            return new StringJoiner(", ", Book.class.getSimpleName() + "[", "]")
                    .add("name='" + name + "'")
                    .add("price=" + price)
                    .toString();
        }
    }
}
