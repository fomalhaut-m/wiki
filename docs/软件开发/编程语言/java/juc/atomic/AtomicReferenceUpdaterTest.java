package atomic;

import java.util.StringJoiner;
import java.util.concurrent.atomic.AtomicLongFieldUpdater;
import java.util.concurrent.atomic.AtomicMarkableReference;
import java.util.concurrent.atomic.AtomicReference;
import java.util.concurrent.atomic.AtomicStampedReference;

public class AtomicReferenceUpdaterTest {


    public static void main(String[] args) {
        testLongUpdaterIsVolatile();
    }

    public static void testLongUpdaterIsVolatile() {
        AtomicLongFieldUpdater<Book> updater
                = AtomicLongFieldUpdater.newUpdater(Book.class, "price");

        // price 必须使用 volatile 关键字定义, 否则无法运行
        // Exception in thread "main" java.lang.IllegalArgumentException: Must be volatile type

        System.out.println(updater);
    }
    public static void testLongUpdater() {
        Book book = new Book("longUpdater", 100L);
        System.out.println("修改之前 : "+ book);

        // 修改属性, set 中实现了原子的属性修改
        book.setPrice(99L);

        System.out.println("修改之后 : "+ book);


        // 另一种写法, 不在set中

        AtomicLongFieldUpdater<Book> updater
                = AtomicLongFieldUpdater.newUpdater(Book.class, "price");
        updater.set(book,88L);

        System.out.println("第二次修改后 : "+ book);

    }


    public static class Book {
        private String name;
        private volatile long price;

        public Book(String name, long price) {
            this.name = name;
            this.price = price;
        }

        public void setPrice(long price) {

            AtomicLongFieldUpdater<Book> fieldUpdater
                    = AtomicLongFieldUpdater.newUpdater(Book.class, "price");

            fieldUpdater.set(this,price);
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
